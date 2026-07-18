/// 游戏难度配置
class MineSweeperGameConfigBean {
  /// 行数
  final int rows;

  /// 列数
  final int cols;

  /// 雷数
  final int mineCount;

  /// 难度名称
  final String name;

  const MineSweeperGameConfigBean({
    required this.rows,
    required this.cols,
    required this.mineCount,
    required this.name,
  });

  /// 初级: 9×9, 10颗雷
  static const easy = MineSweeperGameConfigBean(
    rows: 9,
    cols: 9,
    mineCount: 10,
    name: '初级',
  );

  /// 中级: 16×16, 40颗雷
  static const medium = MineSweeperGameConfigBean(
    rows: 16,
    cols: 16,
    mineCount: 40,
    name: '中级',
  );

  /// 高级: 16×30, 99颗雷
  static const hard = MineSweeperGameConfigBean(
    rows: 16,
    cols: 30,
    mineCount: 99,
    name: '高级',
  );

  /// 所有难度列表
  static const List<MineSweeperGameConfigBean> all = [easy, medium, hard];
}
