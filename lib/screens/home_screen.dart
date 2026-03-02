import 'package:flutter/material.dart';
import 'package:untitled/screens/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {

  bool _isDarkMode = true; // 👈 AJOUT

  late AnimationController _pulseController;
  late AnimationController _floatController;
  late AnimationController _fadeController;

  late Animation<double> _pulseAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _pulseController =
    AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);

    _floatController =
    AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);

    _fadeController =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();

    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
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

    // 🎨 Couleurs dynamiques
    final bgGradient = _isDarkMode
        ? const [
      Color(0xFF0A0E1A),
      Color(0xFF0D1B2A),
      Color(0xFF112240),
    ]
        : const [
      Color(0xFFFDFBFB),
      Color(0xFFEDEDED),
      Color(0xFFE0E0E0),
    ];

    final mainTextColor =
    _isDarkMode ? Colors.white : Colors.black87;

    final subTextColor =
    _isDarkMode ? Colors.white.withOpacity(0.45) : Colors.black54;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bgGradient,
          ),
        ),
        child: Stack(
          children: [

            /// 🌙 BOUTON MODE SOMBRE / CLAIR
            Positioned(
              top: 50,
              right: 20,
              child: IconButton(
                icon: Icon(
                  _isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: const Color(0xFFFF8C00),
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
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

                      const SizedBox(height: 80),

                      const SizedBox(height: 32),

                      Text(
                        "Votre météo,",
                        style: TextStyle(
                          color: mainTextColor,
                          fontSize: 44,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const Text(
                        "partout.",
                        style: TextStyle(
                          color: Color(0xFFFF8C00),
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Prévisions précises dans le monde entier,\nen un instant.",
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 56),

                      Center(
                        child: AnimatedBuilder(
                          animation: _floatAnim,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, _floatAnim.value),
                            child: child,
                          ),
                          child: Image.asset(
                            "assets/images/ns3.png",
                            width: 200,
                            height: 190,
                          ),
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const LoadingScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF8C00),
                                Color(0xFFFF6B00),
                              ],
                            ),
                            borderRadius:
                            BorderRadius.circular(18),
                          ),
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                "Découvrir maintenant",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white),
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
  }
}