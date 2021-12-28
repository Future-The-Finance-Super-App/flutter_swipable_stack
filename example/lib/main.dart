import 'dart:math';

import 'package:example/card_label.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';

class SwipeDirectionColor {
  static const right = Color.fromRGBO(70, 195, 120, 1);
  static const left = Color.fromRGBO(220, 90, 108, 1);
  static const up = Color.fromRGBO(83, 170, 232, 1);
  static const down = Color.fromRGBO(154, 85, 215, 1);
}

extension SwipeDirecionX on SwipeDirection {
  Color get color {
    switch (this) {
      case SwipeDirection.right:
        return Color.fromRGBO(70, 195, 120, 1);
      case SwipeDirection.left:
        return Color.fromRGBO(220, 90, 108, 1);
      case SwipeDirection.up:
        return Color.fromRGBO(83, 170, 232, 1);
      case SwipeDirection.down:
        return Color.fromRGBO(154, 85, 215, 1);
    }
  }
}

const _images = [
  'images/image_5.jpg',
  'images/image_3.jpg',
  'images/image_4.jpg',
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final SwipableStackController _controller;

  void _listenController() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = SwipableStackController()..addListener(_listenController);
  }

  static const double _bottomAreaHeight = 100;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwipableStack(
                  controller: _controller,
                  stackClipBehaviour: Clip.none,
                  onSwipeCompleted: (index, direction) {
                    print('$index, $direction');
                  },
                  horizontalSwipeThreshold: 0.8,
                  verticalSwipeThreshold: 0.8,
                  overlayBuilder: (
                    context,
                    constraints,
                    index,
                    direction,
                    swipeProgress,
                  ) {
                    final opacity = min(swipeProgress, 1.0);

                    final isRight = direction == SwipeDirection.right;
                    final isLeft = direction == SwipeDirection.left;
                    final isUp = direction == SwipeDirection.up;
                    final isDown = direction == SwipeDirection.down;
                    return Stack(
                      children: [
                        Opacity(
                          opacity: isRight ? opacity : 0,
                          child: CardLabel.right(),
                        ),
                        Opacity(
                          opacity: isLeft ? opacity : 0,
                          child: CardLabel.left(),
                        ),
                        Opacity(
                          opacity: isUp ? opacity : 0,
                          child: CardLabel.up(),
                        ),
                        Opacity(
                          opacity: isDown ? opacity : 0,
                          child: CardLabel.down(),
                        ),
                      ],
                    );
                  },
                  builder: (context, index, constraints) {
                    final itemIndex = index % _images.length;
                    final imagePath = _images[itemIndex];
                    return ClipRRect(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                image: DecorationImage(
                                  image: AssetImage(imagePath),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 2),
                                    blurRadius: 26,
                                    color: Colors.black.withOpacity(0.08),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(14),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    Colors.black12.withOpacity(0),
                                    Colors.black12.withOpacity(.4),
                                    Colors.black12.withOpacity(.82),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sample No.${itemIndex + 1}',
                                  style: theme.textTheme.headline6!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: _bottomAreaHeight)
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: _bottomAreaHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _BottomButton(
                        color: _controller.canRewind
                            ? Colors.amberAccent
                            : Colors.grey,
                        child: const Icon(Icons.refresh),
                        onPressed:
                            _controller.canRewind ? _controller.rewind : null,
                      ),
                      _BottomButton(
                        color: SwipeDirectionColor.left,
                        child: const Icon(Icons.arrow_back),
                        onPressed: () {
                          _controller.next(
                            swipeDirection: SwipeDirection.left,
                          );
                        },
                      ),
                      _BottomButton(
                        color: SwipeDirectionColor.up,
                        onPressed: () {
                          _controller.next(
                            swipeDirection: SwipeDirection.up,
                          );
                        },
                        child: const Icon(Icons.arrow_upward),
                      ),
                      _BottomButton(
                        color: SwipeDirectionColor.right,
                        onPressed: () {
                          _controller.next(
                            swipeDirection: SwipeDirection.right,
                          );
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                      _BottomButton(
                        color: SwipeDirectionColor.down,
                        onPressed: () {
                          _controller.next(
                            swipeDirection: SwipeDirection.down,
                          );
                        },
                        child: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_listenController);
    _controller.dispose();
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.onPressed,
    required this.child,
    required this.color,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Icon child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 64,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.resolveWith(
            (states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => color,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
