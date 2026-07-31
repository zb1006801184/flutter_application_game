import 'package:flutter/material.dart';
import 'package:flutter_application_demo/ride_estimate_biz/components/ride_estimate_address_edit/ride_estimate_address_components.dart';
import 'package:flutter_application_demo/ride_estimate_biz/components/ride_estimate_bottom/ride_estimate_bottom_components.dart';
import 'package:flutter_application_demo/ride_estimate_biz/components/ride_estimate_form/ride_estimate_form_components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 冒泡页（预估价页面）
class RideEstimateBizPage extends ConsumerStatefulWidget {
  const RideEstimateBizPage({super.key, this.familyId});
  final String? familyId;
  @override
  ConsumerState<RideEstimateBizPage> createState() =>
      _RideEstimateBizPageState();
}

class _RideEstimateBizPageState extends ConsumerState<RideEstimateBizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(
        children: [
          // 地址编辑栏（顶部）
          RideEstimateAddressComponents(familyId: widget.familyId),
          // 表单栏
          RideEstimateFormComponents(familyId: widget.familyId),
          // 底部栏
          RideEstimateBottomComponents(familyId: widget.familyId),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose - RideEstimateBizPage ${widget.familyId}');
  }
}
