/// 预估价表单拖拽面板状态枚举
/// 对应 RideEstimateFormConstants 中的三种吸附档位
enum RideEstimateFormStatus {
  /// 最小态：抽屉收起，仅露出顶部一部分（0.3）
  minimum,

  /// 中间态：抽屉半展开，默认初始状态（0.55）
  middle,

  /// 最高态：抽屉完全展开，内部列表可继续滚动（0.9）
  maximum,
}
