/// 羊了个羊 - 游戏状态
enum SheepGameStatus {
  /// 未开始
  idle,

  /// 进行中
  playing,

  /// 暂停
  paused,

  /// 胜利
  won,

  /// 失败（槽位已满且无法消除）
  lost,
}
