import 'package:flutter/material.dart';

import '../router/app_router.dart';
import 'game_item.dart';

/// 首页游戏列表数据源
///
/// 新增游戏时，在此列表中追加一项 [GameItem] 即可
final List<GameItem> games = [
  GameItem(
    name: '扫雷',
    description: '经典扫雷游戏，支持初/中/高三个难度',
    icon: Icons.brightness_7,
    color: Colors.orange,
    routePath: AppRoutePath.mineSweeper,
  ),
  GameItem(
    name: '俄罗斯方块',
    description: '经典消除类游戏，移动旋转方块填满整行得分',
    icon: Icons.grid_view,
    color: Colors.deepPurple,
    routePath: AppRoutePath.tetris,
  ),
  GameItem(
    name: '羊了个羊',
    description: '三层堆叠消除游戏，点击相同图案集齐 3 个即可消除',
    icon: Icons.pets,
    color: Colors.green,
    routePath: AppRoutePath.sheep,
  ),
  GameItem(
    name: '火柴人闯关',
    description: '横版跑跳闯关，攻击小怪、躲避尖刺，抵达终点通关',
    icon: Icons.directions_run,
    color: Colors.deepOrange,
    routePath: AppRoutePath.stickman,
  ),
];
