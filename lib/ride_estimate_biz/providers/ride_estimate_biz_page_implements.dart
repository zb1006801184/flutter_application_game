import 'package:flutter/material.dart';
import 'package:flutter_application_demo/ride_estimate_biz/mixin/family_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 预估价页面对外暴露的状态属性，直接继承 ChangeNotifier 作为基类
abstract class RideEstimateBizPageImplements extends ChangeNotifier with FamilyMixin {
  /// Riverpod Ref，用于跨区域访问，统一由基类持有
  late final Ref ref;

  // 未来扩展页面级状态，如页面加载状态、是否显示加载框等
}
