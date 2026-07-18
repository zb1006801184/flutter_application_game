import '../enum/sheep_tile_type.dart';

/// 羊了个羊 - 方块数据模型
///
/// 每个方块拥有唯一 [id]，归属于某一 [layer] 层，并在该层网格中占据
/// ([col], [row]) 位置。层与层之间使用 0.5 格的偏移叠加，上层方块会
/// 部分覆盖下层方块，被覆盖的方块不可被点击。
class SheepTileBean {
  /// 唯一标识
  final int id;

  /// 图案类型
  final SheepTileType type;

  /// 所在层（从 0 开始，越大越靠上）
  final int layer;

  /// 在该层网格中的列
  final int col;

  /// 在该层网格中的行
  final int row;

  /// 是否已被消除
  bool isRemoved;

  /// 是否已进入底部槽位
  bool isInSlot;

  /// 在槽位中的索引，-1 表示尚未进入槽位
  int slotIndex;

  SheepTileBean({
    required this.id,
    required this.type,
    required this.layer,
    required this.col,
    required this.row,
    this.isRemoved = false,
    this.isInSlot = false,
    this.slotIndex = -1,
  });

  /// 方块在连续坐标系中的 x（叠加 0.5 格的层间偏移）
  double get posX => col.toDouble() + layer * 0.5;

  /// 方块在连续坐标系中的 y
  double get posY => row.toDouble() + layer * 0.5;

  /// 判断另一个方块是否覆盖当前方块（用于点击可用性判断）
  ///
  /// 覆盖条件：对方层级更高，且两个单位正方形在连续坐标系中存在重叠
  bool isCoveredBy(SheepTileBean other) {
    if (other.id == id) return false;
    if (other.layer <= layer) return false;
    final dx = (other.posX - posX).abs();
    final dy = (other.posY - posY).abs();
    return dx < 1.0 && dy < 1.0;
  }
}
