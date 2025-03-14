import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import 'custom_page_view_physics.dart';

class CarouselWidget extends StatefulWidget {
  /// Count of carousel items. required parameter
  final int count;

  /// Used to build child widgets. required parameter
  final IndexedWidgetBuilder itemBuilder;

  /// Scroll direction, default is Axis.horizontal
  final Axis scrollDirection;

  /// Whether manual scrolling is allowed. default is true
  final bool canManualSwitch;

  /// Auto carousel is allowed, default is true
  final bool autoCarousel;

  /// Whether to interrupt the auto carousel after manual scrolling. default is false
  final bool interruptCarousel;

  /// Whether to enable infinite scrolling. default is true
  final bool loop;

  /// Auto carousel interval, in milliseconds, default is 5000
  final int carouselIntervalMs;

  /// Scroll duration, in milliseconds, default is 300
  final int animationDurationMs;

  /// Animation curve, default is Curves.linear
  final Curve animationCurve;

  /// Carousel item changed callback, default is null
  final ValueChanged<int>? changedCallback;

  /// For the PageView's controller: if not provided externally, the system will create one internally;
  /// if passed externally, you need to handle the cleanup logic yourself.
  final PageController? controller;

  const CarouselWidget({
    super.key,
    required this.count,
    required this.itemBuilder,
    this.scrollDirection = Axis.horizontal,
    this.canManualSwitch = true,
    this.autoCarousel = true,
    this.interruptCarousel = false,
    this.loop = true,
    this.carouselIntervalMs = 5000,
    this.animationDurationMs = 300,
    this.animationCurve = Curves.linear,
    this.changedCallback,
    this.controller,
  });

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  PageController? _controller;
  Timer? _timer;
  bool _isResumeTimer = true;
  double _initial = 0.0;
  late bool _isLoop;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _isLoop = widget.loop;
    if (widget.autoCarousel) {
      _controller ??= PageController();
      _isLoop = true;
    }
    _handleAutoPlay();
  }

  @override
  void didUpdateWidget(covariant CarouselWidget oldWidget) {
    _handleAutoPlay();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();

    // The controller sent in from outside does not process dispose and leaves it to outside for processing
    if (widget.controller == null) {
      _controller?.dispose();
    }
    _clearTimer();
  }

  void _handleAutoPlay() {
    bool autoPlayEnabled = widget.autoCarousel;

    if (autoPlayEnabled && _timer != null) return;

    _clearTimer();
    if (autoPlayEnabled) {
      _resumeTimer();
    }
  }

  void _resumeTimer() {
    if (!_isResumeTimer) {
      return;
    }
    _timer ??= _getTimer();
  }

  void _clearTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  Timer _getTimer() {
    return Timer.periodic(Duration(milliseconds: widget.carouselIntervalMs),
        (timer) {
      if (!mounted) {
        _clearTimer();
        return;
      }
      final route = ModalRoute.of(context);
      if (route?.isCurrent == false) {
        return;
      }
      if (_controller == null || _controller!.page == null) {
        return;
      }
      int nextPage = _controller!.page!.round() + 1;
      _controller?.animateToPage(nextPage,
          duration: Duration(milliseconds: widget.animationDurationMs),
          curve: widget.animationCurve);
    });
  }

  void _pageChanged(int page) {
    if (page >= widget.count) {
      page = 0;
    }
    widget.changedCallback?.call(page);
  }

  @override
  Widget build(BuildContext context) {
    Widget pageView = PageView.builder(
      scrollDirection: widget.scrollDirection,
      controller: _controller,
      physics: widget.canManualSwitch
          ? const CustomPageViewScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (buildContext, index) {
        int currentPage = index;
        if (currentPage < 0) currentPage = 0;
        int realPage = currentPage % widget.count;
        _pageChanged(realPage);
        return widget.itemBuilder(buildContext, realPage);
      },
      itemCount: _isLoop ? null : widget.count,
    );
    if (widget.canManualSwitch && widget.autoCarousel) {
      if (widget.interruptCarousel) {
        return _getListenerWrapper2(pageView);
      }
      return _getListenerWrapper(pageView);
    } else {
      return pageView;
    }
  }

  /// slide horizontally to stop carousel
  Widget _getListenerWrapper2(Widget child) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _initial = event.position.dx;
        _clearTimer();
      },
      onPointerUp: (PointerUpEvent event) {
        _initial = 0.0;
        _resumeTimer();
      },
      onPointerMove: (PointerMoveEvent event) {
        double distance = event.position.dx - _initial;
        if (distance.abs() > 50) {
          _isResumeTimer = false;
        }
      },
      onPointerCancel: (PointerCancelEvent event) {
        _initial = 0.0;
        _resumeTimer();
      },
      child: child,
    );
  }

  /// Press your finger to stop the carousel, lift your finger to continue the carousel
  Widget _getListenerWrapper(Widget child) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _clearTimer();
      },
      onPointerUp: (PointerUpEvent event) {
        _resumeTimer();
      },
      onPointerCancel: (PointerCancelEvent event) {
        _resumeTimer();
      },
      child: child,
    );
  }

  /// Press your finger to stop the carousel, but slide the screen to continue the carousel
  // ignore: unused_element
  Widget _getGestureWrapper(Widget child) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        _MultipleGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_MultipleGestureRecognizer>(
                () => _MultipleGestureRecognizer(),
                (_MultipleGestureRecognizer instance) {
          instance.onStart = (_) {};
          instance.onDown = (_) {
            _clearTimer();
          };
          instance.onEnd = (_) {
            _resumeTimer();
          };
          instance.onCancel = () {
            _resumeTimer();
          };
        }),
      },
      child: NotificationListener(
        onNotification: (Notification notification) {
          return false;
        },
        child: child,
      ),
    );
  }
}

class _MultipleGestureRecognizer extends PanGestureRecognizer {}
