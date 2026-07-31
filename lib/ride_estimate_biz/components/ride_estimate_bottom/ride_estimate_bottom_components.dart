import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/ride_estimate_bottom_provider.dart';

/// 预估价底部栏组件
class RideEstimateBottomComponents extends ConsumerStatefulWidget {
  const RideEstimateBottomComponents({super.key, this.familyId});

  /// 家族 ID，用于支持多实例 provider 隔离
  final String? familyId;

  @override
  ConsumerState<RideEstimateBottomComponents> createState() =>
      _RideEstimateBottomComponentsState();
}

class _RideEstimateBottomComponentsState
    extends ConsumerState<RideEstimateBottomComponents> {
  @override
  Widget build(BuildContext context) {
    // 监听底部栏区域 Provider 状态变化
    ref.watch(rideEstimateBottomProvider(widget.familyId ?? ''));

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // 顶部边框线，与上方列表区域分隔
          border: Border(
            top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentMethodRowWidget(),
              _buildActionButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建支付方式行
  Widget _buildPaymentMethodRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: const [
          Icon(Icons.credit_card, size: 20),
          SizedBox(width: 8),
          Text('VISA 0826'),
          Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  /// 构建底部主操作按钮
  Widget _buildActionButtonWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () {},
          child: const Text(
            'Choose Express',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
