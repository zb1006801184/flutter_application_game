import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enum/tetris_game_status.dart';
import 'provider/tetris_provider.dart';
import 'widgets/tetris_control_pad_widget.dart';
import 'widgets/tetris_game_board_widget.dart';
import 'widgets/tetris_game_header_widget.dart';
import 'widgets/tetris_next_block_widget.dart';

/// 俄罗斯方块 - 游戏对战页面
class TetrisGamePage extends ConsumerWidget {
  const TetrisGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(tetrisProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('俄罗斯方块')),
      body: Column(
        children: [
          TetrisGameHeaderWidget(
            score: notifier.score,
            level: notifier.level,
            lines: notifier.lines,
            gameStatus: notifier.gameStatus,
            onToggleStart: () => notifier.startGame(),
            onTogglePause: () => notifier.togglePause(),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildBoardArea(notifier)),
                  const SizedBox(width: 12),
                  _buildSidePanel(notifier),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TetrisControlPadWidget(
              onLeft: () => notifier.moveLeft(),
              onRight: () => notifier.moveRight(),
              onRotate: () => notifier.rotate(),
              onSoftDrop: () => notifier.softDrop(),
              onHardDrop: () => notifier.hardDrop(),
            ),
          ),
        ],
      ),
    );
  }

  /// 棋盘区域（含游戏结束遮罩）
  Widget _buildBoardArea(TetrisNotifier notifier) {
    return Stack(
      children: [
        TetrisGameBoardWidget(
          board: notifier.board,
          current: notifier.current,
        ),
        if (notifier.gameStatus == TetrisGameStatus.lost ||
            notifier.gameStatus == TetrisGameStatus.idle)
          _buildOverlay(notifier.gameStatus),
      ],
    );
  }

  /// 右侧信息面板（下一个方块预览 + 操作说明）
  Widget _buildSidePanel(TetrisNotifier notifier) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('下一个', style: TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),
        TetrisNextBlockWidget(type: notifier.nextType),
        const SizedBox(height: 16),
        const _HelpTextWidget(),
      ],
    );
  }

  /// 游戏结束/未开始遮罩
  Widget _buildOverlay(TetrisGameStatus status) {
    final isLost = status == TetrisGameStatus.lost;
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.black.withValues(alpha: 0.4),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLost ? '💥 游戏结束!' : '🎮 点击上方"开始"按钮',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 操作说明文本
class _HelpTextWidget extends StatelessWidget {
  const _HelpTextWidget();

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 12, color: Colors.grey);
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('操作说明', style: TextStyle(fontSize: 14)),
        SizedBox(height: 4),
        Text('旋转：改变方向', style: style),
        Text('左/右：水平移动', style: style),
        Text('软降：缓慢下移', style: style),
        Text('硬降：直接落底', style: style),
      ],
    );
  }
}
