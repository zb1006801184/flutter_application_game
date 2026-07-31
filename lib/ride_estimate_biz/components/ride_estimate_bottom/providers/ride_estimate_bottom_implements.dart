import 'package:flutter/material.dart';
import 'package:flutter_application_demo/ride_estimate_biz/mixin/family_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 底部栏区域对外暴露的状态属性
abstract class RideEstimateBottomImplements extends ChangeNotifier
    with FamilyMixin {
  /// Riverpod Ref，用于跨区域访问，统一由基类持有
  late final Ref ref;

  // 未来扩展底部栏状态
}
