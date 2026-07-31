import 'package:flutter/material.dart';

import '../enum/stickman_game_status.dart';
import '../provider/stickman_provider.dart';

/// 火柴人闯关顶部信息栏
class StickmanGameHeaderWidget extends StatelessWidget {
  /// 当前生命
  final int hp;

  /// 关卡名称
  final String levelName;

  /// 游戏状态
  final StickmanGameStatus gameStatus;

  /// 暂停回调
  final VoidCallback onTogglePause;

  /// 重开回调
  final VoidCallback onRestart;

  const StickmanGameHeaderWidget({
    super.key,
    required this.hp,
    required this.levelName,
    required this.gameStatus,
    required this.onTogglePause,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(
            levelName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 16),
          _buildHearts(),
          const Spacer(),
          IconButton(
            tooltip: '暂停',
            onPressed: gameStatus == StickmanGameStatus.playing ||
                    gameStatus == StickmanGameStatus.paused
                ? onTogglePause
                : null,
            icon: Icon(
              gameStatus == StickmanGameStatus.paused
                  ? Icons.play_arrow
                  : Icons.pause,
            ),
          ),
          IconButton(
            tooltip: '重开',
            onPressed: onRestart,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  /// 心心生命显示
  Widget _buildHearts() {
    return Row(
      children: List.generate(kStickmanMaxHp, (i) {
        final alive = i < hp;
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Icon(
            alive ? Icons.favorite : Icons.favorite_border,
            color: alive ? Colors.redAccent : Colors.grey,
            size: 22,
          ),
        );
      }),
    );
  }
}
