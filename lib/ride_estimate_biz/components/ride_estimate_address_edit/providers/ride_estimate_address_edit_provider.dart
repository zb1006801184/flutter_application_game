import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ride_estimate_address_edit_implements.dart';
import 'ride_estimate_address_edit_action_provider.dart';

/// 地址区域独立 Provider 变量
/// 使用 autoDispose + family：以 familyId 为 key 实现多实例化，
/// 每个页面实例拥有独立的 provider，页面退出时自动销毁。
final rideEstimateAddressProvider =
    ChangeNotifierProvider.autoDispose.family<RideEstimateAddressEditProvider, String>(
  (ref, familyId) => RideEstimateAddressEditProvider(ref, familyId: familyId),
);

/// 地址区域最终 Provider 类，混入所有逻辑 mixin
class RideEstimateAddressEditProvider extends RideEstimateAddressEditImplements
    with RideEstimateAddressEditActionProvider {
  RideEstimateAddressEditProvider(Ref r, {String? familyId}) {
    ref = r;
    this.familyId = familyId ?? '';
  }
}
