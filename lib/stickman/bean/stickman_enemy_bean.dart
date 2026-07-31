/// 火柴人敌人状态
class StickmanEnemyBean {
  /// 唯一标识
  final int id;

  /// 世界坐标 X
  double x;

  /// 世界坐标 Y
  double y;

  /// 生命值
  int hp;

  /// 巡逻左边界
  final double patrolLeft;

  /// 巡逻右边界
  final double patrolRight;

  /// 是否向右移动
  bool movingRight;

  /// 敌人宽度
  static const double width = 22;

  /// 敌人高度
  static const double height = 34;

  StickmanEnemyBean({
    required this.id,
    required this.x,
    required this.y,
    this.hp = 1,
    required this.patrolLeft,
    required this.patrolRight,
    this.movingRight = true,
  });
}
