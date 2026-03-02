import 'package:flutter/material.dart';
import 'package:untitled/screens/loading_screen.dart';
import 'package:untitled/theme_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _floatController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _floatAnim = Tween<double>(begin: -10, end: 10).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        // Couleurs selon le thème
        final bgColors = isDark
            ? [const Color(0xFF0A0E1A), const Color(0xFF0D1B2A), const Color(0xFF112240)]
            : [const Color(0xFFF0F4FF), const Color(0xFFE8F0FE), const Color(0xFFDCEAFD)];
        final textColor = isDark ? Colors.white : const Color(0xFF1A1F36);
        final subTextColor = isDark ? Colors.white.withOpacity(0.45) : Colors.black.withOpacity(0.45);
        final statDividerColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1);
        final statLabelColor = isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: bgColors,
              ),
            ),
            child: Stack(
              children: [
                // Cercles décoratifs
                Positioned(
                  top: -80, right: -60,
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: Container(
                        width: 280, height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFFFF8C00).withOpacity(isDark ? 0.18 : 0.25),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100, left: -80,
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: 1.1 - (_pulseAnim.value * 0.1),
                      child: Container(
                        width: 220, height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFF1E90FF).withOpacity(isDark ? 0.12 : 0.18),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 50),

                          // Header avec toggle thème
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.5)),
                                  color: const Color(0xFFFF8C00).withOpacity(0.08),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF8C00))),
                                    const SizedBox(width: 8),
                                    const Text("Météo en temps réel", style: TextStyle(color: Color(0xFFFF8C00), fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
                                  ],
                                ),
                              ),
                              // Toggle thème
                              GestureDetector(
                                onTap: () => isDarkModeNotifier.value = !isDark,
                                child: Container(
                                  width: 46, height: 46,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06),
                                    border: Border.all(color: isDark ? Colors.white.withOpacity(0.12) : Colors.black.withOpacity(0.1)),
                                  ),
                                  child: Icon(
                                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                    color: isDark ? Colors.orange : const Color(0xFF1A1F36),
                                    size: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          Text("Votre météo,", style: TextStyle(color: textColor, fontSize: 44, fontWeight: FontWeight.w300, height: 1.1, letterSpacing: -0.5)),
                          const Text("partout.", style: TextStyle(color: Color(0xFFFF8C00), fontSize: 44, fontWeight: FontWeight.bold, height: 1.1, letterSpacing: -0.5)),

                          const SizedBox(height: 16),

                          Text("Prévisions précises dans le monde entier,\nen un instant.", style: TextStyle(color: subTextColor, fontSize: 15, height: 1.6, letterSpacing: 0.2)),

                          const SizedBox(height: 56),

                          // Image flottante
                          Center(
                            child: AnimatedBuilder(
                              animation: _floatAnim,
                              builder: (_, child) => Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseAnim,
                                    builder: (_, __) => Container(
                                      width: 200 * _pulseAnim.value, height: 200 * _pulseAnim.value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(colors: [const Color(0xFFFF8C00).withOpacity(0.2), Colors.transparent]),
                                      ),
                                    ),
                                  ),
                                  Image.asset("assets/images/ns3.png", width: 200, height: 190),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Stats
                          Row(
                            children: [
                              _buildStat("195+", "Pays", textColor, statLabelColor),
                              Container(width: 1, height: 32, color: statDividerColor),
                              _buildStat("24/7", "En direct", textColor, statLabelColor),
                              Container(width: 1, height: 32, color: statDividerColor),
                              _buildStat("99%", "Précision", textColor, statLabelColor),
                            ],
                          ),

                          const SizedBox(height: 36),

                          // Bouton
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadingScreen())),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)]),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8))],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Découvrir maintenant", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.3)),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
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

  Widget _buildStat(String value, String label, Color textColor, Color labelColor) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: labelColor, fontSize: 12)),
        ],
      ),
    );
  }
}