import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';
import 'bean/stickman_level_bean.dart';

/// 火柴人闯关 - 开始 / 选关页
class StickmanPage extends StatelessWidget {
  const StickmanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('火柴人闯关')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.directions_run, size: 64, color: Colors.deepOrange),
              const SizedBox(height: 16),
              const Text(
                '火柴人闯关',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '操控火柴人跑跳闯关，攻击小怪，避开尖刺，抵达终点旗帜',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ...StickmanLevelBean.all.map(
                (level) => _buildLevelButton(context, level),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 关卡入口按钮
  Widget _buildLevelButton(BuildContext context, StickmanLevelBean level) {
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
            context.push(AppRoutePath.stickmanGame, extra: level.index);
          },
          child: Text(level.name, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
