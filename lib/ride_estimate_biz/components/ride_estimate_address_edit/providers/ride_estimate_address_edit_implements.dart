import 'package:flutter/material.dart';
import 'package:flutter_application_demo/ride_estimate_biz/mixin/family_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 地址区域对外暴露的状态属性，直接继承 ChangeNotifier 作为基类
abstract class RideEstimateAddressEditImplements extends ChangeNotifier
    with FamilyMixin {
  /// Riverpod Ref，用于跨区域访问，统一由基类持有
  late final Ref ref;

  /// 上车地址
  String pickupAddress = '';

  /// 用户年龄
  int age = 18;
}
