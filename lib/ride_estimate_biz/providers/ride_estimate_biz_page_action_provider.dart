import 'ride_estimate_biz_page_implements.dart';

/// 预估价页面逻辑 mixin —— 页面级操作相关
mixin RideEstimateBizPageActionProvider on RideEstimateBizPageImplements {
  // 跨区域协调示例：
  // void submitPage() {
  //   final address = ref.read(rideEstimateAddressProvider(familyId));
  //   final form = ref.read(rideEstimateFormProvider(familyId));
  //   final bottom = ref.read(rideEstimateBottomProvider(familyId));
  //   // 组合各区域状态执行页面级逻辑...
  // }
}
