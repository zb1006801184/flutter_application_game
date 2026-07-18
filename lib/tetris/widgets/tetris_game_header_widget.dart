import 'package:flutter/material.dart';

import '../enum/tetris_game_status.dart';

/// 俄罗斯方块信息栏（得分、等级、行数、暂停/开始按钮）
class TetrisGameHeaderWidget extends StatelessWidget {
  /// 得分
  final int score;

  /// 等级
  final int level;

  /// 已消除行数
  final int lines;

  /// 游戏状态
  final TetrisGameStatus gameStatus;

  /// 开始/重置回调
  final VoidCallback onToggleStart;

  /// 暂停/继续回调
  final VoidCallback onTogglePause;

  const TetrisGameHeaderWidget({
    super.key,
    required this.score,
    required this.level,
    required this.lines,
    required this.gameStatus,
    required this.onToggleStart,
    required this.onTogglePause,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildInfoItem('得分', '$score')),
          Expanded(child: _buildInfoItem('等级', '$level')),
          Expanded(child: _buildInfoItem('行数', '$lines')),
          _buildActionButton(),
          _buildPauseButton(),
        ],
      ),
    );
  }

  /// 信息项
  Widget _buildInfoItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  /// 开始/重置按钮
  Widget _buildActionButton() {
    final isIdle = gameStatus == TetrisGameStatus.idle;
    final isLost = gameStatus == TetrisGameStatus.lost;
    final label = (isIdle || isLost) ? '开始' : '重置';
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: onToggleStart,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.deepPurple),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        ),
      ),
    );
  }

  /// 暂停/继续按钮
  Widget _buildPauseButton() {
    final canPause = gameStatus == TetrisGameStatus.playing ||
        gameStatus == TetrisGameStatus.paused;
    final label = gameStatus == TetrisGameStatus.paused ? '继续' : '暂停';
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GestureDetector(
        onTap: canPause ? onTogglePause : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: canPause
                ? Colors.orange.withValues(alpha: 0.1)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: canPause ? Colors.orange : Colors.grey,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: canPause ? Colors.orange : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
