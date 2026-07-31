import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ride_estimate_biz_page_implements.dart';
import 'ride_estimate_biz_page_action_provider.dart';

/// 预估价页面独立 Provider 变量
/// 使用 autoDispose + family：以 familyId 为 key 实现多实例化，
/// 每个页面实例拥有独立的 provider，页面退出时自动销毁。
final rideEstimateBizPageProvider =
    ChangeNotifierProvider.autoDispose.family<RideEstimateBizPageProvider, String>(
  (ref, familyId) => RideEstimateBizPageProvider(ref, familyId: familyId),
);

/// 预估价页面最终 Provider 类，混入所有逻辑 mixin
class RideEstimateBizPageProvider extends RideEstimateBizPageImplements
    with RideEstimateBizPageActionProvider {
  RideEstimateBizPageProvider(Ref r , {String? familyId}) {
    ref = r;
    this.familyId = familyId ;
  }



  @override
  void dispose() {
    super.dispose();
    print('${familyId} dispose');
  }
}
