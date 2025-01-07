import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage();

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Lista de dispositivos
  final List<Map<String, String>> devices = [
    {'name': 'Banheiro LED', 'path': 'Casa/banheiro/led'},
    {'name': 'Sala LED', 'path': 'Casa/sala/led'},
    {'name': 'Cozinha LED', 'path': 'Casa/cozinha/led'},
    {'name': 'Quarto Ventilador', 'path': 'Casa/quarto/ventilador'},
    {'name': 'Quarto LED R', 'path': 'Casa/quarto/ledR'},
    {'name': 'Quarto LED G', 'path': 'Casa/quarto/ledG'},
    {'name': 'Quarto LED B', 'path': 'Casa/quarto/ledB'},
    {'name': 'Quarto LED P1', 'path': 'Casa/quarto/ledP1'},
    {'name': 'Quarto LED P2', 'path': 'Casa/quarto/ledP2'},
    {'name': 'Quarto LED P3', 'path': 'Casa/quarto/ledP3'},
  ];
//a
  // Estados dos dispositivos
  Map<String, bool> deviceStates = {};

  // Localização
  // static const double maqueteLatitude = -5.871458;
  // static const double maqueteLongitude = -35.230166;
  static const double maqueteLatitude =  -5.886037;
  static const double maqueteLongitude = -35.362981;
  StreamSubscription<Position>? _positionStream;

  // Estado do card personalizado
  bool isCustomCardActive = false;
  bool isStandardCardActive = true;
  List<String> selectedDevices = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _checkPermissionsAndStartStream();
    _initializeDeviceStates();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isCustomCardActive = prefs.getBool('isCustomCardActive') ?? false;
      isStandardCardActive = prefs.getBool('isStandardCardActive') ?? true;
      selectedDevices = prefs.getStringList('selectedDevices') ?? [];
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCustomCardActive', isCustomCardActive);
    await prefs.setBool('isStandardCardActive', isStandardCardActive);
    await prefs.setStringList('selectedDevices', selectedDevices);
  }

  Future<void> _initializeDeviceStates() async {
    for (var device in devices) {
      final DatabaseEvent event = await _database.child(device['path']!).once();
      setState(() {
        deviceStates[device['path']!] = event.snapshot.value == true;
      });
    }
  }

  Future<void> _checkPermissionsAndStartStream() async {
    await requestLocationPermission();
    _startPositionStream();
  }

  void _startPositionStream() {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        maqueteLatitude,
        maqueteLongitude,
      );

      print('Distância até a maquete: ${distanceInMeters.toStringAsFixed(2)} metros');

      if (distanceInMeters <= 40) {
        if (isCustomCardActive) {
          _activateCustomRoutine();
        } else if (isStandardCardActive) {
          _activateRoutine();
        }
      } else {
        _deactivateRoutine();
      }
    });
  }

  Future<void> _activateRoutine() async {
    print('Ativando rotina de entrada...');
    for (var device in devices) {
      try {
        await _database.child(device['path']!).set(true);
        print('Dispositivo ${device['name']} ligado.');
      } catch (e) {
        print('Erro ao ligar ${device['name']}: $e');
      }
    }
    setState(() {
      for (var device in devices) {
        deviceStates[device['path']!] = true;
      }
    });
  }

  Future<void> _deactivateRoutine() async {
    print('Ativando rotina de saída...');
    for (var device in devices) {
      try {
        await _database.child(device['path']!).set(false);
        print('Dispositivo ${device['name']} desligado.');
      } catch (e) {
        print('Erro ao desligar ${device['name']}: $e');
      }
    }
    setState(() {
      for (var device in devices) {
        deviceStates[device['path']!] = false;
      }
    });
  }

  Future<void> _activateCustomRoutine() async {
    print('Ativando rotina personalizada...');
    for (var device in selectedDevices) {
      try {
        await _database.child(device).set(true);
        print('Dispositivo $device ligado.');
      } catch (e) {
        print('Erro ao ligar $device: $e');
      }
    }
    setState(() {
      for (var device in selectedDevices) {
        deviceStates[device] = true;
      }
    });
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Permissão de localização negada.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permissão negada permanentemente. Acesse as configurações do app.');
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      print('Permissão concedida!');
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          RoutineCard(
            title: "Rotina de Entrada",
            devices: devices,
            deviceStates: deviceStates,
            isActive: isStandardCardActive,
            onActivate: (isActive) {
              setState(() {
                isStandardCardActive = isActive;
                if (isActive) {
                  isCustomCardActive = false;
                }
                _savePreferences();
              });
            },
            onToggle: (path, value) => _updateDeviceState(path, value),
          ),
          RoutineCard(
            title: "Rotina de Saída",
            devices: devices,
            deviceStates: deviceStates,
            isActive: false, // Add the required isActive argument
            onActivate: (isActive) {}, // Add the required onActivate argument
            onToggle: (path, value) => _updateDeviceState(path, value),
            showSwitch: false, // Especifica que o switch não deve ser mostrado
          ),
          CustomRoutineCard(
            title: "Rotina Personalizada",
            devices: devices,
            deviceStates: deviceStates,
            selectedDevices: selectedDevices,
            isActive: isCustomCardActive,
            onActivate: (isActive) {
              setState(() {
                isCustomCardActive = isActive;
                if (isActive) {
                  isStandardCardActive = false;
                }
                _savePreferences();
              });
            },
            onDeviceSelected: (path, isSelected) {
              setState(() {
                if (isSelected) {
                  selectedDevices.add(path);
                } else {
                  selectedDevices.remove(path);
                }
                _savePreferences();
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateDeviceState(String path, bool newState) async {
    try {
      await _database.child(path).set(newState);
      setState(() {
        deviceStates[path] = newState;
      });
      print('Estado do dispositivo em $path atualizado para $newState.');
    } catch (e) {
      print('Erro ao atualizar estado do dispositivo em $path: $e');
    }
  }
}

class RoutineCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> devices;
  final Map<String, bool> deviceStates;
  final bool isActive;
  final void Function(bool isActive) onActivate;
  final void Function(String path, bool value) onToggle;
  final bool showSwitch;

  const RoutineCard({
    required this.title,
    required this.devices,
    required this.deviceStates,
    required this.isActive,
    required this.onActivate,
    required this.onToggle,
    this.showSwitch = true, // Parâmetro opcional para mostrar ou ocultar o switch
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (showSwitch)
                  Switch(
                    value: isActive,
                    onChanged: onActivate,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            ...devices.map((device) {
              final path = device['path']!;
              final name = device['name']!;
              final state = deviceStates[path] ?? false;
              return SwitchListTile(
                title: Text(name),
                value: state,
                onChanged: (value) => onToggle(path, value),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CustomRoutineCard extends StatelessWidget {
  final String title;
  final List<Map<String, String>> devices;
  final Map<String, bool> deviceStates;
  final List<String> selectedDevices;
  final bool isActive;
  final void Function(bool isActive) onActivate;
  final void Function(String path, bool isSelected) onDeviceSelected;

  const CustomRoutineCard({
    required this.title,
    required this.devices,
    required this.deviceStates,
    required this.selectedDevices,
    required this.isActive,
    required this.onActivate,
    required this.onDeviceSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch(
                  value: isActive,
                  onChanged: onActivate,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...devices.map((device) {
              final path = device['path']!;
              final name = device['name']!;
              final isSelected = selectedDevices.contains(path);
              return CheckboxListTile(
                title: Text(name),
                value: isSelected,
                onChanged: (value) => onDeviceSelected(path, value!),
              );
            }),
          ],
        ),
      ),
    );
  }
}