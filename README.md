# flutter_application_game

一个基于 Flutter 开发的轻量级小游戏合集应用，目前内置「扫雷」游戏。

## 项目简介

本项目使用 Flutter 跨平台框架开发，支持 Android、iOS、macOS 多端运行。采用模块化的目录结构组织代码，便于后续扩展更多游戏玩法。

### 已实现功能

- **扫雷游戏**：经典扫雷玩法，包含游戏配置、单元格状态管理、游戏状态判定与可视化展示。

## 技术栈

| 类别 | 依赖 | 版本 | 说明 |
| --- | --- | --- | --- |
| 框架 | Flutter | SDK ^3.6.2 | 跨平台 UI 框架 |
| 状态管理 | flutter_riverpod | 2.6.1 | 基于 ChangeNotifierProvider 的状态管理 |
| 网络请求 | dio | 5.10.0 | HTTP 客户端 |
| 数据模型 | json_annotation | 4.9.0 | JSON 序列化注解 |
| 代码生成 | build_runner / json_serializable | 2.4.15 / 6.9.5 | 自动生成 JSON 序列化代码 |

## 项目结构

```
lib/
├── main.dart                     # 应用入口
├── home/                         # 首页模块
│   ├── games.dart                # 游戏列表
│   └── game_item.dart            # 游戏条目组件
└── mine_sweeper/                 # 扫雷游戏模块
    ├── mine_sweeper_page.dart    # 扫雷主页面
    ├── mine_sweeper_game_page.dart
    ├── bean/                    # 数据模型
    ├── enum/                    # 枚举定义（单元格状态、游戏状态）
    ├── provider/               # 业务逻辑控制器
    └── widgets/                # UI 子组件（单元格、棋盘、头部信息）
```

## 快速开始

1. 确保本地已安装 Flutter SDK（版本 ^3.6.2）。
2. 在项目根目录执行依赖安装：

   ```bash
   flutter pub get
   ```

3. 如需生成 JSON 序列化代码：

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. 运行项目：

   ```bash
   flutter run
   ```

## 编码规范

- 文件与目录命名统一使用下划线风格（snake_case）。
- 类名使用大驼峰（PascalCase），变量与函数使用小驼峰。
- 视图超过 20 行拆分为私有构建方法 `_buildXxxWidget`，超过 100 行独立为文件放入 `widgets/`。
- 状态管理统一使用 Riverpod 的 `ChangeNotifierProvider + ChangeNotifier`。
