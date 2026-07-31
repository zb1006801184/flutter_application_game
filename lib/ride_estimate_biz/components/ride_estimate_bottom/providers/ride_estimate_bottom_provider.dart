import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ride_estimate_bottom_implements.dart';
import 'ride_estimate_bottom_action_provider.dart';

/// 底部栏区域独立 Provider 变量
/// 使用 autoDispose + family：以 familyId 为 key 实现多实例化，
/// 每个页面实例拥有独立的 provider，页面退出时自动销毁。
final rideEstimateBottomProvider =
    ChangeNotifierProvider.autoDispose.family<RideEstimateBottomProvider, String>(
  (ref, familyId) => RideEstimateBottomProvider(ref, familyId: familyId),
);

/// 底部栏区域最终 Provider 类
class RideEstimateBottomProvider extends RideEstimateBottomImplements
    with RideEstimateBottomActionProvider {
  RideEstimateBottomProvider(Ref r, {String? familyId}) {
    ref = r;
    this.familyId = familyId ?? '';
  }
}
