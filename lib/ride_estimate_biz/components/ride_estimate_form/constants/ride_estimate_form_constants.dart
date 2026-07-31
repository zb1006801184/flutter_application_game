import 'package:flutter/animation.dart';

/// 预估价表单相关常量
class RideEstimateFormConstants {
  RideEstimateFormConstants._();

  /// 下态：抽屉收起，仅露出顶部一部分
  static const double minimumSheetSize = 0.3;

  /// 中态：抽屉半展开，默认初始状态
  static const double middleSheetSize = 0.55;

  /// 上态：抽屉完全展开，内部列表可继续滚动
  static const double maximumSheetSize = 0.9;

  /// 拖拽吸附阈值：拖动的绝对像素距离超过该值才跳到相邻档位，否则回弹当前档位
  static const double dragSnapThresholdPx = 5.0;

  /// 吸附动画时长
  static const Duration snapAnimationDuration = Duration(milliseconds: 250);

  /// 吸附动画曲线
  static const Curve snapAnimationCurve = Curves.easeOut;
}
