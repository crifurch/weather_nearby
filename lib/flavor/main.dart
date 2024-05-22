import 'package:weather_nearby/app.dart';
import 'package:weather_nearby/flavor/environment.dart';

void main() {
  setupApp(
    Environment(
      apiUrl: 'https://api.openweathermap.org/data/2.5/',
      apiKey: Platform.environment['WHEATHER_API_KEY'] ?? '',
    ),
  );
}
