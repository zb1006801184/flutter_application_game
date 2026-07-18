import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_router.dart';

/// 俄罗斯方块 - 开始页面
class TetrisPage extends StatelessWidget {
  const TetrisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('俄罗斯方块')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.grid_view, size: 64, color: Colors.deepPurple),
              const SizedBox(height: 16),
              const Text(
                '俄罗斯方块',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '经典消除类游戏，移动并旋转下落的方块，填满整行即可消除得分',
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
          context.push(AppRoutePath.tetrisGame);
        },
        child: const Text('开始游戏', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
