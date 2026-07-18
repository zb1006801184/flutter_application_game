import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bean/mine_sweeper_game_config_bean.dart';
import 'enum/mine_sweeper_game_status.dart';
import 'provider/mine_sweeper_provider.dart';
import 'widgets/mine_sweeper_game_board_widget.dart';
import 'widgets/mine_sweeper_game_header_widget.dart';

/// 扫雷 - 游戏对战页面
class MineSweeperGamePage extends ConsumerStatefulWidget {
  final MineSweeperGameConfigBean config;

  const MineSweeperGamePage({super.key, required this.config});

  @override
  ConsumerState<MineSweeperGamePage> createState() =>
      _MineSweeperGamePageState();
}

class _MineSweeperGamePageState extends ConsumerState<MineSweeperGamePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mineSweeperProvider).changeConfig(widget.config);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(mineSweeperProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('扫雷 - ${widget.config.name}'),
      ),
      body: Column(
        children: [
          MineSweeperGameHeaderWidget(
            remainingFlags: notifier.remainingFlags,
            flaggedCount: notifier.flaggedCount,
            elapsedSeconds: notifier.elapsedSeconds,
            gameStatus: notifier.gameStatus,
            isMarkMode: notifier.isMarkMode,
            onReset: () => notifier.resetGame(),
            onToggleMarkMode: () => notifier.toggleMarkMode(),
          ),
          const Divider(height: 1),
          Expanded(
            child: Stack(
              children: [
                MineSweeperGameBoardWidget(
                  board: notifier.board,
                  onCellTap: (row, col) => notifier.onCellTap(row, col),
                  onCellLongPress: (row, col) => notifier.toggleFlag(row, col),
                ),
                if (notifier.gameStatus == MineSweeperGameStatus.won ||
                    notifier.gameStatus == MineSweeperGameStatus.lost)
                  _buildGameOverOverlay(notifier.gameStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 游戏结束遮罩
  Widget _buildGameOverOverlay(MineSweeperGameStatus status) {
    final isWon = status == MineSweeperGameStatus.won;
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => ref.read(mineSweeperProvider).resetGame(),
        child: Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isWon ? '🎉 恭喜通关!' : '💥 踩到雷了!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('点击任意位置重新开始',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
