import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

typedef RideSheetBuilder = Widget Function(
  BuildContext context,
  ScrollController scrollController,
);

/// 精简版可拖拽 Sheet，fork 自 Flutter DraggableScrollableSheet。
/// 与官方版本差异：goBallistic 中改用「位移阈值」吸附（参考业务原逻辑），
/// 而非官方的「速度方向」吸附；吸附由 ballistic 本身驱动，无 animateTo 竞争。
class RideDraggableSheet extends StatefulWidget {
  const RideDraggableSheet({
    super.key,
    required this.initialChildSize,
    required this.minChildSize,
    required this.maxChildSize,
    required this.snapSizes,
    required this.snapAnimationDuration,
    required this.snapAnimationCurve,
    required this.dragSnapThresholdPx,
    required this.controller,
    required this.builder,
  });

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final List<double> snapSizes;
  final Duration snapAnimationDuration;
  /// 吸附动画曲线，由外部业务常量注入
  final Curve snapAnimationCurve;
  final double dragSnapThresholdPx;
  final RideSheetController controller;
  final RideSheetBuilder builder;

  @override
  State<RideDraggableSheet> createState() => _RideDraggableSheetState();
}

class _RideDraggableSheetState extends State<RideDraggableSheet> {
  late final _RideSheetExtent _extent;
  late final _RideSheetScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _extent = _RideSheetExtent(
      minSize: widget.minChildSize,
      maxSize: widget.maxChildSize,
      snapSizes: widget.snapSizes,
      initialSize: widget.initialChildSize,
      dragSnapThresholdPx: widget.dragSnapThresholdPx,
      snapAnimationDuration: widget.snapAnimationDuration,
      snapAnimationCurve: widget.snapAnimationCurve,
    );
    _scrollController = _RideSheetScrollController(extent: _extent);
    widget.controller._attach(_scrollController);
  }

  @override
  void dispose() {
    widget.controller._detach(disposeExtent: true);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: _extent._currentSize,
      builder: (context, currentSize, child) => LayoutBuilder(
        builder: (context, constraints) {
          _extent.availablePixels =
              widget.maxChildSize * constraints.biggest.height;
          return SizedBox.expand(
            child: FractionallySizedBox(
              heightFactor: currentSize,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
          );
        },
      ),
      child: widget.builder(context, _scrollController),
    );
  }
}

class RideSheetController extends ChangeNotifier {
  _RideSheetScrollController? _attachedController;

  double get size {
    _assertAttached();
    return _attachedController!.extent.currentSize;
  }

  bool get isAttached =>
      _attachedController != null && _attachedController!.hasClients;

  Future<void> animateTo(
    double size, {
    required Duration duration,
    required Curve curve,
  }) async {
    _assertAttached();
    final animationController = AnimationController.unbounded(
      vsync: _attachedController!.position.context.vsync,
      value: _attachedController!.extent.currentSize,
    );
    _attachedController!.position.goIdle();
    _attachedController!.extent.hasDragged = false;
    _attachedController!.extent.startActivity(onCanceled: () {
      if (animationController.isAnimating) animationController.stop();
    });
    animationController.addListener(() {
      _attachedController!.extent.updateSize(
        animationController.value,
        _attachedController!.position.context.notificationContext!,
      );
    });
    await animationController.animateTo(
      clampDouble(size, _attachedController!.extent.minSize,
          _attachedController!.extent.maxSize),
      duration: duration,
      curve: curve,
    );
    animationController.dispose();
  }

  void _assertAttached() {
    assert(isAttached,
        'RideSheetController is not attached to a sheet.');
  }

  void _attach(_RideSheetScrollController scrollController) {
    _attachedController = scrollController;
    _attachedController!.extent._currentSize.addListener(notifyListeners);
  }

  void _detach({bool disposeExtent = false}) {
    if (disposeExtent) {
      _attachedController?.extent.dispose();
    } else {
      _attachedController?.extent._currentSize.removeListener(notifyListeners);
    }
    _attachedController = null;
  }
}

class _RideSheetExtent {
  _RideSheetExtent({
    required this.minSize,
    required this.maxSize,
    required this.snapSizes,
    required this.initialSize,
    required this.dragSnapThresholdPx,
    required this.snapAnimationDuration,
    required this.snapAnimationCurve,
  })  : _currentSize = ValueNotifier<double>(initialSize),
        availablePixels = double.infinity;

  VoidCallback? _cancelActivity;
  final double minSize;
  final double maxSize;
  final List<double> snapSizes;
  final double initialSize;
  /// 拖拽吸附阈值（像素），由外部业务常量注入
  final double dragSnapThresholdPx;
  /// 吸附动画时长，由外部业务常量注入
  final Duration snapAnimationDuration;
  /// 吸附动画曲线，由外部业务常量注入
  final Curve snapAnimationCurve;
  final ValueNotifier<double> _currentSize;
  double availablePixels;
  bool hasDragged = false;

  bool get isAtMin => minSize >= _currentSize.value;
  bool get isAtMax => maxSize <= _currentSize.value;
  double get currentSize => _currentSize.value;
  double get currentPixels => sizeToPixels(_currentSize.value);
  List<double> get pixelSnapSizes => snapSizes.map(sizeToPixels).toList();

  void startActivity({required VoidCallback onCanceled}) {
    _cancelActivity?.call();
    _cancelActivity = onCanceled;
  }

  void addPixelDelta(double delta, BuildContext context) {
    _cancelActivity?.call();
    _cancelActivity = null;
    hasDragged = true;
    if (availablePixels == 0) return;
    updateSize(currentSize + pixelsToSize(delta), context);
  }

  void updateSize(double newSize, BuildContext context) {
    final clamped = clampDouble(newSize, minSize, maxSize);
    if (_currentSize.value == clamped) return;
    _currentSize.value = clamped;
  }

  double pixelsToSize(double pixels) => pixels / availablePixels * maxSize;
  double sizeToPixels(double size) => size / maxSize * availablePixels;

  void dispose() => _currentSize.dispose();
}

class _RideSheetScrollController extends ScrollController {
  _RideSheetScrollController({required this.extent});
  _RideSheetExtent extent;

  @override
  _RideSheetScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _RideSheetScrollPosition(
      physics: physics.applyTo(const AlwaysScrollableScrollPhysics()),
      context: context,
      oldPosition: oldPosition,
      getExtent: () => extent,
    );
  }

  @override
  _RideSheetScrollPosition get position =>
      super.position as _RideSheetScrollPosition;
}

class _RideSheetScrollPosition extends ScrollPositionWithSingleContext {
  _RideSheetScrollPosition({
    required super.physics,
    required super.context,
    super.oldPosition,
    required this.getExtent,
  });

  final _RideSheetExtent Function() getExtent;
  VoidCallback? _dragCancelCallback;
  final Set<AnimationController> _ballisticControllers = {};

  /// 本次拖拽起始 size，用于 goBallistic 的位移阈值判定
  double? _dragStartSize;
  bool get listShouldScroll => pixels > 0.0;
  _RideSheetExtent get extent => getExtent();

  @override
  void beginActivity(ScrollActivity? newActivity) {
    for (final c in _ballisticControllers) {
      c.stop();
    }
    super.beginActivity(newActivity);
  }

  @override
  void applyUserOffset(double delta) {
    // 首次 apply 时记录起始 size（用于位移阈值）
    _dragStartSize ??= extent.currentSize;
    if (!listShouldScroll &&
        (!(extent.isAtMin || extent.isAtMax) ||
            (extent.isAtMin && delta < 0) ||
            (extent.isAtMax && delta > 0))) {
      extent.addPixelDelta(-delta, context.notificationContext!);
    } else {
      super.applyUserOffset(delta);
    }
  }

  @override
  void goBallistic(double velocity) {
    // 列表已滚动且向下拖，交给列表惯性，不吸附 sheet
    if (velocity < 0.0 && listShouldScroll) {
      _dragStartSize = null;
      super.goBallistic(velocity);
      return;
    }
    // 已到最大且继续上拖，交给列表惯性
    if (velocity > 0.0 && extent.isAtMax) {
      _dragStartSize = null;
      super.goBallistic(velocity);
      return;
    }

    _dragCancelCallback?.call();
    _dragCancelCallback = null;

    // 位移阈值吸附：用 dragStart 与当前 size 的像素差判定目标档位
    final start = _dragStartSize ?? extent.currentSize;
    _dragStartSize = null;
    final delta = extent.currentSize - start;
    final deltaPx = delta * extent.availablePixels / extent.maxSize;
    final startIndex = _nearestSnapIndex(start, extent.snapSizes);
    int targetIndex = startIndex;
    if (deltaPx.abs() >= extent.dragSnapThresholdPx) {
      targetIndex = delta > 0
          ? (startIndex + 1).clamp(0, extent.snapSizes.length - 1).toInt()
          : (startIndex - 1).clamp(0, extent.snapSizes.length - 1).toInt();
    }
    final targetSize = extent.snapSizes[targetIndex];
    final targetPx = extent.sizeToPixels(targetSize);

    final simulation = _RideSnapSimulation(
      position: extent.currentPixels,
      targetPixels: targetPx,
      duration: extent.snapAnimationDuration,
      curve: extent.snapAnimationCurve,
    );

    final ballisticController = AnimationController.unbounded(
      vsync: context.vsync,
    );
    _ballisticControllers.add(ballisticController);

    double lastPosition = extent.currentPixels;
    void tick() {
      final d = ballisticController.value - lastPosition;
      lastPosition = ballisticController.value;
      extent.addPixelDelta(d, context.notificationContext!);
      if ((velocity > 0 && extent.isAtMax) ||
          (velocity < 0 && extent.isAtMin)) {
        velocity = ballisticController.velocity +
            (physics.toleranceFor(this).velocity * ballisticController.velocity.sign);
        super.goBallistic(velocity);
        ballisticController.stop();
      } else if (ballisticController.isCompleted) {
        super.goBallistic(0);
      }
    }

    ballisticController
      ..addListener(tick)
      ..animateWith(simulation).whenCompleteOrCancel(() {
        if (_ballisticControllers.contains(ballisticController)) {
          _ballisticControllers.remove(ballisticController);
          ballisticController.dispose();
        }
      });
  }

  @override
  Drag drag(DragStartDetails details, VoidCallback dragCancelCallback) {
    _dragCancelCallback = dragCancelCallback;
    return super.drag(details, dragCancelCallback);
  }

  @override
  void dispose() {
    // 主动取消正在进行的拖拽手势，避免 widget 卸载后手势识别器触发
    // onCancel 时访问已被 dispose 的 ScrollPosition，从而抛出断言错误。
    // 该做法与官方 DraggableScrollableSheet 的实现保持一致。
    _dragCancelCallback?.call();
    _dragCancelCallback = null;
    for (final c in _ballisticControllers) {
      c.dispose();
    }
    _ballisticControllers.clear();
    super.dispose();
  }
}

int _nearestSnapIndex(double size, List<double> snapSizes) {
  int nearest = 0;
  double minDiff = double.infinity;
  for (int i = 0; i < snapSizes.length; i++) {
    final diff = (size - snapSizes[i]).abs();
    if (diff < minDiff) {
      minDiff = diff;
      nearest = i;
    }
  }
  return nearest;
}

/// 线性插值到目标像素的 Simulation（替代官方 _SnappingSimulation 的速度方向判定）
class _RideSnapSimulation extends Simulation {
  _RideSnapSimulation({
    required this.position,
    required this.targetPixels,
    required this.duration,
    required this.curve,
  });

  final double position;
  final double targetPixels;
  final Duration duration;
  final Curve curve;

  /// 总位移（带方向）
  double get _totalDelta => targetPixels - position;

  /// 归一化进度 [0, 1]
  double _progress(double time) {
    if (duration.inMicroseconds == 0) return 1.0;
    return (time / (duration.inMicroseconds / 1000000.0)).clamp(0.0, 1.0);
  }

  @override
  double x(double time) {
    final eased = curve.transform(_progress(time));
    final newPosition = position + _totalDelta * eased;
    // 超过目标后钳制到目标，避免过冲
    if ((_totalDelta >= 0 && newPosition > targetPixels) ||
        (_totalDelta < 0 && newPosition < targetPixels)) {
      return targetPixels;
    }
    return newPosition;
  }

  @override
  double dx(double time) {
    if (isDone(time)) return 0;
    // 数值微分近似瞬时速度（单位：像素/秒）
    const h = 1e-3;
    return (x(time + h) - x(time)) / h;
  }

  @override
  bool isDone(double time) => x(time) == targetPixels;
}
