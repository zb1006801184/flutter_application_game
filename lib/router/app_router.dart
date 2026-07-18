import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../home/home_page.dart';
import '../mine_sweeper/bean/mine_sweeper_game_config_bean.dart';
import '../mine_sweeper/mine_sweeper_game_page.dart';
import '../mine_sweeper/mine_sweeper_page.dart';

/// 路由路径常量
class AppRoutePath {
  /// 首页
  static const String home = '/';

  /// 扫雷 - 难度选择
  static const String mineSweeper = '/mine_sweeper';

  /// 扫雷 - 游戏对战
  static const String mineSweeperGame = '/mine_sweeper/game';
}

/// 全局路由配置
///
/// 使用 [GoRouter] 进行声明式路由管理，支持 URL 解析、深链接与
/// 通过 [extra] 传递非字符串参数（如 [MineSweeperGameConfigBean]）
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutePath.home,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutePath.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: AppRoutePath.mineSweeper,
      builder: (BuildContext context, GoRouterState state) {
        return const MineSweeperPage();
      },
    ),
    GoRoute(
      path: AppRoutePath.mineSweeperGame,
      builder: (BuildContext context, GoRouterState state) {
        // 通过 extra 传入难度配置
        final config =
            state.extra as MineSweeperGameConfigBean? ?? MineSweeperGameConfigBean.all.first;
        return MineSweeperGamePage(config: config);
      },
    ),
  ],
);
