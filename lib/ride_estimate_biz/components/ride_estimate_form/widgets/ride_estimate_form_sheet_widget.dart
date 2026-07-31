import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ride_estimate_bottom/widgets/ride_option_item_widget.dart';

/// 预估价表单抽屉内部内容 Widget
/// 包含拖拽把手与可滚动的车型选项列表，
/// 滚动行为交由外部传入的 [scrollController] 控制，
/// 使抽屉在到达最大高度后能继续滚动列表内容；
/// 消息区域：上滑吸顶，回到顶部后随列表一起下移（避免 pinned 钉死产生缝隙）
class RideEstimateFormSheetWidget extends ConsumerWidget {
  const RideEstimateFormSheetWidget({
    super.key,
    required this.scrollController,
    this.familyId,
  });

  /// 由 DraggableScrollableSheet.builder 传入，用于联动拖拽与列表滚动
  final ScrollController scrollController;

  /// 家族 ID，用于支持多实例 provider 隔离
  final String? familyId;

  /// 消息吸顶区域高度（上下 margin 8 + 把手 4）
  static const double messageHeaderExtent = 20;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeTop: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 车型选项列表随抽屉高度变化而滚动
          Flexible(child: _buildRideOptionsListWidget()),
        ],
      ),
    );
  }

  /// 构建消息区域（拖拽把手）
  Widget _buildMessageAreaWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      width: 40,
      height: 4,
    );
  }

  /// 构建可滚动的车型选项列表
  /// header 放在列表流内，回到顶部 / 下拉时可随内容一起移动；
  /// offset > 0 时再叠一层吸顶副本，实现上滑悬浮
  Widget _buildRideOptionsListWidget() {
    return Stack(
      children: [
        // 未使用 Sliver 特有能力（吸顶效果由下方 Stack 叠加层单独实现），
        // 用普通 ListView 即可，header 作为第一个 item 随列表一起滚动
        ListView(
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            _buildMessageHeaderWidget(),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
            RideOptionItemWidget(familyId: familyId),
          ],
        ),
        // 上滑离开顶部后，叠一层吸顶 header
        _buildStickyHeaderOverlayWidget(),
      ],
    );
  }

  /// 上滑后吸顶的消息区域副本（点击穿透，手势仍交给列表）
  Widget _buildStickyHeaderOverlayWidget() {
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, _) {
        final double offset =
            scrollController.hasClients ? scrollController.offset : 0;
        // 仍在顶部（含 overscroll）时不展示副本，避免与流内 header 叠影，
        // 并保证下拉时 header 能跟着列表一起往下走
        if (offset <= 0) {
          return const SizedBox.shrink();
        }
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildMessageHeaderWidget(),
        );
      },
    );
  }

  /// 构建消息区域内容（含圆角背景）
  Widget _buildMessageHeaderWidget() {
    return Container(
      height: messageHeaderExtent,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildMessageAreaWidget()],
      ),
    );
  }
}
