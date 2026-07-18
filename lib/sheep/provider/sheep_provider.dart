import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bean/sheep_tile_bean.dart';
import '../enum/sheep_game_status.dart';
import '../enum/sheep_tile_type.dart';

/// 槽位容量
const int kSheepSlotCapacity = 7;

/// 撤销道具次数
const int kSheepUndoLimit = 5;

/// 洗牌道具次数
const int kSheepShuffleLimit = 3;

/// 每层网格规格（列数、行数），从底层到顶层依次递减
const List<List<int>> _kLayerSpecs = [
  [7, 4], // layer 0：28
  [6, 3], // layer 1：18
  [5, 2], // layer 2：10
  [4, 1], // layer 3：4
];

/// 用于撤销的快照
class _Snapshot {
  final List<SheepTileBean> tiles;
  final List<int> slotIds;
  final int score;
  final SheepGameStatus status;

  _Snapshot({
    required this.tiles,
    required this.slotIds,
    required this.score,
    required this.status,
  });
}

/// 羊了个羊逻辑控制器
class SheepNotifier extends ChangeNotifier {
  final Random _random = Random();

  /// 全部方块
  List<SheepTileBean> tiles = [];

  /// 槽位中的方块（按进入顺序排列）
  List<SheepTileBean> slot = [];

  /// 游戏状态
  SheepGameStatus gameStatus = SheepGameStatus.idle;

  /// 得分
  int score = 0;

  /// 剩余撤销次数
  int undoLeft = kSheepUndoLimit;

  /// 剩余洗牌次数
  int shuffleLeft = kSheepShuffleLimit;

  /// 撤销快照栈
  final List<_Snapshot> _undoStack = [];

  /// 开始游戏
  void startGame() {
    _generateTiles();
    score = 0;
    undoLeft = kSheepUndoLimit;
    shuffleLeft = kSheepShuffleLimit;
    slot = [];
    _undoStack.clear();
    gameStatus = SheepGameStatus.playing;
    notifyListeners();
  }

  /// 重置回未开始状态
  void resetGame() {
    tiles = [];
    slot = [];
    score = 0;
    undoLeft = kSheepUndoLimit;
    shuffleLeft = kSheepShuffleLimit;
    _undoStack.clear();
    gameStatus = SheepGameStatus.idle;
    notifyListeners();
  }

  /// 暂停/继续
  void togglePause() {
    if (gameStatus == SheepGameStatus.playing) {
      gameStatus = SheepGameStatus.paused;
    } else if (gameStatus == SheepGameStatus.paused) {
      gameStatus = SheepGameStatus.playing;
    }
    notifyListeners();
  }

  /// 生成棋盘方块
  ///
  /// 总数 = 60，使用 10 种图案，每种出现 6 次（可被两两消除）
  void _generateTiles() {
    final List<SheepTileBean> result = [];
    int id = 0;

    // 收集所有图案类型，并按 6 次重复展开后打乱
    final List<SheepTileType> typePool = [];
    for (final type in SheepTileType.values) {
      for (int i = 0; i < 6; i++) {
        typePool.add(type);
      }
    }
    typePool.shuffle(_random);

    int typeCursor = 0;
    for (int layer = 0; layer < _kLayerSpecs.length; layer++) {
      final cols = _kLayerSpecs[layer][0];
      final rows = _kLayerSpecs[layer][1];
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          result.add(
            SheepTileBean(
              id: id++,
              type: typePool[typeCursor++],
              layer: layer,
              col: c,
              row: r,
            ),
          );
        }
      }
    }
    tiles = result;
  }

  /// 判断方块是否可被点击
  ///
  /// 条件：未消除、未在槽位、且未被任何上层未消除方块覆盖
  bool isClickable(SheepTileBean tile) {
    if (gameStatus != SheepGameStatus.playing) return false;
    if (tile.isRemoved || tile.isInSlot) return false;
    for (final other in tiles) {
      if (other.isRemoved || other.isInSlot) continue;
      if (tile.isCoveredBy(other)) return false;
    }
    return true;
  }

  /// 点击方块
  void clickTile(int tileId) {
    if (gameStatus != SheepGameStatus.playing) return;
    final tile = tiles.firstWhere((t) => t.id == tileId, orElse: () => tiles.first);
    if (!isClickable(tile)) return;
    if (slot.length >= kSheepSlotCapacity) return;

    _pushSnapshot();
    _moveToSlot(tile);
    _eliminate();
    _checkEnd();
    notifyListeners();
  }

  /// 将方块放入槽位末尾
  void _moveToSlot(SheepTileBean tile) {
    tile.isInSlot = true;
    slot.add(tile);
    _reindexSlot();
  }

  /// 重新计算槽位中方块的 slotIndex
  void _reindexSlot() {
    for (int i = 0; i < slot.length; i++) {
      slot[i].slotIndex = i;
    }
  }

  /// 消除槽位中达到 3 个相同图案的方块
  void _eliminate() {
    bool changed = true;
    while (changed) {
      changed = false;
      for (final type in SheepTileType.values) {
        final sameType = slot.where((t) => t.type == type).toList();
        if (sameType.length >= 3) {
          // 消除前 3 个（按槽位顺序）
          for (final t in sameType.take(3)) {
            t.isRemoved = true;
            slot.remove(t);
          }
          score += 30;
          _reindexSlot();
          changed = true;
          break;
        }
      }
    }
  }

  /// 检查胜负
  void _checkEnd() {
    if (tiles.every((t) => t.isRemoved)) {
      gameStatus = SheepGameStatus.won;
      return;
    }
    if (slot.length >= kSheepSlotCapacity) {
      gameStatus = SheepGameStatus.lost;
    }
  }

  /// 撤销上一步
  void undo() {
    if (gameStatus != SheepGameStatus.playing) return;
    if (undoLeft <= 0 || _undoStack.isEmpty) return;
    final snap = _undoStack.removeLast();
    _restore(snap);
    undoLeft--;
    notifyListeners();
  }

  /// 洗牌：打乱棋盘上剩余方块的图案
  void shuffle() {
    if (gameStatus != SheepGameStatus.playing) return;
    if (shuffleLeft <= 0) return;
    _pushSnapshot();
    final remaining = tiles.where((t) => !t.isRemoved && !t.isInSlot).toList();
    final types = remaining.map((t) => t.type).toList();
    types.shuffle(_random);
    for (int i = 0; i < remaining.length; i++) {
      // 通过复制生成新 bean 以触发 UI 重建
      remaining[i] = SheepTileBean(
        id: remaining[i].id,
        type: types[i],
        layer: remaining[i].layer,
        col: remaining[i].col,
        row: remaining[i].row,
      );
      tiles[remaining[i].id] = remaining[i];
    }
    shuffleLeft--;
    notifyListeners();
  }

  /// 压入当前状态快照
  void _pushSnapshot() {
    _undoStack.add(
      _Snapshot(
        tiles: tiles
            .map((t) => SheepTileBean(
                  id: t.id,
                  type: t.type,
                  layer: t.layer,
                  col: t.col,
                  row: t.row,
                  isRemoved: t.isRemoved,
                  isInSlot: t.isInSlot,
                  slotIndex: t.slotIndex,
                ))
            .toList(),
        slotIds: slot.map((t) => t.id).toList(),
        score: score,
        status: gameStatus,
      ),
    );
  }

  /// 从快照恢复状态
  void _restore(_Snapshot snap) {
    tiles = snap.tiles;
    slot = snap.slotIds
        .map((id) => tiles.firstWhere((t) => t.id == id))
        .toList();
    _reindexSlot();
    score = snap.score;
    gameStatus = snap.status;
  }
}

/// 羊了个羊 Provider
final sheepProvider =
    ChangeNotifierProvider.autoDispose<SheepNotifier>((ref) {
  return SheepNotifier();
});
