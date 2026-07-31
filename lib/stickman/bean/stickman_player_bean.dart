import 'stickman_rect_bean.dart';

/// 火柴人玩家状态
class StickmanPlayerBean {
  /// 世界坐标 X（左上角）
  double x;

  /// 世界坐标 Y（左上角）
  double y;

  /// 水平速度
  double vx;

  /// 垂直速度
  double vy;

  /// 生命值
  int hp;

  /// 是否朝右
  bool facingRight;

  /// 是否着地
  bool onGround;

  /// 是否处于攻击表现帧
  bool isAttacking;

  /// 走路动画相位（弧度）
  double walkPhase;

  /// 玩家宽度
  static const double width = 22;

  /// 玩家高度
  static const double height = 40;

  StickmanPlayerBean({
    required this.x,
    required this.y,
    this.vx = 0,
    this.vy = 0,
    this.hp = 3,
    this.facingRight = true,
    this.onGround = false,
    this.isAttacking = false,
    this.walkPhase = 0,
  });

  /// 碰撞矩形
  StickmanRectBean get rect =>
      StickmanRectBean(x: x, y: y, w: width, h: height);
}
