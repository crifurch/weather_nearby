import 'package:weather_nearby/app.dart';
import 'package:weather_nearby/flavor/environment.dart';

void main() {
  setupApp(
    Environment(
      apiUrl: 'https://api.openweathermap.org/data/2.5/',
      // this key is free no sense to secret it
      apiKey: '5dcc4e458c9c37f0783f6a0b9d296e71',
    ),
  );
}
