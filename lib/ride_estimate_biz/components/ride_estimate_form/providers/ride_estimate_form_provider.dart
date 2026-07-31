import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ride_estimate_form_action_provider.dart';
import 'ride_estimate_form_implements.dart';
import 'ride_estimate_form_interaction_provider.dart';

/// 表单区域独立 Provider 变量
/// 使用 autoDispose + family：以 familyId 为 key 实现多实例化，
/// 每个页面实例拥有独立的 provider，页面退出时自动销毁。
final rideEstimateFormProvider =
    ChangeNotifierProvider.autoDispose.family<RideEstimateFormProvider, String>(
  (ref, familyId) => RideEstimateFormProvider(ref, familyId: familyId),
);

/// 表单区域最终 Provider 类
/// 通过混入各功能 mixin 实现逻辑解耦：
/// - [RideEstimateFormActionProvider] 表单操作相关
/// - [RideEstimateFormInteractionProvider] 抽屉拖拽交互相关
class RideEstimateFormProvider extends RideEstimateFormImplements
    with
        RideEstimateFormActionProvider,
        RideEstimateFormInteractionProvider {
  RideEstimateFormProvider(Ref r, {String? familyId}) {
    ref = r;
    this.familyId = familyId ?? '';
    // 初始化抽屉尺寸监听，使 formStatus 随吸附档位自动同步
    initSheetStatusSync();
  }
  @override
  void dispose() {
    super.dispose();
  print('zzs: dispose - RideEstimateFormProvider ${familyId}');
  }
}
