import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final double temperature;
  final String cityName;
  final String description;
  final int humidity;
  final double windSpeed;

  WeatherModel({
    required this.temperature,
    required this.cityName,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}