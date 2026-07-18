import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bean/mine_sweeper_cell_bean.dart';
import '../bean/mine_sweeper_game_config_bean.dart';
import '../enum/mine_sweeper_cell_status.dart';
import '../enum/mine_sweeper_game_status.dart';

/// 扫雷游戏逻辑控制器
class MineSweeperNotifier extends ChangeNotifier {
  final Random _random = Random();
  Timer? _timer;

  /// 棋盘数据
  late List<List<MineSweeperCellBean>> board;

  /// 游戏状态
  MineSweeperGameStatus gameStatus = MineSweeperGameStatus.idle;

  /// 游戏配置
  MineSweeperGameConfigBean config;

  /// 已用时间（秒）
  int elapsedSeconds = 0;

  /// 剩余旗帜数
  int remainingFlags = 0;

  /// 已标记的格子数
  int get flaggedCount => config.mineCount - remainingFlags;

  /// 是否为首次点击
  bool isFirstClick = true;

  /// 是否处于标记模式（开启后点击格子改为标记/取消旗帜）
  bool isMarkMode = false;

  MineSweeperNotifier(this.config) {
    _initEmptyBoard();
  }

  /// 创建空棋盘
  void _initEmptyBoard() {
    board = List.generate(
      config.rows,
      (_) => List.generate(config.cols, (_) => const MineSweeperCellBean()),
    );
    remainingFlags = config.mineCount;
  }

  /// 初始化游戏（布雷），排除首次点击位置
  void _initBoard(int safeRow, int safeCol) {
    final rows = config.rows;
    final cols = config.cols;

    // 生成所有可放雷的位置，排除安全区域
    final allPositions = <Point<int>>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if ((r - safeRow).abs() <= 1 && (c - safeCol).abs() <= 1) continue;
        allPositions.add(Point(r, c));
      }
    }
    allPositions.shuffle(_random);

    final minePositions = <Point<int>>{};
    final mineCount = min(config.mineCount, allPositions.length);
    for (int i = 0; i < mineCount; i++) {
      minePositions.add(allPositions[i]);
    }

    // 构建棋盘
    board = List.generate(rows, (r) {
      return List.generate(cols, (c) {
        return MineSweeperCellBean(isMine: minePositions.contains(Point(r, c)));
      });
    });

    // 计算每个格子周围的雷数
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c].isMine) continue;
        int count = 0;
        for (int dr = -1; dr <= 1; dr++) {
          for (int dc = -1; dc <= 1; dc++) {
            final nr = r + dr;
            final nc = c + dc;
            if (nr >= 0 && nr < rows && nc >= 0 && nc < cols) {
              if (board[nr][nc].isMine) count++;
            }
          }
        }
        board[r][c] = board[r][c].copyWith(adjacentMines: count);
      }
    }

    isFirstClick = false;
    gameStatus = MineSweeperGameStatus.playing;
  }

  /// 点击打开格子
  void openCell(int row, int col) {
    if (gameStatus == MineSweeperGameStatus.won || gameStatus == MineSweeperGameStatus.lost) return;

    // 首次点击，初始化棋盘并启动计时器
    if (isFirstClick) {
      _initBoard(row, col);
      _startTimer();
    }

    final cell = board[row][col];
    if (cell.status != MineSweeperCellStatus.closed) return;

    // 踩雷
    if (cell.isMine) {
      _revealAllMines();
      _stopTimer();
      gameStatus = MineSweeperGameStatus.lost;
      notifyListeners();
      return;
    }

    // 打开格子，空白递归展开
    _floodOpen(row, col);
    notifyListeners();

    // 检查是否胜利
    _checkWin();
  }

  /// 长按标记/取消旗帜（closed <-> flagged 两态切换）
  void toggleFlag(int row, int col) {
    if (gameStatus == MineSweeperGameStatus.won || gameStatus == MineSweeperGameStatus.lost) return;
    if (isFirstClick) return;

    final cell = board[row][col];
    if (cell.status == MineSweeperCellStatus.opened) return;

    if (cell.status == MineSweeperCellStatus.closed) {
      // 剩余旗帜不足时禁止继续标记
      if (remainingFlags <= 0) return;
      board[row][col] = cell.copyWith(status: MineSweeperCellStatus.flagged);
      remainingFlags--;
    } else {
      board[row][col] = cell.copyWith(status: MineSweeperCellStatus.closed);
      remainingFlags++;
    }
    notifyListeners();
  }

  /// 切换标记模式
  void toggleMarkMode() {
    isMarkMode = !isMarkMode;
    notifyListeners();
  }

  /// 点击格子：根据标记模式决定打开还是标记
  void onCellTap(int row, int col) {
    if (isMarkMode) {
      toggleFlag(row, col);
    } else {
      openCell(row, col);
    }
  }

  /// 重置游戏
  void resetGame() {
    _stopTimer();
    elapsedSeconds = 0;
    gameStatus = MineSweeperGameStatus.idle;
    isFirstClick = true;
    isMarkMode = false;
    _initEmptyBoard();
    notifyListeners();
  }

  /// 切换难度并重置
  void changeConfig(MineSweeperGameConfigBean newConfig) {
    _stopTimer();
    config = newConfig;
    elapsedSeconds = 0;
    gameStatus = MineSweeperGameStatus.idle;
    isFirstClick = true;
    isMarkMode = false;
    _initEmptyBoard();
    notifyListeners();
  }

  /// 递归展开空白区域
  void _floodOpen(int row, int col) {
    if (row < 0 || row >= config.rows || col < 0 || col >= config.cols) return;
    final cell = board[row][col];
    if (cell.status != MineSweeperCellStatus.closed || cell.isMine) return;

    board[row][col] = cell.copyWith(status: MineSweeperCellStatus.opened);

    if (cell.adjacentMines == 0) {
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;
          _floodOpen(row + dr, col + dc);
        }
      }
    }
  }

  /// 揭示所有雷
  void _revealAllMines() {
    for (int r = 0; r < config.rows; r++) {
      for (int c = 0; c < config.cols; c++) {
        if (board[r][c].isMine) {
          board[r][c] = board[r][c].copyWith(status: MineSweeperCellStatus.opened);
        }
      }
    }
  }

  /// 检查是否胜利
  void _checkWin() {
    for (int r = 0; r < config.rows; r++) {
      for (int c = 0; c < config.cols; c++) {
        final cell = board[r][c];
        if (!cell.isMine && cell.status != MineSweeperCellStatus.opened) return;
      }
    }
    _stopTimer();
    gameStatus = MineSweeperGameStatus.won;
    notifyListeners();
  }

  /// 启动计时器
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (gameStatus == MineSweeperGameStatus.playing) {
        elapsedSeconds++;
        notifyListeners();
      }
    });
  }

  /// 停止计时器
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

/// 扫雷游戏 Provider
final mineSweeperProvider =
    ChangeNotifierProvider.autoDispose<MineSweeperNotifier>(
  (ref) => MineSweeperNotifier(MineSweeperGameConfigBean.easy),
);
