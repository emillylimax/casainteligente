import 'package:flutter/material.dart';

import '../../services/realtime_database.dart';
import 'controlPage.dart';

class HousePage extends StatefulWidget {
  final List<Light> lights;
  final bool isCurtainOpen;
  final bool isAirConditionerOn;
  final double temperature;
  final bool isGasOn;

  const HousePage({
    required this.lights,
    required this.isCurtainOpen,
    required this.isAirConditionerOn,
    required this.temperature,
    required this.isGasOn,
    Key? key,
  }) : super(key: key);

  @override
  _HousePageState createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  final DatabaseService _databaseService = DatabaseService();
  bool isPresenceDetected = false;


  @override
  void initState() {
    super.initState();
    _getPresenceSensorState();
  }

  void _getPresenceSensorState() async {
    final databaseService = DatabaseService();
    bool presenceState = await databaseService.getPresenceSensorStream("sala").first;
    if (mounted) {
      setState(() {
        isPresenceDetected = presenceState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
        title: const Text('Casa'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: [
          StreamBuilder<bool>(
            stream: _databaseService.getPresenceSensorStream("sala"),
            builder: (context, presenceSnapshot) {
              final isPresenceDetected = presenceSnapshot.data ?? false;
              return StreamBuilder<double>(
                stream: _databaseService.getTemperatureStream("sala"),
                builder: (context, tempSnapshot) {
                  final temperature = tempSnapshot.data ?? 0.0;
                  return StreamBuilder<double>(
                    stream: _databaseService.getLdrStream("sala"),
                    builder: (context, ldrSnapshot) {
                      final ldrValue = ldrSnapshot.data ?? 0.0;
                      return _RoomCard(
                        title: 'Sala',
                        icon: Icons.chair,
                        details: [
                          'Temperatura: ${temperature.toStringAsFixed(1)}°C',
                          'Luminosidade: ${ldrValue.toStringAsFixed(1)}',
                          'Luz: ${widget.lights[3].isOn ? "Ligada" : "Desligada"}',
                          'Presença: ${isPresenceDetected ? "Detectada" : "Ausente"}',
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),


          // StreamBuilder<double>(
          //   stream: DatabaseService().getTemperatureStream('sala'),
          //   builder: (context, tempSnapshot) {
          //     final temperature = tempSnapshot.data ?? 0.0;
          //     return StreamBuilder<double>(
          //       stream: DatabaseService().getLdrStream('sala'),
          //       builder: (context, ldrSnapshot) {
          //         final ldrValue = ldrSnapshot.data ?? 0.0;
          //         return _RoomCard(
          //           title: 'Sala',
          //           icon: Icons.chair,
          //           details: [
          //             'Luz 1: ${widget.lights[3].isOn ? 'Ligada' : 'Desligada'}',
          //             'Temperatura: ${temperature.toStringAsFixed(1)}°C',
          //             'Luminosidade: ${ldrValue.toStringAsFixed(1)}',


          //           ],
          //         );
          //       },
          //     );
          //   },
          // ),
          StreamBuilder<double>(
            stream: DatabaseService().getTemperatureStream('cozinha'),
            builder: (context, tempSnapshot) {
              final temperature = tempSnapshot.data ?? 0.0;
              return StreamBuilder<double>(
                stream: DatabaseService().getLdrStream('cozinha'),
                builder: (context, ldrSnapshot) {
                  final ldrValue = ldrSnapshot.data ?? 0.0;
                  return _RoomCard(
                    title: 'Cozinha',
                    icon: Icons.kitchen,
                    details: [
                      'Luz 2: ${widget.lights[1].isOn ? 'Ligada' : 'Desligada'}',
                      'Temperatura: ${temperature.toStringAsFixed(1)}°C',
                      'Luminosidade: ${ldrValue.toStringAsFixed(1)}',

                    ],
                  );
                },
              );
            },
          ),
          StreamBuilder<double>(
            stream: DatabaseService().getTemperatureStream('banheiro'),
            builder: (context, tempSnapshot) {
              final temperature = tempSnapshot.data ?? 0.0;
              return StreamBuilder<double>(
                stream: DatabaseService().getLdrStream('banheiro'),
                builder: (context, ldrSnapshot) {
                  final ldrValue = ldrSnapshot.data ?? 0.0;
                  return _RoomCard(
                    title: 'Banheiro',
                    icon: Icons.bathtub,
                    details: [
                      'Luz 3: ${widget.lights[0].isOn ? 'Ligada' : 'Desligada'}',
                      'Temperatura: ${temperature.toStringAsFixed(1)}°C',
                      'Luminosidade: ${ldrValue.toStringAsFixed(1)}',

                    ],
                  );
                },
              );
            },
          ),
          StreamBuilder<double>(
            stream: DatabaseService().getTemperatureStream('quarto'),
            builder: (context, tempSnapshot) {
              final temperature = tempSnapshot.data ?? 0.0;
              return StreamBuilder<double>(
                stream: DatabaseService().getLdrStream('quarto'),
                builder: (context, ldrSnapshot) {
                  final ldrValue = ldrSnapshot.data ?? 0.0;
                  return StreamBuilder<double>(
                    stream: DatabaseService().getHumidityStream('quarto'),
                    builder: (context, humiditySnapshot) {
                      final humidity = humiditySnapshot.data ?? 0.0;
                      return StreamBuilder<bool>(
                        stream: DatabaseService().getFanStateStream('quarto'),
                        builder: (context, fanSnapshot) {
                          final fanState = fanSnapshot.data ?? false;
                          return StreamBuilder<bool>(
                            stream: DatabaseService().getLedRStateStream('quarto'),
                            builder: (context, ledRSnapshot) {
                              final ledRState = ledRSnapshot.data ?? false;
                              return StreamBuilder<bool>(
                                stream: DatabaseService().getLedGStateStream('quarto'),
                                builder: (context, ledGSnapshot) {
                                  final ledGState = ledGSnapshot.data ?? false;
                                  return StreamBuilder<bool>(
                                    stream: DatabaseService().getLedBStateStream('quarto'),
                                    builder: (context, ledBSnapshot) {
                                      final ledBState = ledBSnapshot.data ?? false;

                                      // Verifica se algum dos LEDs está ligado
                                      final isLight4On = ledRState || ledGState || ledBState;

                                      return _RoomCard(
                                        title: 'Quarto',
                                        icon: Icons.bed,
                                        details: [
                                          'Temperatura: ${temperature.toStringAsFixed(1)}°C',
                                          'Luminosidade: ${ldrValue.toStringAsFixed(1)}',
                                          'Umidade: ${humidity.toStringAsFixed(1)}%',
                                          'Ventilador: ${fanState ? 'Ligado' : 'Desligado'}',
                                          'Luz 4: ${isLight4On ? 'Ligada' : 'Desligada'}',
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> details;

  const _RoomCard({
    required this.title,
    required this.icon,
    required this.details,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 8),
              ...details.map((detail) => Text(detail)),
            ],
          ),
        ),
      ),
    );
  }
}
