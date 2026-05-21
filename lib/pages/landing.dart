import 'dart:math';
import 'package:flutter/material.dart';
import 'customizations.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _introController;
  late AnimationController _idleController;
  late AnimationController _revealController;

  // Intro Paths
  late Animation<double> _fishX;
  late Animation<double> _fishY;
  late Animation<double> _fishRotation;
  late Animation<double> _wakeOpacity;

  // Reveal Animations
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _buttonFade;
  late Animation<double> _bgOrbFade;

  final List<Offset> _wakePath = [];
  bool _introFinished = false;

  // Ambient Bubble Environmental Tracking Structures
  final List<_AmbientBubble> _ambientBubbles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();

    // 1. Animation Controllers
    _introController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _idleController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );

    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Seed Background Ambient Floating Bubbles
    for (int i = 0; i < 20; i++) {
      _ambientBubbles.add(
        _AmbientBubble(
          initialXPercent: _rng.nextDouble(),
          initialYPercent: _rng.nextDouble(),
          size: _rng.nextDouble() * 12 + 4, // 4px to 16px
          speed: _rng.nextDouble() * 0.07 + 0.04, // Ultra slow layout drifting
          opacity: _rng.nextDouble() * 0.10 + 0.08, // Target styling (0.08 - 0.18)
          driftAmplitude: _rng.nextDouble() * 12 + 4, // Horizontal sway width
        ),
      );
    }

    // 2. Intro Sequences (Swims across, loops back elegantly into the text layout gap)
    _fishX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -0.3, end: 1.2).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 0.5).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 40,
      ),
    ]).animate(_introController);

    _fishY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.3, end: 0.6).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.6, end: 0.22).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.22, end: 0.39).chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 30,
      ),
    ]).animate(_introController);

    _fishRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.2, end: -0.4).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -0.4, end: -2.8).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -2.8, end: -3.14).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
    ]).animate(_introController);

    _wakeOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.8), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.8), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 0.0), weight: 30),
    ]).animate(_introController);

    // 3. UI Elements Reveal
    _bgOrbFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.2, 0.6, curve: Curves.easeOut)),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.2, 0.65, curve: Curves.easeOut)),
    );
    _subtitleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.5, 0.9, curve: Curves.easeOut)),
    );
    _buttonFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: const Interval(0.65, 1.0, curve: Curves.easeOut)),
    );

    // 4. Trail Performance Engine
    _introController.addListener(() {
      if (_introFinished) return;
      final size = MediaQuery.sizeOf(context);
      final currentPos = Offset(_fishX.value * size.width, _fishY.value * size.height);
      
      if (mounted) {
        setState(() {
          _wakePath.add(currentPos);
          if (_wakePath.length > 50) { 
            _wakePath.removeAt(0);
          }
        });
      }
    });

    // Run Choreography Sequence
    _introController.forward().then((_) {
      if (mounted) {
        setState(() {
          _introFinished = true;
          _wakePath.clear();
        });
        _idleController.repeat();
        _revealController.forward();
      }
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _idleController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  Future<void> _startApp(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CustomizationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmall = size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFDDE4EE),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_introController, _idleController]),
            builder: (context, _) {
              final double timeClock = _introFinished 
                  ? 2.2 + (_idleController.value * 6.0) 
                  : _introController.value * 2.2;
              return CustomPaint(
                size: size,
                painter: _AmbientBubblePainter(
                  bubbles: _ambientBubbles,
                  timeSeconds: timeClock,
                ),
              );
            },
          ),

          FadeTransition(
            opacity: _bgOrbFade,
            child: Stack(
              children: [
                Positioned(
                  top: -size.height * 0.05,
                  right: -size.width * 0.1,
                  child: Container(
                    width: size.width * (isSmall ? 0.75 : 0.45),
                    height: size.width * (isSmall ? 0.75 : 0.45),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC3D4F0).withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: size.height * 0.05,
                  left: -size.width * 0.15,
                  child: Container(
                    width: size.width * (isSmall ? 0.6 : 0.35),
                    height: size.width * (isSmall ? 0.6 : 0.35),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFC8D6).withOpacity(0.35),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!_introFinished)
            CustomPaint(
              size: size,
              painter: _WakePainter(
                path: List.from(_wakePath),
                opacity: _wakeOpacity.value,
              ),
            ),

          SafeArea(
            child: SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 24.0 : 48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 5),

                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Welcome to',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF6C80A4),
                                fontSize: isSmall ? 20 : 24,
                                fontFamily: 'Outfit',
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                           Text(
                              'FINS',
                              style: GoogleFonts.leckerliOne(
                                textStyle: TextStyle(
                                  color: const Color(0xFF1E2A3A),
                                  fontSize: isSmall ? 82 : 96,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2,
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Fixed space reservation block for the middle fish placement gap
                    SizedBox(height: isSmall ? 100 : 120),

                    FadeTransition(
                      opacity: _subtitleFade,
                      child: Text(
                        'financial clarity, one ripple at a time',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF8A9BB5),
                          fontSize: isSmall ? 14 : 16,
                          fontFamily: 'Outfit',
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const Spacer(flex: 5),

                    FadeTransition(
                      opacity: _buttonFade,
                      child: _MobileTouchButton(
                        onPressed: () => _startApp(context),
                        isSmallScreen: isSmall,
                        idleController: _idleController, // Added link to drive fluid button waves
                      ),
                    ),

                    SizedBox(height: isSmall ? 48 : 64),
                  ],
                ),
              ),
            ),
          ),

          // ── Dynamic Floating Goldfish Component (Layered over layout) ──
          AnimatedBuilder(
            animation: Listenable.merge([_introController, _idleController]),
            builder: (context, child) {
              double xPos, yPos, rotation;

              if (!_introFinished) {
                xPos = _fishX.value * size.width - 60;
                yPos = _fishY.value * size.height - 48;
                rotation = _fishRotation.value;
              } else {
                // Natural idle organic cycle patterns
                final t = _idleController.value * 2 * pi;
                final idleX = sin(t) * 20.0;
                final idleY = sin(2 * t) * 10.0;
                
                xPos = (size.width * 0.5) - 60 + idleX;
                yPos = (size.height * 0.46) - 48 + idleY; 
                
                // Facing upright and forward naturally with horizontal momentum tilt
                rotation = 0.0 + (cos(t) * 0.12);
              }

              final fishVisualSize = isSmall ? 110.0 : 130.0;

              return Positioned(
                left: xPos - (fishVisualSize * 0.25),
                top: yPos - (fishVisualSize * 0.25),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // ── Soft Glowing Backing Halo Layer ──
                    Container(
                      width: fishVisualSize * 1.5,
                      height: fishVisualSize * 1.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFE8BC55).withOpacity(0.22),
                            const Color(0xFFDDE4EE).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    // Main Transformed Goldfish Graphic
                    Transform.rotate(
                      angle: rotation,
                      child: child,
                    ),
                  ],
                ),
              );
            },
            child: _GoldFish(size: isSmall ? 110 : 130),
          ),
        ],
      ),
    );
  }
}

class _AmbientBubble {
  final double initialXPercent;
  final double initialYPercent;
  final double size;
  final double speed;
  final double opacity;
  final double driftAmplitude;

  const _AmbientBubble({
    required this.initialXPercent,
    required this.initialYPercent,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.driftAmplitude,
  });
}

class _AmbientBubblePainter extends CustomPainter {
  final List<_AmbientBubble> bubbles;
  final double timeSeconds;

  const _AmbientBubblePainter({required this.bubbles, required this.timeSeconds});

  @override
  void paint(Canvas canvas, Size size) {
    final bubblePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFFFFF);

    for (final bubble in bubbles) {
      // Calculate layout upward offset vectors
      double currentY = size.height * bubble.initialYPercent - (timeSeconds * bubble.speed * 85);
      
      // Loop resetting bounds calculations
      if (currentY < -20) {
        final double standardLoops = (currentY / (size.height + 40)).floorToDouble();
        currentY = currentY - (standardLoops * (size.height + 40));
      }
      currentY = currentY % (size.height + 40) - 20;

      // Gentle horizontal swaying path mapping
      final double driftX = sin(timeSeconds * 0.75 + (bubble.initialYPercent * 100)) * bubble.driftAmplitude;
      final double currentX = (size.width * bubble.initialXPercent + driftX) % size.width;

      bubblePaint.color = const Color(0xFFFFFFFF).withOpacity(bubble.opacity);
      canvas.drawCircle(Offset(currentX, currentY), bubble.size / 2, bubblePaint);
    }
  }

  @override
  bool shouldRepaint(_AmbientBubblePainter oldDelegate) =>
      oldDelegate.timeSeconds != timeSeconds;
}

class _WakePainter extends CustomPainter {
  final List<Offset> path;
  final double opacity;

  const _WakePainter({required this.path, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    if (path.length < 2 || opacity <= 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 1; i < path.length; i++) {
      final t = i / path.length;
      final alpha = (t * opacity * 0.45).clamp(0.0, 1.0);
      final width = (t * 5).clamp(1.0, 5.0);

      paint
        ..color = const Color(0xFF6C80A4).withOpacity(alpha)
        ..strokeWidth = width;

      canvas.drawLine(path[i - 1], path[i], paint);
    }

    final bubblePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF8A9BB5).withOpacity(opacity * 0.25);

    final rng = Random(42);
    final take = (path.length * 0.5).toInt();
    for (int i = 0; i < take; i += 6) {
      final p = path[i];
      final r = rng.nextDouble() * 2.5 + 1;
      final dx = (rng.nextDouble() - 0.5) * 16;
      final dy = (rng.nextDouble() - 0.5) * 16;
      canvas.drawCircle(Offset(p.dx + dx, p.dy + dy), r, bubblePaint);
    }
  }

  @override
  bool shouldRepaint(_WakePainter old) =>
      old.path.length != path.length || old.opacity != opacity;
}

class _GoldFish extends StatelessWidget {
  final double size;
  const _GoldFish({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.9,
      child: CustomPaint(painter: const _GoldFishPainter()),
    );
  }
}

class _GoldFishPainter extends CustomPainter {
  const _GoldFishPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..style = PaintingStyle.fill;
    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFC8941F).withOpacity(0.35);

    // Tail fins
    bodyPaint.color = const Color(0xFFD4A843);
    final tailPath = Path()
      ..moveTo(w * 0.22, h * 0.5)
      ..cubicTo(w * 0.02, h * 0.28, w * 0.0, h * 0.08, w * 0.1, h * 0.0)
      ..cubicTo(w * 0.14, h * 0.3, w * 0.18, h * 0.42, w * 0.22, h * 0.5);
    canvas.drawPath(tailPath, bodyPaint);

    final tailPath2 = Path()
      ..moveTo(w * 0.22, h * 0.5)
      ..cubicTo(w * 0.02, h * 0.72, w * 0.0, h * 0.92, w * 0.1, h * 1.0)
      ..cubicTo(w * 0.14, h * 0.7, w * 0.18, h * 0.58, w * 0.22, h * 0.5);
    canvas.drawPath(tailPath2, bodyPaint);

    // Dorsal fin
    final dorsalPath = Path()
      ..moveTo(w * 0.38, h * 0.26)
      ..cubicTo(w * 0.5, h * 0.04, w * 0.68, h * 0.0, w * 0.72, h * 0.22)
      ..cubicTo(w * 0.62, h * 0.22, w * 0.48, h * 0.24, w * 0.38, h * 0.26);
    canvas.drawPath(dorsalPath, bodyPaint);

    // Main body
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.58, h * 0.52), width: w * 0.72, height: h * 0.58),
      bodyPaint,
    );
    bodyPaint.color = const Color(0xFFE8BC55);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.58, h * 0.52), width: w * 0.64, height: h * 0.5),
      bodyPaint,
    );

    // Highlight
    bodyPaint.color = const Color(0xFFEFC96A).withOpacity(0.45);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.55, h * 0.44), width: w * 0.38, height: h * 0.28),
      bodyPaint,
    );

    // Scale details
    for (final (cx, cy, rx, ry) in const [
      (0.48, 0.48, 0.07, 0.05),
      (0.58, 0.42, 0.07, 0.05),
      (0.52, 0.58, 0.07, 0.05),
      (0.64, 0.55, 0.06, 0.04),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * cx, h * cy), width: w * rx * 2, height: h * ry * 2),
        shadowPaint,
      );
    }

    // Pectoral fins
    bodyPaint.color = const Color(0xFFD4A843);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.48, h * 0.72), width: w * 0.16, height: h * 0.1),
      bodyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.58, h * 0.78), width: w * 0.14, height: h * 0.08),
      bodyPaint,
    );

    // Eyes
    bodyPaint.color = Colors.white;
    canvas.drawCircle(Offset(w * 0.8, h * 0.42), w * 0.082, bodyPaint);
    bodyPaint.color = const Color(0xFF1E2A3A);
    canvas.drawCircle(Offset(w * 0.8, h * 0.42), w * 0.055, bodyPaint);
    bodyPaint.color = Colors.white;
    canvas.drawCircle(Offset(w * 0.82, h * 0.39), w * 0.022, bodyPaint);

    // Mouth
    final mouthPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFC8941F).withOpacity(0.6);
    final mouthPath = Path()
      ..moveTo(w * 0.9, h * 0.5)
      ..quadraticBezierTo(w * 0.93, h * 0.53, w * 0.9, h * 0.56);
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant _GoldFishPainter oldDelegate) => false;
}

class _MobileTouchButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSmallScreen;
  final AnimationController idleController;

  const _MobileTouchButton({
    required this.onPressed,
    required this.isSmallScreen,
    required this.idleController,
  });

  @override
  State<_MobileTouchButton> createState() => _MobileTouchButtonState();
}

class _MobileTouchButtonState extends State<_MobileTouchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _touchController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _touchController = AnimationController(
      duration: const Duration(milliseconds: 120),
      value: 1.0, 
      lowerBound: 0.94, 
      upperBound: 1.0,
      vsync: this,
    );
    _scaleAnimation = _touchController;
  }

  @override
  void dispose() {
    _touchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  
    final fluidFinRadius = BorderRadius.only(
      topLeft: Radius.circular(widget.isSmallScreen ? 24 : 32),
      bottomRight: Radius.circular(widget.isSmallScreen ? 24 : 32),
      topRight: Radius.circular(widget.isSmallScreen ? 10 : 12),
      bottomLeft: Radius.circular(widget.isSmallScreen ? 10 : 12),
    );

    return GestureDetector(
      onTapDown: (_) => _touchController.animateTo(0.94, curve: Curves.easeInOut),
      onTapUp: (_) {
        _touchController.animateTo(1.0, curve: Curves.easeOut);
        widget.onPressed();
      },
      onTapCancel: () => _touchController.animateTo(1.0, curve: Curves.easeOut),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedBuilder(
          animation: widget.idleController,
          builder: (context, child) {
            // Pulse parameters synced to environmental background loops
            final pulseVal = sin(widget.idleController.value * 2 * pi);
            final glowBlur = 8.0 + (pulseVal * 4.0);
            final glowSpread = pulseVal > 0 ? pulseVal * 2.0 : 0.0;
            final dynamicOpacity = 0.12 + (pulseVal * 0.05);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A3A),
                borderRadius: fluidFinRadius,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E2A3A).withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                  // Breathing Tide Ring Shadow Layer
                  BoxShadow(
                    color: const Color(0xFF6C80A4).withOpacity(dynamicOpacity.clamp(0.0, 1.0)),
                    blurRadius: glowBlur,
                    spreadRadius: glowSpread,
                  ),
                ],
              ),
              child: child,
            );
          },
          child: Text(
            'Get Started',
            style: TextStyle(
              fontSize: widget.isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
              letterSpacing: 0.8,
              color: const Color(0xFFDDE4EE),
            ),
          ),
        ),
      ),
    );
  }
}