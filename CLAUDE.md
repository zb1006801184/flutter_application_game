# 项目规则

## 项目简介
- 这是一个 Flutter 项目

## 项目架构

### 模块文件结构
```
lib/pages/模块名/
├── provider/
│   ├── 模块名_provider_base.dart      # 基础逻辑类 (extends GetxController)
│   ├── 模块名_provider.dart           # 主逻辑控制器 (组合各功能 mixin)
│   ├── 模块名_功能_provider.dart       # 功能模块逻辑 (mixin)
├── widgets/                       # UI 子组件（>100 行单独拆文件）
├── enum/                          # 枚举定义
├── bean/                          # 数据模型
└── 模块名_page.dart               # 主页面（>20 行子视图拆 _buildXxxWidget）
```

### 状态管理riverpod的使用 
1 必须使用 ChangeNotifierProvider + ChangeNotifier 