import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import 'bean/stickman_level_bean.dart';
import 'enum/stickman_game_status.dart';
import 'provider/stickman_provider.dart';
import 'widgets/stickman_action_pad_widget.dart';
import 'widgets/stickman_game_board_widget.dart';
import 'widgets/stickman_game_header_widget.dart';
import 'widgets/stickman_joystick_widget.dart';

/// 火柴人闯关 - 游戏对战页
class StickmanGamePage extends ConsumerStatefulWidget {
  /// 关卡索引（0 起）
  final int levelIndex;

  const StickmanGamePage({super.key, required this.levelIndex});

  @override
  ConsumerState<StickmanGamePage> createState() => _StickmanGamePageState();
}

class _StickmanGamePageState extends ConsumerState<StickmanGamePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stickmanProvider).startGame(widget.levelIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(stickmanProvider);

    return Scaffold(
      appBar: AppBar(title: Text(notifier.level.name)),
      body: Column(
        children: [
          StickmanGameHeaderWidget(
            hp: notifier.player.hp,
            levelName: notifier.level.name,
            gameStatus: notifier.gameStatus,
            onTogglePause: () => notifier.togglePause(),
            onRestart: () => notifier.startGame(notifier.levelIndex),
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: _buildBoardArea(notifier),
            ),
          ),
          _buildControls(notifier),
        ],
      ),
    );
  }

  /// 场景区域（含遮罩）
  Widget _buildBoardArea(StickmanNotifier notifier) {
    return Stack(
      children: [
        StickmanGameBoardWidget(
          level: notifier.level,
          player: notifier.player,
          enemies: notifier.enemies,
          invincibleMsLeft: notifier.invincibleMsLeft,
        ),
        // idle 为首帧启动前状态，不展示遮罩以免闪一下
        if (notifier.gameStatus != StickmanGameStatus.playing &&
            notifier.gameStatus != StickmanGameStatus.idle)
          _buildOverlay(notifier),
      ],
    );
  }

  /// 底部操作区
  Widget _buildControls(StickmanNotifier notifier) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Row(
          children: [
            StickmanJoystickWidget(
              onChanged: (v) => notifier.setMoveInput(v),
            ),
            const Spacer(),
            StickmanActionPadWidget(
              onJump: () => notifier.jump(),
              onAttack: () => notifier.attack(),
            ),
          ],
        ),
      ),
    );
  }

  /// 暂停 / 胜负遮罩
  Widget _buildOverlay(StickmanNotifier notifier) {
    final status = notifier.gameStatus;
    final isWon = status == StickmanGameStatus.won;
    final isLost = status == StickmanGameStatus.lost;
    final isPaused = status == StickmanGameStatus.paused;

    String title;
    if (isWon) {
      title = '通关成功！';
    } else if (isLost) {
      title = '挑战失败';
    } else if (isPaused) {
      title = '已暂停';
    } else {
      title = '准备开始';
    }

    final hasNext =
        isWon && notifier.levelIndex < StickmanLevelBean.all.length - 1;

    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.45),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
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
                const SizedBox(height: 16),
                if (isPaused)
                  ElevatedButton(
                    onPressed: () => notifier.togglePause(),
                    child: const Text('继续'),
                  ),
                if (isWon || isLost) ...[
                  ElevatedButton(
                    onPressed: () =>
                        notifier.startGame(notifier.levelIndex),
                    child: const Text('重来'),
                  ),
                  if (hasNext) ...[
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          notifier.startGame(notifier.levelIndex + 1),
                      child: const Text('下一关'),
                    ),
                  ],
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.go(AppRoutePath.stickman),
                    child: const Text('返回选关'),
                  ),
                ],
                if (isPaused) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        notifier.startGame(notifier.levelIndex),
                    child: const Text('重开'),
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutePath.stickman),
                    child: const Text('返回选关'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
