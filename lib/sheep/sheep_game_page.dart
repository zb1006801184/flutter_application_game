import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'enum/sheep_game_status.dart';
import 'provider/sheep_provider.dart';
import 'widgets/sheep_game_board_widget.dart';
import 'widgets/sheep_game_header_widget.dart';
import 'widgets/sheep_slot_widget.dart';

/// 羊了个羊 - 游戏对战页面
class SheepGamePage extends ConsumerWidget {
  const SheepGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sheepProvider);
    final remaining =
        notifier.tiles.where((t) => !t.isRemoved).length;

    return Scaffold(
      appBar: AppBar(title: const Text('羊了个羊')),
      body: Column(
        children: [
          SheepGameHeaderWidget(
            score: notifier.score,
            remaining: remaining,
            undoLeft: notifier.undoLeft,
            shuffleLeft: notifier.shuffleLeft,
            gameStatus: notifier.gameStatus,
            onUndo: () => notifier.undo(),
            onShuffle: () => notifier.shuffle(),
            onRestart: () => notifier.startGame(),
            onTogglePause: () => notifier.togglePause(),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildBoardArea(notifier),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: SheepSlotWidget(
              slot: notifier.slot,
              capacity: kSheepSlotCapacity,
            ),
          ),
        ],
      ),
    );
  }

  /// 棋盘区域（含游戏结束/未开始/暂停遮罩）
  Widget _buildBoardArea(SheepNotifier notifier) {
    return Stack(
      children: [
        SheepGameBoardWidget(
          tiles: notifier.tiles,
          isClickable: notifier.isClickable,
          onTap: (id) => notifier.clickTile(id),
        ),
        if (notifier.gameStatus != SheepGameStatus.playing)
          _buildOverlay(notifier.gameStatus, notifier),
      ],
    );
  }

  /// 遮罩
  Widget _buildOverlay(SheepGameStatus status, SheepNotifier notifier) {
    final isWon = status == SheepGameStatus.won;
    final isLost = status == SheepGameStatus.lost;
    final isPaused = status == SheepGameStatus.paused;
    final isIdle = status == SheepGameStatus.idle;

    String title;
    if (isWon) {
      title = '🎉 通关成功！';
    } else if (isLost) {
      title = '💥 槽位已满，游戏结束';
    } else if (isPaused) {
      title = '⏸ 已暂停';
    } else if (isIdle) {
      title = '🎮 点击"重开"开始游戏';
    } else {
      title = '';
    }

    return Positioned.fill(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          color: Colors.black.withValues(alpha: 0.45),
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isWon || isLost)
                    Text(
                      '最终得分：${notifier.score}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  if (isWon || isLost || isIdle)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton(
                        onPressed: () => notifier.startGame(),
                        child: Text(isWon ? '再玩一次' : '重新开始'),
                      ),
                    ),
                  if (isPaused)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton(
                        onPressed: () => notifier.togglePause(),
                        child: const Text('继续'),
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
