import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // Import Random

class JumpingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final double jumpHeight;
  final Duration duration;
  final Duration
  staggerDelay; // Delay between each character starting animation

  const JumpingText({
    super.key,
    required this.text,
    this.style,
    this.jumpHeight = 10.0, // Default jump height
    this.duration = const Duration(
      milliseconds: 800,
    ), // Duration for one up/down cycle
    this.staggerDelay = const Duration(
      milliseconds: 100,
    ), // Delay between characters
  });

  @override
  JumpingTextState createState() => JumpingTextState();
}

class JumpingTextState extends State<JumpingText> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;
  late final List<ValueNotifier<Color>> _colorNotifiers;
  late final Timer _colorTimer;
  final Random _random = Random();

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    );
  }

  @override
  void initState() {
    super.initState();

    // Total duration for one sequence of all characters animating
    final totalDuration =
        widget.duration + widget.staggerDelay * (widget.text.length - 1);

    _controller = AnimationController(vsync: this, duration: totalDuration)
      ..repeat();

    _animations = List.generate(widget.text.length, (index) {
      final startTime = (widget.staggerDelay * index).inMilliseconds;
      final endTime = startTime + widget.duration.inMilliseconds;
      final start = startTime / totalDuration.inMilliseconds;
      final end = endTime / totalDuration.inMilliseconds;

      // Tween for the up and down motion
      final tween = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -widget.jumpHeight)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(begin: -widget.jumpHeight, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]);

      // Apply the interval to the main controller
      return tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    // Initialize color notifiers
    _colorNotifiers = List.generate(
      widget.text.length,
      (_) => ValueNotifier<Color>(_getRandomColor()),
    );

    // Timer to update colors. This is more efficient than calling setState.
    _colorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      for (final notifier in _colorNotifiers) {
        notifier.value = _getRandomColor();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorTimer.cancel();
    for (final notifier in _colorNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        Theme.of(context).textTheme.titleLarge ?? const TextStyle(fontSize: 22);
    final effectiveStyle = widget.style ?? defaultStyle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: child,
            );
          },
          child: ValueListenableBuilder<Color>(
            valueListenable: _colorNotifiers[index],
            builder: (context, color, _) {
              return Text(
                widget.text[index],
                style: effectiveStyle.copyWith(color: color),
              );
            },
          ),
        );
      }),
    );
  }
}
