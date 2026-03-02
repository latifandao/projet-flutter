import 'package:flutter/material.dart';
import 'package:untitled/screens/loading_screen.dart';
import 'package:untitled/screens/ville_detail_screen.dart';
import 'package:untitled/services/weather_service.dart';
import 'package:untitled/models/weather_model.dart';
import 'package:untitled/screens/home_screen.dart';
import 'package:untitled/theme_notifier.dart';

class PageMete extends StatefulWidget {
  const PageMete({super.key});

  @override
  State<PageMete> createState() => _PageMeteState();
}

class _PageMeteState extends State<PageMete> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnim;
  late Animation<double> _pulseAnim;

  final WeatherService _service = WeatherService();

  final List<Map<String, dynamic>> _villes = [
    {"name": "Dakar", "icon": Icons.home_work_outlined, "emoji": "🌅"},
    {"name": "Pointe-Noire, Congo", "icon": Icons.add_business_outlined, "emoji": "🌊"},
    {"name": "Banjul", "icon": Icons.language_outlined, "emoji": "🌍"},
    {"name": "Ouagadougou", "icon": Icons.business_outlined, "emoji": "🏙️"},
  ];

  Map<String, WeatherModel?> _weatherData = {};
  Map<String, bool> _loadingMap = {};
  Map<String, String?> _errorMap = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _fetchAllWeather();
  }

  Future<void> _fetchAllWeather() async {
    for (var ville in _villes) {
      final name = ville["name"] as String;
      setState(() { _loadingMap[name] = true; _errorMap[name] = null; });
      _service.getWeather(name).then((weather) {
        if (!mounted) return;
        setState(() { _weatherData[name] = weather; _loadingMap[name] = false; });
      }).catchError((e) {
        if (!mounted) return;
        setState(() { _errorMap[name] = "Erreur"; _loadingMap[name] = false; });
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _tempColor(double temp) {
    if (temp >= 35) return const Color(0xFFFF4500);
    if (temp >= 28) return const Color(0xFFFF8C00);
    if (temp >= 20) return const Color(0xFFFFD700);
    if (temp >= 10) return const Color(0xFF00BFFF);
    return const Color(0xFF1E90FF);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        final bgColors = isDark
            ? [const Color(0xFF0A0E1A), const Color(0xFF0D1B2A), const Color(0xFF112240)]
            : [const Color(0xFFF0F4FF), const Color(0xFFE8F0FE), const Color(0xFFDCEAFD)];
        final textColor = isDark ? Colors.white : const Color(0xFF1A1F36);
        final subTextColor = isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4);
        final cardColor = isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.85);
        final cardBorder = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);
        final iconColor = isDark ? Colors.white : const Color(0xFF1A1F36);
        final btnBg = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06);
        final btnBorder = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1);

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: bgColors),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -60, right: -40,
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, __) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: Container(
                        width: 240, height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(colors: [
                            const Color(0xFFFF8C00).withOpacity(isDark ? 0.12 : 0.2),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Row(
                            children: [
                              // Retour
                              GestureDetector(
                                onTap: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                                  }
                                },
                                child: Container(
                                  width: 42, height: 42,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: btnBg, border: Border.all(color: btnBorder)),
                                  child: Icon(Icons.arrow_back_ios_rounded, color: iconColor, size: 16),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Mes villes", style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
                                  Text("${_villes.length} destinations", style: TextStyle(color: subTextColor, fontSize: 13)),
                                ],
                              ),
                              const Spacer(),
                              // Toggle thème
                              GestureDetector(
                                onTap: () => isDarkModeNotifier.value = !isDark,
                                child: Container(
                                  width: 42, height: 42,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: btnBg, border: Border.all(color: btnBorder)),
                                  child: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: isDark ? Colors.orange : const Color(0xFF1A1F36), size: 18),
                                ),
                              ),
                              // Refresh
                              GestureDetector(
                                onTap: _fetchAllWeather,
                                child: Container(
                                  width: 42, height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: const Color(0xFFFF8C00).withOpacity(0.12),
                                    border: Border.all(color: const Color(0xFFFF8C00).withOpacity(0.3)),
                                  ),
                                  child: const Icon(Icons.refresh_rounded, color: Color(0xFFFF8C00), size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Liste
                        Expanded(
                          child: RefreshIndicator(
                            color: const Color(0xFFFF8C00),
                            backgroundColor: isDark ? const Color(0xFF0D1B2A) : Colors.white,
                            onRefresh: _fetchAllWeather,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: _villes.length,
                              itemBuilder: (context, index) {
                                final ville = _villes[index];
                                final name = ville["name"] as String;
                                final emoji = ville["emoji"] as String;
                                return TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: Duration(milliseconds: 400 + (index * 100)),
                                  curve: Curves.easeOut,
                                  builder: (_, value, child) => Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)),
                                    child: Opacity(opacity: value, child: child),
                                  ),
                                  child: _buildCityCard(name, emoji, isDark, textColor, subTextColor, cardColor, cardBorder),
                                );
                              },
                            ),
                          ),
                        ),

                        // Bouton Recommencer
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => const LoadingScreen()),
                                    (route) => false,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF6B00)]),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [BoxShadow(color: const Color(0xFFFF8C00).withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.replay_rounded, color: Colors.white, size: 18),
                                  SizedBox(width: 10),
                                  Text("Recommencer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.2)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildCityCard(String ville, String emoji, bool isDark, Color textColor, Color subTextColor, Color cardColor, Color cardBorder) {
    final bool isLoading = _loadingMap[ville] ?? true;
    final String? error = _errorMap[ville];
    final WeatherModel? weather = _weatherData[ville];

    return GestureDetector(
      onTap: () {
        if (!isLoading && weather != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => VilleDetailScreen(cityName: ville)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cardColor,
          border: Border.all(color: cardBorder),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.2 : 0.06), blurRadius: 20, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.04),
                border: Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08)),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ville, style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.2)),
                  const SizedBox(height: 3),
                  Text(
                    isLoading ? "Chargement..." : error != null ? "Données indisponibles" : weather?.cityName ?? "",
                    style: TextStyle(color: subTextColor, fontSize: 12),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isLoading)
              SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: const Color(0xFFFF8C00).withOpacity(0.7), strokeWidth: 2))
            else if (error != null)
              GestureDetector(
                onTap: () async {
                  setState(() { _loadingMap[ville] = true; _errorMap[ville] = null; });
                  try {
                    final w = await _service.getWeather(ville);
                    if (!mounted) return;
                    setState(() { _weatherData[ville] = w; _loadingMap[ville] = false; });
                  } catch (e) {
                    if (!mounted) return;
                    setState(() { _errorMap[ville] = "Erreur"; _loadingMap[ville] = false; });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red.withOpacity(0.12)),
                  child: const Icon(Icons.refresh_rounded, color: Colors.redAccent, size: 18),
                ),
              )
            else if (weather != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _tempColor(weather.temperature).withOpacity(0.12),
                    border: Border.all(color: _tempColor(weather.temperature).withOpacity(0.3)),
                  ),
                  child: Text("${weather.temperature.toStringAsFixed(0)}°",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _tempColor(weather.temperature))),
                ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded, color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2), size: 20),
          ],
        ),
      ),
    );
  }
}