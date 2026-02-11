import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ValentineHome(),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>
    with SingleTickerProviderStateMixin {
  String selectedEmoji = 'Sweet Heart';
  bool showBalloons = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool isPulsing = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌸 Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFFFFE4EC), Color(0xFFE91E63)],
                center: Alignment.center,
                radius: 1.2,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // 💖 Toggle Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildToggle('Sweet Heart 💖'),
                      const SizedBox(width: 20),
                      _buildToggle('Party Heart 🥳'),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // 💌 Asset Image
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/love_letter.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ❤️ Pulsing Heart
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: CustomPaint(
                      size: const Size(300, 300),
                      painter:
                          HeartEmojiPainter(type: selectedEmoji),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 💓 Pulse Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() => isPulsing = !isPulsing);

                      if (isPulsing) {
                        _pulseController.repeat(reverse: true);
                      } else {
                        _pulseController.stop();
                        _pulseController.value = 0;
                      }
                    },
                    child: Text(
                        isPulsing ? "Stop Pulse 💓" : "Pulse 💓"),
                  ),

                  const SizedBox(height: 15),

                  // 🎉 Celebrate Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() => showBalloons = true);
                      Future.delayed(
                          const Duration(seconds: 3), () {
                        setState(() => showBalloons = false);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple),
                    child: const Text("Celebrate 🎉"),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          if (showBalloons) const BalloonOverlay(),
        ],
      ),
    );
  }

  Widget _buildToggle(String label) {
    final bool isSelected =
        selectedEmoji ==
            label.replaceAll(' 💖', '').replaceAll(' 🥳', '');

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmoji =
              label.contains('Sweet')
                  ? 'Sweet Heart'
                  : 'Party Heart';
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white : Colors.white70,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }
}

class HeartEmojiPainter extends CustomPainter {
  final String type;
  HeartEmojiPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final center =
        Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF4081),
          Color(0xFFE91E63)
        ],
      ).createShader(
          Rect.fromLTWH(0, 0, size.width, size.height));

    final heartPath = Path()
      ..moveTo(center.dx, center.dy + 60)
      ..cubicTo(center.dx + 110, center.dy - 10,
          center.dx + 60, center.dy - 120,
          center.dx, center.dy - 40)
      ..cubicTo(center.dx - 60, center.dy - 120,
          center.dx - 110, center.dy - 10,
          center.dx, center.dy + 60)
      ..close();

    canvas.drawPath(heartPath, paint);

    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
        Offset(center.dx - 30, center.dy - 10),
        10,
        eyePaint);
    canvas.drawCircle(
        Offset(center.dx + 30, center.dy - 10),
        10,
        eyePaint);

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawArc(
        Rect.fromCircle(
            center:
                Offset(center.dx, center.dy + 20),
            radius: 30),
        0,
        pi,
        false,
        mouthPaint);

    if (type == 'Party Heart') {
      final random = Random();
      final confettiPaint = Paint();

      for (int i = 0; i < 20; i++) {
        confettiPaint.color = Colors.primaries[
            random.nextInt(
                Colors.primaries.length)];
        canvas.drawCircle(
          Offset(random.nextDouble() * size.width,
              random.nextDouble() * size.height),
          4,
          confettiPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
          covariant HeartEmojiPainter oldDelegate) =>
      true;
}

class BalloonOverlay extends StatefulWidget {
  const BalloonOverlay({super.key});

  @override
  State<BalloonOverlay> createState() =>
      _BalloonOverlayState();
}

class _BalloonOverlayState extends State<BalloonOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BalloonPainter(controller.value),
          size: MediaQuery.of(context).size,
        );
      },
    );
  }
}

class BalloonPainter extends CustomPainter {
  final double progress;
  BalloonPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ];

    final paint = Paint();

    for (int i = 0; i < 8; i++) {
      paint.color = colors[i % colors.length];

      double x = (size.width / 8) * i + 30;
      double y = size.height * progress;

      canvas.drawCircle(Offset(x, y), 25, paint);

      canvas.drawLine(
        Offset(x, y + 25),
        Offset(x, y + 70),
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(
          covariant BalloonPainter oldDelegate) =>
      true;
}
