import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/ride_estimate_form_constants.dart';
import 'providers/ride_estimate_form_provider.dart';
import 'widgets/ride_draggable_sheet.dart';
import 'widgets/ride_estimate_form_sheet_widget.dart';

/// 预估价表单组件
/// 使用 fork 版 RideDraggableSheet 实现可上下拖拽的面板，
/// 吸附逻辑由 goBallistic 内部的位移阈值判定驱动，无 animateTo 竞争。
class RideEstimateFormComponents extends ConsumerWidget {
  const RideEstimateFormComponents({super.key, this.familyId});

  /// 家族 ID，用于支持多实例 provider 隔离
  final String? familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用 watch 订阅，保证 autoDispose 的 provider 在组件挂载期间被保活
    final formProvider = ref.watch(rideEstimateFormProvider(familyId ?? ''));
    return Positioned.fill(
      child: Container(
        // color: Colors.black.withAlpha(40),
        child: RideDraggableSheet(
          key: ObjectKey(familyId),
          controller: formProvider.sheetController,
          initialChildSize: RideEstimateFormConstants.middleSheetSize,
          minChildSize: RideEstimateFormConstants.minimumSheetSize,
          maxChildSize: RideEstimateFormConstants.maximumSheetSize,
          snapSizes: const [
            RideEstimateFormConstants.minimumSheetSize,
            RideEstimateFormConstants.middleSheetSize,
            RideEstimateFormConstants.maximumSheetSize,
          ],
          snapAnimationDuration:
              RideEstimateFormConstants.snapAnimationDuration,
          snapAnimationCurve:
              RideEstimateFormConstants.snapAnimationCurve,
          dragSnapThresholdPx:
              RideEstimateFormConstants.dragSnapThresholdPx,
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: RideEstimateFormSheetWidget(
                scrollController: scrollController,
                familyId: familyId,
              ),
            );
          },
        ),
      ),
    );
  }
}
