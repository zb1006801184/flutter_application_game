import 'stickman_rect_bean.dart';

/// 敌人出生配置
class StickmanEnemySpawnBean {
  /// 出生点 X（脚底中心附近，左上角对齐用）
  final double x;

  /// 出生点 Y（顶部）
  final double y;

  /// 巡逻半宽（相对出生点左右各延伸）
  final double patrolHalf;

  const StickmanEnemySpawnBean({
    required this.x,
    required this.y,
    this.patrolHalf = 40,
  });
}

/// 关卡配置
class StickmanLevelBean {
  /// 关卡序号（0 起）
  final int index;

  /// 显示名称
  final String name;

  /// 世界宽度
  final double width;

  /// 世界高度
  final double height;

  /// 玩家出生点（左上角）
  final StickmanRectBean spawn;

  /// 终点旗帜区域
  final StickmanRectBean goal;

  /// 平台列表
  final List<StickmanRectBean> platforms;

  /// 尖刺列表
  final List<StickmanRectBean> spikes;

  /// 敌人出生点
  final List<StickmanEnemySpawnBean> enemies;

  const StickmanLevelBean({
    required this.index,
    required this.name,
    required this.width,
    required this.height,
    required this.spawn,
    required this.goal,
    required this.platforms,
    required this.spikes,
    required this.enemies,
  });

  /// 全部关卡（共 3 关）
  static List<StickmanLevelBean> get all => [_level1, _level2, _level3];

  /// 按索引取关卡，非法则回退第 1 关
  static StickmanLevelBean byIndex(int index) {
    if (index < 0 || index >= all.length) {
      return all.first;
    }
    return all[index];
  }
}

/// 第 1 关：教学向（连续地面 + 跳过的尖刺）
const StickmanLevelBean _level1 = StickmanLevelBean(
  index: 0,
  name: '第 1 关',
  width: 1400,
  height: 360,
  spawn: StickmanRectBean(x: 40, y: 260, w: 22, h: 40),
  goal: StickmanRectBean(x: 1280, y: 220, w: 28, h: 60),
  platforms: [
    // 起始地面
    StickmanRectBean(x: 0, y: 320, w: 340, h: 40),
    // 尖刺后的地面
    StickmanRectBean(x: 400, y: 320, w: 320, h: 40),
    // 第二段尖刺后
    StickmanRectBean(x: 800, y: 320, w: 200, h: 40),
    // 终点高台
    StickmanRectBean(x: 1020, y: 280, w: 380, h: 80),
    // 可选中间高台
    StickmanRectBean(x: 540, y: 260, w: 100, h: 20),
  ],
  spikes: [
    // 地面缺口处的尖刺（跳过去）
    StickmanRectBean(x: 340, y: 304, w: 60, h: 16),
    StickmanRectBean(x: 720, y: 304, w: 80, h: 16),
  ],
  enemies: [
    StickmanEnemySpawnBean(x: 500, y: 286, patrolHalf: 60),
    StickmanEnemySpawnBean(x: 1100, y: 246, patrolHalf: 70),
  ],
);

/// 第 2 关：更多尖刺与高低差
const StickmanLevelBean _level2 = StickmanLevelBean(
  index: 1,
  name: '第 2 关',
  width: 1800,
  height: 360,
  spawn: StickmanRectBean(x: 40, y: 260, w: 22, h: 40),
  goal: StickmanRectBean(x: 1680, y: 160, w: 28, h: 60),
  platforms: [
    // 起始地面
    StickmanRectBean(x: 0, y: 320, w: 280, h: 40),
    // 尖刺后地面
    StickmanRectBean(x: 360, y: 320, w: 240, h: 40),
    // 第二段
    StickmanRectBean(x: 680, y: 320, w: 180, h: 40),
    // 第三段
    StickmanRectBean(x: 940, y: 320, w: 160, h: 40),
    // 高台
    StickmanRectBean(x: 540, y: 250, w: 120, h: 20),
    StickmanRectBean(x: 760, y: 220, w: 120, h: 20),
    // 终点平台
    StickmanRectBean(x: 1180, y: 220, w: 140, h: 20),
    StickmanRectBean(x: 1380, y: 200, w: 420, h: 80),
  ],
  spikes: [
    StickmanRectBean(x: 280, y: 304, w: 80, h: 16),
    StickmanRectBean(x: 600, y: 304, w: 80, h: 16),
    StickmanRectBean(x: 860, y: 304, w: 80, h: 16),
    StickmanRectBean(x: 1100, y: 204, w: 80, h: 16),
  ],
  enemies: [
    StickmanEnemySpawnBean(x: 460, y: 286, patrolHalf: 70),
    StickmanEnemySpawnBean(x: 600, y: 216, patrolHalf: 40),
    StickmanEnemySpawnBean(x: 780, y: 186, patrolHalf: 40),
    StickmanEnemySpawnBean(x: 1500, y: 166, patrolHalf: 80),
  ],
);

/// 第 3 关：碎平台跳跃 + 更多敌人
const StickmanLevelBean _level3 = StickmanLevelBean(
  index: 2,
  name: '第 3 关',
  width: 2200,
  height: 360,
  spawn: StickmanRectBean(x: 40, y: 260, w: 22, h: 40),
  goal: StickmanRectBean(x: 2080, y: 120, w: 28, h: 60),
  platforms: [
    // 起始地面
    StickmanRectBean(x: 0, y: 320, w: 260, h: 40),
    // 尖刺后
    StickmanRectBean(x: 380, y: 320, w: 180, h: 40),
    // 碎平台爬升
    StickmanRectBean(x: 620, y: 290, w: 100, h: 18),
    StickmanRectBean(x: 780, y: 260, w: 100, h: 18),
    StickmanRectBean(x: 940, y: 230, w: 100, h: 18),
    // 中段地面
    StickmanRectBean(x: 1100, y: 320, w: 200, h: 40),
    // 继续碎平台
    StickmanRectBean(x: 1360, y: 270, w: 100, h: 18),
    StickmanRectBean(x: 1520, y: 230, w: 100, h: 18),
    StickmanRectBean(x: 1680, y: 200, w: 100, h: 18),
    // 终点平台
    StickmanRectBean(x: 1840, y: 180, w: 360, h: 80),
  ],
  spikes: [
    StickmanRectBean(x: 260, y: 304, w: 120, h: 16),
    StickmanRectBean(x: 560, y: 304, w: 60, h: 16),
    StickmanRectBean(x: 1300, y: 304, w: 60, h: 16),
  ],
  enemies: [
    StickmanEnemySpawnBean(x: 440, y: 286, patrolHalf: 60),
    StickmanEnemySpawnBean(x: 660, y: 256, patrolHalf: 30),
    StickmanEnemySpawnBean(x: 980, y: 196, patrolHalf: 30),
    StickmanEnemySpawnBean(x: 1180, y: 286, patrolHalf: 60),
    StickmanEnemySpawnBean(x: 1400, y: 236, patrolHalf: 30),
    StickmanEnemySpawnBean(x: 1980, y: 146, patrolHalf: 80),
  ],
);
