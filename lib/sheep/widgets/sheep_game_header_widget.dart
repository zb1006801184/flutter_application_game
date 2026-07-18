import 'package:flutter/material.dart';

import '../enum/sheep_game_status.dart';

/// 羊了个羊 - 顶部信息与道具栏
class SheepGameHeaderWidget extends StatelessWidget {
  /// 得分
  final int score;

  /// 剩余方块数
  final int remaining;

  /// 剩余撤销次数
  final int undoLeft;

  /// 剩余洗牌次数
  final int shuffleLeft;

  /// 游戏状态
  final SheepGameStatus gameStatus;

  /// 撤销回调
  final VoidCallback onUndo;

  /// 洗牌回调
  final VoidCallback onShuffle;

  /// 重新开始回调
  final VoidCallback onRestart;

  /// 暂停/继续回调
  final VoidCallback onTogglePause;

  const SheepGameHeaderWidget({
    super.key,
    required this.score,
    required this.remaining,
    required this.undoLeft,
    required this.shuffleLeft,
    required this.gameStatus,
    required this.onUndo,
    required this.onShuffle,
    required this.onRestart,
    required this.onTogglePause,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _buildInfo('得分', '$score'),
          const SizedBox(width: 12),
          _buildInfo('剩余', '$remaining'),
          const Spacer(),
          _buildTool(
            icon: Icons.undo,
            label: '撤销 $undoLeft',
            enabled: undoLeft > 0 && gameStatus == SheepGameStatus.playing,
            onTap: onUndo,
          ),
          const SizedBox(width: 8),
          _buildTool(
            icon: Icons.shuffle,
            label: '洗牌 $shuffleLeft',
            enabled: shuffleLeft > 0 && gameStatus == SheepGameStatus.playing,
            onTap: onShuffle,
          ),
          const SizedBox(width: 8),
          _buildTool(
            icon: gameStatus == SheepGameStatus.paused
                ? Icons.play_arrow
                : Icons.pause,
            label: gameStatus == SheepGameStatus.paused ? '继续' : '暂停',
            enabled: gameStatus == SheepGameStatus.playing ||
                gameStatus == SheepGameStatus.paused,
            onTap: onTogglePause,
          ),
          const SizedBox(width: 8),
          _buildTool(
            icon: Icons.refresh,
            label: '重开',
            enabled: true,
            onTap: onRestart,
          ),
        ],
      ),
    );
  }

  /// 信息块
  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// 道具按钮
  Widget _buildTool({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final color = enabled ? Colors.deepPurple : Colors.grey;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}
