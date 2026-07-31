import 'ride_estimate_address_edit_implements.dart';

/// 地址区域逻辑 mixin —— 地址操作相关
mixin RideEstimateAddressEditActionProvider
    on RideEstimateAddressEditImplements {
  /// 更新上车地址
  void updatePickupAddress(String address) {
    pickupAddress = address;
    notifyListeners();
  }

  // 跨区域访问示例：
  // void someMethodNeedingFormData() {
  //   final form = ref.read(rideEstimateFormProvider(familyId));
  //   // 使用 form 的状态...
  // }
}
