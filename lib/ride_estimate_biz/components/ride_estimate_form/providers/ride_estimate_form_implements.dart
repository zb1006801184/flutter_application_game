import 'package:flutter/material.dart';
import 'package:flutter_application_demo/ride_estimate_biz/enums/ride_estimate_form_status.dart';
import 'package:flutter_application_demo/ride_estimate_biz/mixin/family_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/ride_draggable_sheet.dart';

/// 表单区域对外暴露的状态属性
abstract class RideEstimateFormImplements extends ChangeNotifier
    with FamilyMixin {
  /// Riverpod Ref，用于跨区域访问，统一由基类持有
  late final Ref ref;

  /// 抽屉拖拽控制器，使用 fork 版以接管 goBallistic 的位移阈值吸附
  final RideSheetController sheetController = RideSheetController();

  /// 表单抽屉状态: 默认是中间态
  RideEstimateFormStatus formStatus = RideEstimateFormStatus.middle;

  @override
  void dispose() {
    sheetController.dispose();
    print('zzs: dispose - RideEstimateFormImplements ${familyId}');
    super.dispose();
  }
}
