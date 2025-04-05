import 'dart:math';

import 'package:flutter/material.dart';

enum AnchoringPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center,
}

class DraggIt extends StatefulWidget {
  const DraggIt({
    required this.child,
    super.key,
    this.initialPosition = AnchoringPosition.bottomRight,
    this.intialVisibility = true,
    this.bottomMargin = 0,
    this.topMargin = 0,
    this.statusBarHeight = 24,
    this.dragController,
    this.dragAnimationScale = 1.1,
    this.touchDelay = Duration.zero,
  })  : assert(statusBarHeight >= 0, ''),
        assert(bottomMargin >= 0, '');

  /// The widget that will be displayed as dragging widget
  final Widget child;

  /// Intial location of the widget, default to [AnchoringPosition.bottomRight]
  final AnchoringPosition initialPosition;

  /// Intially should the widget be visible or not,
  ///  default to (true)
  final bool intialVisibility;

  /// The top bottom pargin to create the bottom boundary for the widget,
  ///  for example if you have a [BottomNavigationBar],
  /// then you may need to set the bottom boundary so that
  /// the draggable button can't get on top of the [BottomNavigationBar]
  final double bottomMargin;

  /// The top bottom pargin to create the top boundary for the widget,
  ///  for example if you have a [AppBar],
  /// then you may need to set the bottom boundary so that
  /// the draggable button can't get on top of the [AppBar]
  final double topMargin;

  /// Status bar's height, default to 24
  final double statusBarHeight;

  /// A drag controller to show/hide or move the widget around the screen
  final DragController? dragController;

  /// How much should the [DraggIt] be scaled when
  /// it is being dragged, default to 1.1
  final double dragAnimationScale;

  /// Touch Delay Duration. Default value is zero. When set,
  ///  drag operations will trigger after the duration.
  final Duration touchDelay;
  @override
  State<DraggIt> createState() => _DraggItState();
}

class _DraggItState extends State<DraggIt> with SingleTickerProviderStateMixin {
  double top = 0;
  double left = 0;
  double boundary = 0;
  late AnimationController animationController;
  late Animation<num> animation;
  double hardLeft = 0;
  double hardTop = 0;
  bool offstage = true;

  AnchoringPosition? currentDocker;

  double widgetHeight = 12;
  double widgetWidth = 12;

  final key = GlobalKey();

  bool dragging = false;

  late AnchoringPosition currentlyDocked;

  bool? visible;

  bool get currentVisibilty => visible ?? widget.intialVisibility;

  bool isStillTouching = false;

  @override
  void initState() {
    currentlyDocked = widget.initialPosition;
    hardTop = widget.topMargin;
    animationController = AnimationController(
      value: 1,
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )
      ..addListener(() {
        if (currentDocker != null) {
          animateWidget(currentDocker!);
        }
      })
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            hardLeft = left;
            hardTop = top;
          }
        },
      );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    widget.dragController?._addState = this;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final widgetSize = getWidgetSize(key);
      if (widgetSize != null) {
        setState(() {
          widgetHeight = widgetSize.height;
          widgetWidth = widgetSize.width;
        });
      }

      await Future<void>.delayed(
        const Duration(
          milliseconds: 100,
        ),
      );
      setState(() {
        offstage = false;
        boundary = MediaQuery.of(context).size.height - widget.bottomMargin;
        if (widget.initialPosition == AnchoringPosition.bottomRight) {
          top = boundary - widgetHeight + widget.statusBarHeight;
          left = MediaQuery.of(context).size.width - widgetWidth;
        } else if (widget.initialPosition == AnchoringPosition.bottomLeft) {
          top = boundary - widgetHeight + widget.statusBarHeight;
          left = 0;
        } else if (widget.initialPosition == AnchoringPosition.topRight) {
          top = widget.topMargin - widget.topMargin;
          left = MediaQuery.of(context).size.width - widgetWidth;
        } else {
          top = widget.topMargin;
          left = 0;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DraggIt oldWidget) {
    if (offstage == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final widgetSize = getWidgetSize(key);
        if (widgetSize != null) {
          setState(() {
            widgetHeight = widgetSize.height;
            widgetWidth = widgetSize.width;
          });
        }
        setState(() {
          boundary = MediaQuery.of(context).size.height - widget.bottomMargin;
          animateWidget(currentlyDocked);
        });
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 150,
        ),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: !currentVisibilty
            ? Container()
            : Listener(
                onPointerUp: (v) {
                  if (!isStillTouching) {
                    return;
                  }
                  isStillTouching = false;

                  final p = v.position;
                  currentDocker = determineDocker(p.dx, p.dy);
                  setState(() {
                    dragging = false;
                  });
                  if (animationController.isAnimating) {
                    animationController.stop();
                  }
                  animationController
                    ..reset()
                    ..forward();
                },
                onPointerDown: (v) async {
                  isStillTouching = false;
                  await Future<void>.delayed(widget.touchDelay);
                  isStillTouching = true;
                },
                onPointerMove: (v) async {
                  if (!isStillTouching) {
                    return;
                  }
                  if (animationController.isAnimating) {
                    animationController
                      ..stop()
                      ..reset();
                  }

                  setState(() {
                    dragging = true;
                    if (v.position.dy < boundary &&
                        v.position.dy > widget.topMargin) {
                      top = max(v.position.dy - widgetHeight / 2, 0);
                    }

                    left = max(v.position.dx - widgetWidth / 2, 0);

                    hardLeft = left;
                    hardTop = top;
                  });
                },
                child: Offstage(
                  offstage: offstage,
                  child: Container(
                    key: key,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      child: Transform.scale(
                        scale: dragging ? widget.dragAnimationScale : 1,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  AnchoringPosition determineDocker(double x, double y) {
    final totalHeight = boundary;
    final totalWidth = MediaQuery.of(context).size.width;

    if (x <= totalWidth / 2 && y <= totalHeight / 2) {
      return AnchoringPosition.topLeft;
    } else if (x < totalWidth / 2 && y > totalHeight / 2) {
      return AnchoringPosition.bottomLeft;
    } else if (x > totalWidth / 2 && y < totalHeight / 2) {
      return AnchoringPosition.topRight;
    } else {
      return AnchoringPosition.bottomRight;
    }
  }

  void animateWidget(AnchoringPosition docker) {
    final totalHeight = boundary;
    final totalWidth = MediaQuery.of(context).size.width;

    switch (docker) {
      case AnchoringPosition.topLeft:
        setState(() {
          left = (1 - animation.value) * hardLeft;
          if (animation.value == 0) {
            top = hardTop;
          } else {
            top = (1 - animation.value) * hardTop +
                (widget.topMargin * (animation.value));
          }

          currentlyDocked = AnchoringPosition.topLeft;
        });

      case AnchoringPosition.topRight:
        final remaingDistanceX = totalWidth - widgetWidth - hardLeft;
        setState(() {
          left = hardLeft + (animation.value) * remaingDistanceX;
          if (animation.value == 0) {
            top = hardTop;
          } else {
            top = (1 - animation.value) * hardTop +
                (widget.topMargin * (animation.value));
          }
          currentlyDocked = AnchoringPosition.topRight;
        });

      case AnchoringPosition.bottomLeft:
        final remaingDistanceY = totalHeight - widgetHeight - hardTop;
        setState(() {
          left = (1 - animation.value) * hardLeft;
          top = hardTop +
              (animation.value) * remaingDistanceY +
              (widget.statusBarHeight * animation.value);
          currentlyDocked = AnchoringPosition.bottomLeft;
        });
      case AnchoringPosition.bottomRight:
        final remaingDistanceX = totalWidth - widgetWidth - hardLeft;
        final remaingDistanceY = totalHeight - widgetHeight - hardTop;
        setState(() {
          left = hardLeft + (animation.value) * remaingDistanceX;
          top = hardTop +
              (animation.value) * remaingDistanceY +
              (widget.statusBarHeight * animation.value);
          currentlyDocked = AnchoringPosition.bottomRight;
        });
      case AnchoringPosition.center:
        final remaingDistanceX =
            (totalWidth / 2 - (widgetWidth / 2)) - hardLeft;
        final remaingDistanceY =
            (totalHeight / 2 - (widgetHeight / 2)) - hardTop;
        // double remaingDistanceX = (totalWidth - widgetWidth - hardLeft) / 2.0;
        // double remaingDistanceY = (totalHeight - widgetHeight - hardTop) / 2.0;
        setState(() {
          left = (animation.value) * remaingDistanceX + hardLeft;
          top = (animation.value) * remaingDistanceY + hardTop;
          currentlyDocked = AnchoringPosition.center;
        });
    }
  }

  Size? getWidgetSize(GlobalKey key) {
    final keyContext = key.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject()! as RenderBox;
      return box.size;
    } else {
      return null;
    }
  }

  void _showWidget() {
    setState(() {
      visible = true;
    });
  }

  void _hideWidget() {
    setState(() {
      visible = false;
    });
  }

  void _animateTo(AnchoringPosition anchoringPosition) {
    if (animationController.isAnimating) {
      animationController.stop();
    }
    animationController.reset();
    currentDocker = anchoringPosition;
    animationController.forward();
  }

  Offset _getCurrentPosition() {
    return Offset(left, top);
  }
}

class DragController {
  _DraggItState? _widgetState;
  // ignore: avoid_setters_without_getters
  set _addState(_DraggItState widgetState) {
    _widgetState = widgetState;
  }

  /// Jump to any [AnchoringPosition] programatically
  void jumpTo(AnchoringPosition anchoringPosition) {
    _widgetState?._animateTo(anchoringPosition);
  }

  /// Get the current screen [Offset] of the widget
  Offset? getCurrentPosition() {
    return _widgetState?._getCurrentPosition();
  }

  /// Makes the widget visible
  void showWidget() {
    _widgetState?._showWidget();
  }

  /// Hide the widget
  void hideWidget() {
    _widgetState?._hideWidget();
  }
}
