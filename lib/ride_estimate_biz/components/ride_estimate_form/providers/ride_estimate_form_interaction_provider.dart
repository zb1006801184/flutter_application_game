import 'package:flutter_application_demo/ride_estimate_biz/components/ride_estimate_form/constants/ride_estimate_form_constants.dart';
import 'package:flutter_application_demo/ride_estimate_biz/enums/ride_estimate_form_status.dart';
import 'ride_estimate_form_implements.dart';

/// 表单区域逻辑 mixin —— 抽屉拖拽交互相关
/// 监听 sheetController 尺寸变化，自动同步 formStatus 到最接近的吸附档位，
/// 使外部可通过 formStatus 感知当前抽屉所处的档位
mixin RideEstimateFormInteractionProvider on RideEstimateFormImplements {
  /// 挂载抽屉尺寸监听，由宿主 Provider 构造时调用一次
  void initSheetStatusSync() {
    sheetController.addListener(_handleSheetSizeChanged);
  }

  /// 抽屉尺寸变化回调：匹配最接近的档位并同步 formStatus
  void _handleSheetSizeChanged() {
    // sheet 尚未 attach 时无法读取尺寸，跳过同步
    if (!sheetController.isAttached) return;
    final newStatus = _resolveStatusBySize(sheetController.size);
    if (newStatus != formStatus) {
      formStatus = newStatus;
      notifyListeners();
    }
  }

  /// 根据当前抽屉尺寸匹配最接近的档位状态
  /// 取与三档（0.3 / 0.55 / 0.9）距离最近者，保证吸附动画过程中状态切换平滑
  RideEstimateFormStatus _resolveStatusBySize(double size) {
    final dMin =
        (size - RideEstimateFormConstants.minimumSheetSize).abs();
    final dMid =
        (size - RideEstimateFormConstants.middleSheetSize).abs();
    final dMax =
        (size - RideEstimateFormConstants.maximumSheetSize).abs();
    if (dMin <= dMid && dMin <= dMax) {
      return RideEstimateFormStatus.minimum;
    }
    if (dMax <= dMid && dMax <= dMin) {
      return RideEstimateFormStatus.maximum;
    }
    return RideEstimateFormStatus.middle;
  }

  @override
  void dispose() {
    sheetController.removeListener(_handleSheetSizeChanged);
    print('zzs: dispose - RideEstimateFormInteractionProvider ${familyId}');
    super.dispose();
  }
}
