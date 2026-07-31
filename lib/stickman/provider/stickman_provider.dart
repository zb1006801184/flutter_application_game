import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bean/stickman_enemy_bean.dart';
import '../bean/stickman_level_bean.dart';
import '../bean/stickman_player_bean.dart';
import '../bean/stickman_rect_bean.dart';
import '../enum/stickman_game_status.dart';

/// 帧间隔（约 60fps）
const Duration kStickmanTick = Duration(milliseconds: 16);

/// 重力加速度
const double kStickmanGravity = 0.5;

/// 跳跃初速度（向上为负）
const double kStickmanJumpVy = -12.5;

/// 水平移动速度
const double kStickmanMoveSpeed = 4.6;

/// 敌人巡逻速度
const double kStickmanEnemySpeed = 1.0;

/// 玩家最大生命
const int kStickmanMaxHp = 3;

/// 无敌毫秒数
const int kStickmanInvincibleMs = 1000;

/// 攻击冷却毫秒数
const int kStickmanAttackCooldownMs = 320;

/// 攻击表现持续帧数
const int kStickmanAttackAnimFrames = 10;

/// 攻击判定持续帧数（命中窗口）
const int kStickmanAttackHitFrames = 6;

/// 攻击判定宽度
const double kStickmanAttackWidth = 38;

/// 土狼时间（离开平台后仍可跳的帧数）
const int kStickmanCoyoteFrames = 6;

/// 跳跃缓冲（提前按跳着地后仍生效的帧数）
const int kStickmanJumpBufferFrames = 6;

/// 火柴人闯关逻辑控制器
class StickmanNotifier extends ChangeNotifier {
  Timer? _timer;

  /// 当前关卡
  StickmanLevelBean level = StickmanLevelBean.all.first;

  /// 玩家
  StickmanPlayerBean player = StickmanPlayerBean(x: 40, y: 260);

  /// 存活敌人
  List<StickmanEnemyBean> enemies = [];

  /// 游戏状态
  StickmanGameStatus gameStatus = StickmanGameStatus.idle;

  /// 摇杆水平输入 -1～1
  double moveInput = 0;

  /// 剩余无敌毫秒
  int invincibleMsLeft = 0;

  /// 剩余攻击冷却毫秒
  int attackCooldownMsLeft = 0;

  /// 剩余攻击动画帧
  int attackAnimFramesLeft = 0;

  /// 剩余攻击命中帧
  int attackHitFramesLeft = 0;

  /// 土狼时间剩余帧
  int coyoteFramesLeft = 0;

  /// 跳跃缓冲剩余帧
  int jumpBufferFramesLeft = 0;

  /// 当前关卡索引
  int get levelIndex => level.index;

  /// 是否处于无敌
  bool get isInvincible => invincibleMsLeft > 0;

  /// 开始指定关卡
  void startGame(int levelIndex) {
    _stopTimer();
    level = StickmanLevelBean.byIndex(levelIndex);
    player = StickmanPlayerBean(
      x: level.spawn.x,
      y: level.spawn.y,
      hp: kStickmanMaxHp,
    );
    enemies = _buildEnemies(level);
    moveInput = 0;
    invincibleMsLeft = 0;
    attackCooldownMsLeft = 0;
    attackAnimFramesLeft = 0;
    attackHitFramesLeft = 0;
    coyoteFramesLeft = 0;
    jumpBufferFramesLeft = 0;
    gameStatus = StickmanGameStatus.playing;
    _startTimer();
    notifyListeners();
  }

  /// 重置为未开始
  void resetGame() {
    _stopTimer();
    moveInput = 0;
    invincibleMsLeft = 0;
    attackCooldownMsLeft = 0;
    attackAnimFramesLeft = 0;
    enemies = [];
    gameStatus = StickmanGameStatus.idle;
    notifyListeners();
  }

  /// 暂停 / 继续
  void togglePause() {
    if (gameStatus == StickmanGameStatus.playing) {
      gameStatus = StickmanGameStatus.paused;
      _stopTimer();
      notifyListeners();
    } else if (gameStatus == StickmanGameStatus.paused) {
      gameStatus = StickmanGameStatus.playing;
      _startTimer();
      notifyListeners();
    }
  }

  /// 设置摇杆水平输入
  void setMoveInput(double value) {
    if (gameStatus != StickmanGameStatus.playing) {
      return;
    }
    moveInput = value.clamp(-1.0, 1.0);
    if (moveInput > 0.1) {
      player.facingRight = true;
    } else if (moveInput < -0.1) {
      player.facingRight = false;
    }
  }

  /// 跳跃（带跳跃缓冲 + 土狼时间）
  void jump() {
    if (gameStatus != StickmanGameStatus.playing) {
      return;
    }
    // 记录缓冲，着地时消费
    jumpBufferFramesLeft = kStickmanJumpBufferFrames;
    _tryConsumeJump();
  }

  /// 尝试执行跳跃
  void _tryConsumeJump() {
    final canJump = player.onGround || coyoteFramesLeft > 0;
    if (!canJump) {
      return;
    }
    player.vy = kStickmanJumpVy;
    player.onGround = false;
    coyoteFramesLeft = 0;
    jumpBufferFramesLeft = 0;
  }

  /// 近战攻击
  void attack() {
    if (gameStatus != StickmanGameStatus.playing) {
      return;
    }
    if (attackCooldownMsLeft > 0) {
      return;
    }
    attackCooldownMsLeft = kStickmanAttackCooldownMs;
    attackAnimFramesLeft = kStickmanAttackAnimFrames;
    attackHitFramesLeft = kStickmanAttackHitFrames;
    player.isAttacking = true;
    _applyAttackHit();
    notifyListeners();
  }

  /// 攻击命中判定（持续窗口内每帧调用）
  void _applyAttackHit() {
    if (attackHitFramesLeft <= 0) {
      return;
    }
    final hit = _attackHitbox();
    enemies.removeWhere((enemy) {
      final rect = StickmanRectBean(
        x: enemy.x,
        y: enemy.y,
        w: StickmanEnemyBean.width,
        h: StickmanEnemyBean.height,
      );
      return hit.overlaps(rect);
    });
  }

  /// 构建敌人列表
  List<StickmanEnemyBean> _buildEnemies(StickmanLevelBean lv) {
    var id = 0;
    return lv.enemies.map((spawn) {
      return StickmanEnemyBean(
        id: id++,
        x: spawn.x,
        y: spawn.y,
        patrolLeft: spawn.x - spawn.patrolHalf,
        patrolRight: spawn.x + spawn.patrolHalf,
      );
    }).toList();
  }

  /// 攻击判定盒
  StickmanRectBean _attackHitbox() {
    final offsetX = player.facingRight
        ? StickmanPlayerBean.width
        : -kStickmanAttackWidth;
    return StickmanRectBean(
      x: player.x + offsetX,
      y: player.y + 4,
      w: kStickmanAttackWidth,
      h: StickmanPlayerBean.height - 8,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(kStickmanTick, (_) => _tick());
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 单帧更新
  void _tick() {
    if (gameStatus != StickmanGameStatus.playing) {
      return;
    }

    final dtMs = kStickmanTick.inMilliseconds;
    if (invincibleMsLeft > 0) {
      invincibleMsLeft = (invincibleMsLeft - dtMs).clamp(0, kStickmanInvincibleMs);
    }
    if (attackCooldownMsLeft > 0) {
      attackCooldownMsLeft =
          (attackCooldownMsLeft - dtMs).clamp(0, kStickmanAttackCooldownMs);
    }
    if (attackAnimFramesLeft > 0) {
      attackAnimFramesLeft--;
      if (attackAnimFramesLeft == 0) {
        player.isAttacking = false;
      }
    }
    if (attackHitFramesLeft > 0) {
      attackHitFramesLeft--;
      _applyAttackHit();
    }
    if (jumpBufferFramesLeft > 0) {
      jumpBufferFramesLeft--;
      _tryConsumeJump();
    }

    _updatePlayerPhysics();
    _updateEnemies();
    _resolveHazards();
    _checkGoal();

    notifyListeners();
  }

  /// 玩家物理与平台碰撞（扫描式防穿透）
  void _updatePlayerPhysics() {
    final wasOnGround = player.onGround;

    // 水平移动
    player.vx = moveInput.abs() < 0.05 ? 0 : moveInput * kStickmanMoveSpeed;
    player.x += player.vx;

    // 限制在关卡水平范围内
    if (player.x < 0) {
      player.x = 0;
    }
    final maxX = level.width - StickmanPlayerBean.width;
    if (player.x > maxX) {
      player.x = maxX;
    }

    // 水平与平台侧向碰撞（仅当不在平台顶面时推开）
    _resolveHorizontalPlatforms();

    // 重力 + 垂直移动
    player.vy += kStickmanGravity;
    if (player.vy > 18) {
      player.vy = 18; // 限速防穿透
    }
    final prevBottom = player.y + StickmanPlayerBean.height;
    player.y += player.vy;
    player.onGround = false;
    _resolveVerticalPlatforms(prevBottom);

    // 土狼时间：刚离开平台仍可跳
    if (wasOnGround && !player.onGround && player.vy >= 0) {
      coyoteFramesLeft = kStickmanCoyoteFrames;
    } else if (coyoteFramesLeft > 0) {
      coyoteFramesLeft--;
    }

    // 走路动画
    if (player.onGround && player.vx.abs() > 0.1) {
      player.walkPhase += 0.42;
    } else if (!player.onGround) {
      player.walkPhase = 0.6;
    } else {
      player.walkPhase *= 0.7;
    }

    // 掉出地图
    if (player.y > level.height + 40) {
      _lose();
    }
  }

  /// 水平方向平台碰撞
  void _resolveHorizontalPlatforms() {
    final body = player.rect;
    for (final p in level.platforms) {
      if (!body.overlaps(p)) {
        continue;
      }
      // 脚踩或接近平台顶面时不做水平推开（避免着地抖动）
      if (body.bottom <= p.y + 8 && player.vy >= 0) {
        continue;
      }
      final overlapLeft = body.right - p.x;
      final overlapRight = p.right - body.x;
      if (overlapLeft < overlapRight) {
        player.x = p.x - StickmanPlayerBean.width;
      } else {
        player.x = p.right;
      }
    }
  }

  /// 垂直方向平台碰撞（扫描式：用上一帧脚底位置判断穿越）
  void _resolveVerticalPlatforms(double prevBottom) {
    final body = player.rect;
    for (final p in level.platforms) {
      if (!body.overlaps(p)) {
        continue;
      }
      // 从上往下落：上一帧脚底在平台顶之上或刚好，本帧穿过 → 着地
      if (player.vy >= 0 && prevBottom <= p.y + 1) {
        player.y = p.y - StickmanPlayerBean.height;
        player.vy = 0;
        player.onGround = true;
        continue;
      }
      // 从下往上撞天花板：上一帧头顶在平台底之下
      if (player.vy < 0) {
        final prevTop = body.y - player.vy;
        if (prevTop >= p.bottom - 1) {
          player.y = p.bottom;
          player.vy = 0;
        }
      }
    }
  }

  /// 敌人巡逻
  void _updateEnemies() {
    for (final enemy in enemies) {
      final dir = enemy.movingRight ? 1.0 : -1.0;
      enemy.x += dir * kStickmanEnemySpeed;
      if (enemy.x <= enemy.patrolLeft) {
        enemy.x = enemy.patrolLeft;
        enemy.movingRight = true;
      } else if (enemy.x + StickmanEnemyBean.width >= enemy.patrolRight) {
        enemy.x = enemy.patrolRight - StickmanEnemyBean.width;
        enemy.movingRight = false;
      }
    }
  }

  /// 尖刺 / 敌人伤害
  void _resolveHazards() {
    if (isInvincible) {
      return;
    }
    final body = player.rect;
    for (final spike in level.spikes) {
      if (body.overlaps(spike)) {
        _takeDamage();
        return;
      }
    }
    for (final enemy in enemies) {
      final rect = StickmanRectBean(
        x: enemy.x,
        y: enemy.y,
        w: StickmanEnemyBean.width,
        h: StickmanEnemyBean.height,
      );
      if (body.overlaps(rect)) {
        _takeDamage();
        return;
      }
    }
  }

  /// 受伤
  void _takeDamage() {
    player.hp -= 1;
    invincibleMsLeft = kStickmanInvincibleMs;
    // 轻推开，避免连续贴脸
    player.vy = -6;
    player.x += player.facingRight ? -18 : 18;
    if (player.x < 0) {
      player.x = 0;
    }
    if (player.hp <= 0) {
      _lose();
    }
  }

  /// 终点判定
  void _checkGoal() {
    if (player.rect.overlaps(level.goal)) {
      gameStatus = StickmanGameStatus.won;
      _stopTimer();
    }
  }

  /// 失败
  void _lose() {
    gameStatus = StickmanGameStatus.lost;
    _stopTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

/// 火柴人闯关 Provider
final stickmanProvider =
    ChangeNotifierProvider.autoDispose<StickmanNotifier>((ref) {
  return StickmanNotifier();
});
