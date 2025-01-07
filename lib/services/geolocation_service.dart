import 'package:geolocator/geolocator.dart';

class LocationService {
  // Verifica e solicita permissões de localização, se necessário
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  // Obtém a posição atual do usuário
  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        print('Permissões de localização negadas.');
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("Localização obtida: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      print('Erro ao obter localização: $e');
      return null;
    }
  }
}
