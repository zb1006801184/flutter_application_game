import 'package:flutter/material.dart';

import '../mine_sweeper/mine_sweeper_page.dart';
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
    pageBuilder: (_) => const MineSweeperPage(),
  ),
];
