import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bean/tetris_block_bean.dart';
import '../enum/tetris_block_type.dart';
import '../enum/tetris_game_status.dart';

/// 棋盘列数
const int kTetrisCols = 10;

/// 棋盘行数
const int kTetrisRows = 20;

/// 俄罗斯方块逻辑控制器
class TetrisNotifier extends ChangeNotifier {
  final Random _random = Random();
  Timer? _timer;

  /// 棋盘数据：null 表示空，否则为该格固定的方块类型
  late List<List<TetrisBlockType?>> board;

  /// 当前下落方块
  TetrisBlockBean? current;

  /// 下一个方块类型
  TetrisBlockType? nextType;

  /// 游戏状态
  TetrisGameStatus gameStatus = TetrisGameStatus.idle;

  /// 得分
  int score = 0;

  /// 已消除行数
  int lines = 0;

  /// 当前等级（每 10 行升一级）
  int level = 1;

  TetrisNotifier() {
    _initBoard();
  }

  /// 初始化空棋盘
  void _initBoard() {
    board = List.generate(kTetrisRows, (_) => List.filled(kTetrisCols, null));
  }

  /// 开始游戏
  void startGame() {
    _initBoard();
    score = 0;
    lines = 0;
    level = 1;
    nextType = _randomType();
    _spawn();
    gameStatus = TetrisGameStatus.playing;
    _startTimer();
    notifyListeners();
  }

  /// 重置游戏
  void resetGame() {
    _stopTimer();
    _initBoard();
    current = null;
    nextType = null;
    score = 0;
    lines = 0;
    level = 1;
    gameStatus = TetrisGameStatus.idle;
    notifyListeners();
  }

  /// 暂停/继续
  void togglePause() {
    if (gameStatus == TetrisGameStatus.playing) {
      gameStatus = TetrisGameStatus.paused;
      _stopTimer();
    } else if (gameStatus == TetrisGameStatus.paused) {
      gameStatus = TetrisGameStatus.playing;
      _startTimer();
    }
    notifyListeners();
  }

  /// 随机生成一个方块类型
  TetrisBlockType _randomType() {
    return TetrisBlockType.values[_random.nextInt(TetrisBlockType.values.length)];
  }

  /// 生成新方块；若生成即碰撞则游戏结束
  void _spawn() {
    final type = nextType ?? _randomType();
    nextType = _randomType();
    current = TetrisBlockBean(
      type: type,
      rotation: 0,
      row: 0,
      col: (kTetrisCols ~/ 2) - 2,
    );
    if (_collides(current!)) {
      gameStatus = TetrisGameStatus.lost;
      _stopTimer();
    }
  }

  /// 碰撞检测
  bool _collides(TetrisBlockBean block) {
    final m = block.matrix;
    for (int r = 0; r < m.length; r++) {
      for (int c = 0; c < m[r].length; c++) {
        if (m[r][c] == 0) continue;
        final br = block.row + r;
        final bc = block.col + c;
        if (bc < 0 || bc >= kTetrisCols || br >= kTetrisRows) return true;
        if (br >= 0 && board[br][bc] != null) return true;
      }
    }
    return false;
  }

  /// 左移
  void moveLeft() {
    if (gameStatus != TetrisGameStatus.playing || current == null) return;
    final moved = current!.copyWith(col: current!.col - 1);
    if (!_collides(moved)) {
      current = moved;
      notifyListeners();
    }
  }

  /// 右移
  void moveRight() {
    if (gameStatus != TetrisGameStatus.playing || current == null) return;
    final moved = current!.copyWith(col: current!.col + 1);
    if (!_collides(moved)) {
      current = moved;
      notifyListeners();
    }
  }

  /// 旋转（带简易墙踢：依次尝试 0、-1、+1、-2、+2 列偏移）
  void rotate() {
    if (gameStatus != TetrisGameStatus.playing || current == null) return;
    final newRotation = (current!.rotation + 1) % 4;
    for (final offset in [0, -1, 1, -2, 2]) {
      final moved = current!.copyWith(
        rotation: newRotation,
        col: current!.col + offset,
      );
      if (!_collides(moved)) {
        current = moved;
        notifyListeners();
        return;
      }
    }
  }

  /// 软降（下移一格）
  void softDrop() {
    if (gameStatus != TetrisGameStatus.playing || current == null) return;
    _stepDown();
  }

  /// 硬降（直接落到底部并锁定）
  void hardDrop() {
    if (gameStatus != TetrisGameStatus.playing || current == null) return;
    while (!_collides(current!.copyWith(row: current!.row + 1))) {
      current = current!.copyWith(row: current!.row + 1);
    }
    score += 2; // 硬降奖励
    _lock();
    notifyListeners();
  }

  /// 计时器触发的自然下落
  void _tick() {
    _stepDown();
  }

  /// 下移一格；无法下移则锁定
  void _stepDown() {
    if (current == null) return;
    final moved = current!.copyWith(row: current!.row + 1);
    if (!_collides(moved)) {
      current = moved;
      notifyListeners();
    } else {
      _lock();
      notifyListeners();
    }
  }

  /// 固定当前方块到棋盘并消除满行
  void _lock() {
    final m = current!.matrix;
    for (int r = 0; r < m.length; r++) {
      for (int c = 0; c < m[r].length; c++) {
        if (m[r][c] == 0) continue;
        final br = current!.row + r;
        final bc = current!.col + c;
        if (br >= 0 && br < kTetrisRows && bc >= 0 && bc < kTetrisCols) {
          board[br][bc] = current!.type;
        }
      }
    }
    _clearLines();
    if (gameStatus != TetrisGameStatus.lost) {
      _spawn();
    }
  }

  /// 消除满行并更新得分/等级
  void _clearLines() {
    int cleared = 0;
    for (int r = kTetrisRows - 1; r >= 0; r--) {
      if (board[r].every((cell) => cell != null)) {
        board.removeAt(r);
        board.insert(0, List.filled(kTetrisCols, null));
        cleared++;
        r++; // 移除后下方上移，需重新检查当前行
      }
    }
    if (cleared > 0) {
      lines += cleared;
      // 计分：1=100, 2=300, 3=500, 4=800，乘以等级
      const baseScores = [0, 100, 300, 500, 800];
      score += baseScores[cleared] * level;
      // 每 10 行升一级
      final newLevel = (lines ~/ 10) + 1;
      if (newLevel != level) {
        level = newLevel;
        _restartTimer(); // 等级变化后调整下落速度
      }
    }
  }

  /// 启动下落计时器（速度随等级提升）
  void _startTimer() {
    _restartTimer();
  }

  /// 根据当前等级重新启动计时器
  void _restartTimer() {
    _stopTimer();
    final interval = _dropInterval();
    _timer = Timer.periodic(interval, (_) {
      if (gameStatus == TetrisGameStatus.playing) {
        _tick();
      }
    });
  }

  /// 计算下落间隔：等级越高速度越快，最低 100ms
  Duration _dropInterval() {
    final ms = (800 - (level - 1) * 70).clamp(100, 800);
    return Duration(milliseconds: ms);
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

/// 俄罗斯方块 Provider
final tetrisProvider =
    ChangeNotifierProvider.autoDispose<TetrisNotifier>((ref) {
  return TetrisNotifier();
});
