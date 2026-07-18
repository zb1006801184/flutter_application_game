import 'package:flutter/material.dart';

/// 俄罗斯方块形状类型
enum TetrisBlockType {
  /// I 形（青色）
  i,

  /// O 形（黄色）
  o,

  /// T 形（紫色）
  t,

  /// S 形（绿色）
  s,

  /// Z 形（红色）
  z,

  /// J 形（蓝色）
  j,

  /// L 形（橙色）
  l,
}

/// 俄罗斯方块形状类型扩展
extension TetrisBlockTypeExt on TetrisBlockType {
  /// 方块颜色
  Color get color {
    switch (this) {
      case TetrisBlockType.i:
        return Colors.cyan;
      case TetrisBlockType.o:
        return Colors.yellow;
      case TetrisBlockType.t:
        return Colors.purple;
      case TetrisBlockType.s:
        return Colors.green;
      case TetrisBlockType.z:
        return Colors.red;
      case TetrisBlockType.j:
        return Colors.blue;
      case TetrisBlockType.l:
        return Colors.orange;
    }
  }
}
