import 'package:flutter/material.dart';

import '../enum/mine_sweeper_game_status.dart';

/// 游戏顶部信息栏（剩余雷数、笑脸按钮、计时器、标记模式开关）
class MineSweeperGameHeaderWidget extends StatelessWidget {
  final int remainingFlags;
  final int flaggedCount;
  final int elapsedSeconds;
  final MineSweeperGameStatus gameStatus;
  final bool isMarkMode;
  final VoidCallback onReset;
  final VoidCallback onToggleMarkMode;

  const MineSweeperGameHeaderWidget({
    super.key,
    required this.remainingFlags,
    required this.flaggedCount,
    required this.elapsedSeconds,
    required this.gameStatus,
    required this.isMarkMode,
    required this.onReset,
    required this.onToggleMarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCounter(Icons.flag, '$remainingFlags', Colors.red),
          _buildResetButton(),
          _buildMarkModeButton(),
          _buildCounter(Icons.timer, _formatTime(elapsedSeconds), Colors.blue),
        ],
      ),
    );
  }

  /// 计数器组件
  Widget _buildCounter(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  /// 笑脸重置按钮
  Widget _buildResetButton() {
    return GestureDetector(
      onTap: onReset,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.yellow.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(
          _faceEmoji,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  /// 标记模式切换按钮：开启后点击格子改为标记/取消旗帜
  /// 按钮右上角显示已标记的格子数量
  Widget _buildMarkModeButton() {
    final color = isMarkMode ? Colors.red : Colors.grey.shade400;
    final bgColor = isMarkMode ? Colors.red.shade50 : Colors.grey.shade100;
    return GestureDetector(
      onTap: onToggleMarkMode,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color, width: isMarkMode ? 2 : 1),
            ),
            child: Icon(
              Icons.flag_outlined,
              color: color,
              size: 22,
            ),
          ),
          // 已标记数量角标
          if (flaggedCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '$flaggedCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 根据游戏状态显示不同表情
  String get _faceEmoji {
    switch (gameStatus) {
      case MineSweeperGameStatus.idle:
        return '😊';
      case MineSweeperGameStatus.playing:
        return '😊';
      case MineSweeperGameStatus.won:
        return '😎';
      case MineSweeperGameStatus.lost:
        return '😵';
    }
  }

  /// 格式化时间显示
  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
