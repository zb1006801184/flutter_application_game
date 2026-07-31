import 'package:flutter/material.dart';
import 'package:flutter_application_demo/ride_estimate_biz/ride_estimate_biz_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/route_info_card_widget.dart';

/// 预估价地址编辑组件
class RideEstimateAddressComponents extends ConsumerStatefulWidget {
  const RideEstimateAddressComponents({super.key, this.familyId});

  /// 家族 ID，用于支持多实例 provider 隔离
  final String? familyId;

  @override
  ConsumerState<RideEstimateAddressComponents> createState() =>
      _RideEstimateAddressComponentsState();
}

class _RideEstimateAddressComponentsState
    extends ConsumerState<RideEstimateAddressComponents> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildTopRowWidget(),
        ),
      ),
    );
  }

  /// 构建顶部行（返回按钮 + 路线信息卡片）
  Widget _buildTopRowWidget() {
    return Row(
      children: [
        _buildBackButtonWidget(),
        const SizedBox(width: 12),
        Expanded(child: RouteInfoCardWidget(familyId: widget.familyId)),
      ],
    );
  }

  /// 构建返回按钮（圆形白色 + 左箭头）
  Widget _buildBackButtonWidget() {
    return GestureDetector(
      // 点击返回按钮，跳转到预估价页面（RideEstimateBizPage）
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RideEstimateBizPage(
              familyId: '222',
            ),
          ),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.arrow_back, size: 20),
      ),
    );
  }
}
