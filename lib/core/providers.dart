
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/Store_service.dart';
import '../services/auth_service.dart';
import '../services/realtime_database.dart';


class ConfigureProviders {

  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {

    final authService = AuthService();

    final realtime = DatabaseService();

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: authService),

      Provider<DatabaseService>.value(value: realtime)
    ]);
  }
}