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

class JumpingTextState extends State<JumpingText>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Color> _colors; // List to store colors for each character
  late Timer _colorTimer; // Timer to change colors
  final Random _random = Random(); // Random number generator

  // Function to generate a random color
  Color _getRandomColor() {
    return Color.fromARGB(
      255, // Fully opaque
      _random.nextInt(256), // Random red
      _random.nextInt(256), // Random green
      _random.nextInt(256), // Random blue
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize colors with random values
    _colors = List.generate(widget.text.length, (_) => _getRandomColor());
    _controllers = List.generate(widget.text.length, (index) {
      return AnimationController(vsync: this, duration: widget.duration);
    });

    _animations = List.generate(widget.text.length, (index) {
      // Create a curved animation for smoother jump
      final curvedAnimation = CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.easeInOut, // Use easeInOut for smooth start and end
      );

      // Use TweenSequence for up and down motion
      return TweenSequence<double>([
        // Jump up (takes 50% of duration)
        TweenSequenceItem(
          tween: Tween(
            begin: 0.0,
            end: -widget.jumpHeight,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        // Fall down (takes 50% of duration)
        TweenSequenceItem(
          tween: Tween(
            begin: -widget.jumpHeight,
            end: 0.0,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(curvedAnimation);
    });

    // Start animations with a stagger delay
    for (int i = 0; i < widget.text.length; i++) {
      Future.delayed(widget.staggerDelay * i, () {
        if (mounted) {
          // Check if widget is still mounted before starting animation
          _controllers[i].repeat(reverse: false); // Loop the animation
        }
      });
    }

    // Start timer to change colors periodically (e.g., every 500ms)
    _colorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _colors = List.generate(widget.text.length, (_) => _getRandomColor());
        });
      } else {
        timer.cancel(); // Cancel timer if widget is disposed
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _colorTimer.cancel(); // Cancel the color timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the theme's titleLarge style as a base if no style is provided
    final defaultStyle =
        Theme.of(context).textTheme.titleLarge ?? const TextStyle(fontSize: 22);
    final effectiveStyle = widget.style ?? defaultStyle;

    return Row(
      mainAxisSize: MainAxisSize.min, // Take minimum space needed by characters
      children: List.generate(widget.text.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: child,
            );
          },
          child: Text(
            widget.text[index],
            // Apply the current color and merge with the provided/default style
            style: effectiveStyle.copyWith(color: _colors[index]),
          ),
        );
      }),
    );
  }
}
