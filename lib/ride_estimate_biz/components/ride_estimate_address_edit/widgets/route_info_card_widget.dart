import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 路线信息卡片 Widget
/// 包含起点、终点信息及 Change 按钮，按 [图标+文本列] | [分隔线] | [Change按钮] 布局
class RouteInfoCardWidget extends ConsumerWidget {
  const RouteInfoCardWidget({super.key, this.familyId});

  /// 家族 ID，用于支持多实例 provider 隔离
  final String? familyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 起点、终点信息列
          Expanded(child: _buildRoutePointsWidget()),
          // 竖直分隔线
          _buildDividerWidget(),
          // Change 按钮
          _buildChangeButtonWidget(),
        ],
      ),
    );
  }

  /// 构建起点、终点信息列
  Widget _buildRoutePointsWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStartPointWidget(),
          const SizedBox(height: 8),
          _buildEndPointWidget(),
        ],
      ),
    );
  }

  /// 构建起点行（橙色圆环图标 + 地址）
  Widget _buildStartPointWidget() {
    return Row(
      children: const [
        Icon(Icons.circle_outlined, color: Colors.orange, size: 16),
        SizedBox(width: 8),
        Text(
          'Calle Juan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// 构建终点行（黑色旗帜图标 + 地址）
  Widget _buildEndPointWidget() {
    return Row(
      children: const [
        Icon(Icons.flag, color: Colors.black, size: 16),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Starbucks - Castro Street',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// 构建竖直分隔线
  Widget _buildDividerWidget() {
    return Container(
      width: 1,
      height: 32,
      color: Colors.grey.shade300,
    );
  }

  /// 构建 Change 按钮
  Widget _buildChangeButtonWidget() {
    return TextButton(
      onPressed: () {},
      child: const Text('Change'),
    );
  }
}
