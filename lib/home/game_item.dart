import 'package:flutter/material.dart';

/// 游戏项数据模型
///
/// 用于首页游戏列表展示，[routePath] 用于点击后通过 go_router 跳转的目标路由
class GameItem {
  /// 游戏名称
  final String name;

  /// 游戏描述
  final String description;

  /// 游戏图标
  final IconData icon;

  /// 图标背景色
  final Color color;

  /// 跳转页面的路由路径
  final String routePath;

  const GameItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.routePath,
  });
}
