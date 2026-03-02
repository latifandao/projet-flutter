import 'package:dio/dio.dart';
import 'package:untitled/models/weather_model.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String _apiKey = '57f02a136c29f2b7eeb1ddddb384b047';

  Future<WeatherModel> getWeather(String cityName) async {
    final response = await _dio.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: {
        'q': cityName,
        'appid': _apiKey,
        'units': 'metric',
        'lang': 'fr', // description en français
      },
    );

    final data = response.data;

    return WeatherModel(
      temperature: (data['main']['temp'] as num).toDouble(),
      cityName: data['name'],
      description: data['weather'][0]['description'],
      humidity: data['main']['humidity'],
      windSpeed: (data['wind']['speed'] as num).toDouble(),
    );
  }
}