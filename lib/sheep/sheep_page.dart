import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

/// 羊了个羊 - 开始页面
class SheepPage extends StatelessWidget {
  const SheepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('羊了个羊')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🐑', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text(
                '羊了个羊',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '点击相同图案的方块放入底部槽位，集齐 3 个相同图案即可消除，'
                '清除所有方块即获胜。注意：被上层方块覆盖时无法点击，'
                '槽位满 7 个且无法消除则失败。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              _buildStartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 开始按钮
  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.push(AppRoutePath.sheepGame);
        },
        child: const Text('开始游戏', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
