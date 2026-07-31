import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 车型选项行 Widget
/// 按设计稿虚线框区域划分：左侧车辆图片区 + 右侧文本内容区（车型详情与价格）
class RideOptionItemWidget extends ConsumerWidget {
  const RideOptionItemWidget({super.key, this.familyId});

  /// 家族 ID，用于支持多实例 provider 隔离
  final String? familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // 区域一：车辆图片
            _buildVehicleImageWidget(),
            const SizedBox(width: 12),
            // 区域二：文本内容（车型详情 + 价格）
            Expanded(child: _buildTextContentWidget()),
          ],
        ),
      ),
    );
  }

  /// 构建车辆图片区域
  Widget _buildVehicleImageWidget() {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.directions_car, size: 28),
    );
  }

  /// 构建文本内容区域（车型详情 + 价格）
  Widget _buildTextContentWidget() {
    return Row(
      children: [
        // 车型详情
        Expanded(child: _buildRideDetailWidget()),
        // 价格
        _buildPriceWidget(),
      ],
    );
  }

  /// 构建车型详情（标题 + ETA）
  Widget _buildRideDetailWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Express',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(width: 4),
            Icon(Icons.person, size: 14),
            Text('4'),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'in 5min · 13:11',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  /// 构建价格
  Widget _buildPriceWidget() {
    return const Text(
      '\$44.93',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
