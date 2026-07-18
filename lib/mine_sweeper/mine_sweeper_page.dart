import 'package:flutter/material.dart';

import 'bean/mine_sweeper_game_config_bean.dart';
import 'mine_sweeper_game_page.dart';

/// 扫雷 - 难度选择页面
class MineSweeperPage extends StatelessWidget {
  const MineSweeperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫雷')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.brightness_7, size: 64, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                '选择难度',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              ...MineSweeperGameConfigBean.all.map((config) => _buildDifficultyCard(context, config)),
            ],
          ),
        ),
      ),
    );
  }

  /// 难度选项卡片
  Widget _buildDifficultyCard(BuildContext context, MineSweeperGameConfigBean config) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MineSweeperGamePage(config: config),
              ),
            );
          },
          child: Text(
            '${config.name}  (${config.rows}×${config.cols}, ${config.mineCount}颗雷)',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
