import 'package:flutter/material.dart';

/// 羊了个羊 - 方块图案类型
///
/// 每种类型对应一个 emoji 图案与背景色，用于在棋盘与槽位中渲染
enum SheepTileType {
  sheep('🐑', Color(0xFFFFCDD2)),
  flower('🌸', Color(0xFFF8BBD0)),
  apple('🍎', Color(0xFFFFC107)),
  leaf('🌿', Color(0xFFC8E6C9)),
  sun('☀️', Color(0xFFFFF59D)),
  star('⭐', Color(0xFFFFF176)),
  bee('🐝', Color(0xFFFFE0B2)),
  rainbow('🌈', Color(0xFFB3E5FC)),
  strawberry('🍓', Color(0xFFF06292)),
  fish('🐟', Color(0xFFB2EBF2));

  /// emoji 图案
  final String emoji;

  /// 背景色
  final Color color;

  const SheepTileType(this.emoji, this.color);
}
