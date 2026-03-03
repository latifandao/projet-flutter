import 'package:flutter/material.dart';
import 'package:untitled/screens/loading_screen.dart';
import 'package:untitled/screens/ville_detail_screen.dart';
import 'package:untitled/services/weather_service.dart';
import 'package:untitled/models/weather_model.dart';

class PageMete extends StatefulWidget {
  const PageMete({super.key});

  @override
  State<PageMete> createState() => _PageMeteState();
}

class _PageMeteState extends State<PageMete>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _glow;
  final WeatherService _service = WeatherService();

  final List<Map<String, dynamic>> _villes = [
    {"name": "Dakar",        "icon": Icons.home_work_outlined},
    {"name": "Pointe-Noire, Congo", "icon": Icons.add_business_outlined},
    {"name": "Banjul",       "icon": Icons.language_outlined},
    {"name": "Ouagadougou",  "icon": Icons.business_outlined},
  ];

  Map<String, WeatherModel?> _weatherData = {};
  Map<String, bool> _loadingMap = {};
  Map<String, String?> _errorMap = {};

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _glow = Tween<double>(begin: 6.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fetchAllWeather();
  }

  Future<void> _fetchAllWeather() async {
    for (var ville in _villes) {
      final name = ville["name"] as String;

      setState(() {
        _loadingMap[name] = true;
        _errorMap[name] = null;
      });

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Retour",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [

            /// LISTE DES VILLES + PULL TO REFRESH
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchAllWeather,
                child: ListView.separated(
                  itemCount: _villes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final ville = _villes[index];
                    final name = ville["name"] as String;
                    final icon = ville["icon"] as IconData;
                    return _buildVilleCard(
                        name, icon, index, _villes.length);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// BOUTON ANIMÉ
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange
                            .withOpacity(0.3 + (_glow.value / 40)),
                        blurRadius: 20 + _glow.value,
                        spreadRadius: 2 + (_glow.value / 6),
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color:
                        Colors.orangeAccent.withOpacity(0.15),
                        blurRadius: 40 + _glow.value,
                        spreadRadius: 6 + (_glow.value / 4),
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LoadingScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      elevation: 0,
                      padding:
                      const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Recommencer",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVilleCard(
      String ville, IconData icon, int index, int total) {

    final bool isLoading = _loadingMap[ville] ?? true;
    final String? error = _errorMap[ville];
    final WeatherModel? weather = _weatherData[ville];

    BorderRadius borderRadius;

    if (total == 1) {
      borderRadius = BorderRadius.circular(16);
    } else if (index == 0) {
      borderRadius =
      const BorderRadius.vertical(top: Radius.circular(16));
    } else if (index == total - 1) {
      borderRadius =
      const BorderRadius.vertical(bottom: Radius.circular(16));
    } else {
      borderRadius = BorderRadius.zero;
    }

    return GestureDetector(
      onTap: () {
        if (!isLoading && weather != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  VilleDetailScreen(cityName: ville),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: index < total - 1
              ? const Border(
            bottom: BorderSide(
              color: Color(0xFFE5E5EA),
              width: 0.8,
            ),
          )
              : null,
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        child: Row(
          children: [

            Icon(icon,
                size: 26, color: Colors.black87),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                ville,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (!isLoading && error == null && weather != null)
              Text(
                "${weather.temperature.toStringAsFixed(0)}°C",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),

            if (isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.orange,
                  strokeWidth: 2,
                ),
              ),

            if (error != null)
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _loadingMap[ville] = true;
                    _errorMap[ville] = null;
                  });

                  try {
                    final w =
                    await _service.getWeather(ville);
                    if (!mounted) return;
                    setState(() { _weatherData[ville] = w; _loadingMap[ville] = false; });
                  } catch (e) {
                    if (!mounted) return;
                    setState(() { _errorMap[ville] = "Erreur"; _loadingMap[ville] = false; });
                  }
                },
                child: const Icon(Icons.refresh,
                    color: Colors.orange, size: 22),
              ),

            const Icon(Icons.chevron_right,
                color: Color(0xFFC7C7CC), size: 20),
          ],
        ),
      ),
    );
  }
}