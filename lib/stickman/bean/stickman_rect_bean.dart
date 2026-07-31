/// 轴对齐矩形（世界坐标）
class StickmanRectBean {
  /// 左上角 X
  final double x;

  /// 左上角 Y
  final double y;

  /// 宽度
  final double w;

  /// 高度
  final double h;

  const StickmanRectBean({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  /// 右边界
  double get right => x + w;

  /// 底边界
  double get bottom => y + h;

  /// 是否与另一矩形相交
  bool overlaps(StickmanRectBean other) {
    return x < other.right &&
        right > other.x &&
        y < other.bottom &&
        bottom > other.y;
  }
}
