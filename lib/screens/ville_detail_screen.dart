import 'package:flutter/material.dart';
import 'package:untitled/theme_notifier.dart';
import 'package:untitled/services/weather_service.dart';
import 'package:untitled/models/weather_model.dart';
import 'package:url_launcher/url_launcher.dart';

class VilleDetailScreen extends StatefulWidget {
  final String cityName;

  const VilleDetailScreen({super.key, required this.cityName});

  @override
  State<VilleDetailScreen> createState() => _VilleDetailScreenState();
}

class _VilleDetailScreenState extends State<VilleDetailScreen> {
  final WeatherService _service = WeatherService();
  WeatherModel? _weather;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final data = await _service.getWeather(widget.cityName);
      if (!mounted) return;
      setState(() {
        _weather = data;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Impossible de charger les données météo";
        _loading = false;
      });
    }
  }

  // 📍 Coordonnées des villes
  Map<String, String> _coordinates() {
    switch (widget.cityName) {
      case "Banjul":
        return {"lat": "13.4549", "lon": "-16.5790"};
      case "Ouagadougou":
        return {"lat": "12.3714", "lon": "-1.5197"};
      case "Dakar":
        return {"lat": "14.7167", "lon": "-17.4677"};
      case "Pointe-Noire, Congo":
        return {"lat": "-4.7761", "lon": "11.8635"};
      default:
        return {"lat": "0", "lon": "0"};
    }
  }

  Future<void> _openMap() async {
    final coords = _coordinates();
    final url =
        "https://www.google.com/maps/search/?api=1&query=${coords["lat"]},${coords["lon"]}";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, _) {
        final bgColor =
        isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF0F4FF);
        final textColor =
        isDark ? Colors.white : const Color(0xFF1A1F36);
        final cardColor =
        isDark ? Colors.white.withOpacity(0.05) : Colors.white;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
            title: Text(widget.cityName,
                style: TextStyle(color: textColor)),
          ),
          body: _loading
              ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFFFF8C00)))
              : _error != null
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_error!,
                    style: TextStyle(color: textColor)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _loading = true;
                      _error = null;
                    });
                    _fetchWeather();
                  },
                  child: const Text("Réessayer"),
                )
              ],
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${_weather!.temperature.toStringAsFixed(1)}°C",
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF8C00),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weather!.description,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(Icons.water_drop,
                                  color: Colors.blue),
                              const SizedBox(height: 6),
                              Text(
                                  "Humidité : ${_weather!.humidity}%",
                                  style: TextStyle(
                                      color: textColor)),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(Icons.air,
                                  color: Colors.grey),
                              const SizedBox(height: 6),
                              Text(
                                  "Vent : ${_weather!.windSpeed} m/s",
                                  style: TextStyle(
                                      color: textColor)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: _openMap,
                  icon: const Icon(Icons.map),
                  label:
                  const Text("Voir sur Google Maps"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xFFFF8C00),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
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