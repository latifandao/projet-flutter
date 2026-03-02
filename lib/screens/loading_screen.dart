import 'package:flutter/material.dart';
import 'package:untitled/screens/page_mete.dart';
import 'dart:math';

import 'package:untitled/theme_notifier.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  int _percent = 0;
  int _messageIndex = 0;

  final List<String> _messages = [
    "Nous téléchargeons les données… 📡",
    "C'est presque fini... ⏳",
    "Plus que quelques secondes avant d'avoir le résultat… 🗺️",
  ];

  @override
  void initState() {
    super.initState();
    _startLoading();
    _startMessages();
  }

  Future<void> _startMessages() async {
    while (mounted && _percent < 100) {
      await Future.delayed(const Duration(milliseconds: 2000));
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    }
  }

  Future<void> _startLoading() async {
    for (int i = 10; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      setState(() {
        _percent = i;
      });
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PageMete()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        final backgroundColor =
        isDark ? const Color(0xFF1A1F36) : const Color(0xFFF2F2F7);

        final textColor =
        isDark ? Colors.white : const Color(0xFF1A1F36);

        final messageColor =
        isDark ? Colors.grey[400] : Colors.grey[600];

        final progressColor =
        isDark ? Colors.orangeAccent : Colors.orange;

        final bgCircleColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade200;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _percent / 100),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return CustomPaint(
                            size: const Size(220, 220),
                            painter: _CirclePainter(
                              value,
                              progressColor,
                              bgCircleColor,
                            ),
                          );
                        },
                      ),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: _percent),
                        duration: const Duration(milliseconds: 800),
                        builder: (context, value, child) {
                          return Text(
                            "$value%",
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    _messages[_messageIndex],
                    key: ValueKey(_messageIndex),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      color: messageColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;

  _CirclePainter(this.progress, this.progressColor, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 14.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter old) =>
      old.progress != progress ||
          old.progressColor != progressColor ||
          old.backgroundColor != backgroundColor;
}