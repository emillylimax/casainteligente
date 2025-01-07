import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import '../../services/realtime_database.dart';

class ControlPage extends StatefulWidget {
  final List<Light> lights;
  final bool isCurtainOpen;
  final bool isAirConditionerOn;
  final double temperature;

  final ValueChanged<bool> onCurtainToggle;
  final ValueChanged<double> onTemperatureChange;
  final void Function(int index, bool isOn, Color color) onLightUpdate;

  const ControlPage({
    required this.lights,
    required this.isCurtainOpen,
    required this.isAirConditionerOn,
    required this.temperature,
    required this.onCurtainToggle,
    required this.onTemperatureChange,
    required this.onLightUpdate,
    super.key,
  });

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  // Mapear luzes para os locais específicos no Firebase
  final Map<String, String> _lightToLocation = {
    "Luz do Banheiro": "banheiro",
    "Luz da Cozinha": "cozinha",
    "Luz do Quarto": "quarto",
    "Luz da Sala": "sala",
  };

  bool isFanOn = false;

  @override
  Widget build(BuildContext context) {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondaryFixedVariant,
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ...widget.lights.asMap().entries.map((entry) {
            final index = entry.key;
            final light = entry.value;
            final location = _lightToLocation[light.name] ?? "local_desconhecido";

            return LightCard(
              light: light,
              onToggle: () async {
                final newState = !light.isOn; // Inverte o estado atual
                try {
                  // Atualiza no Firebase
                  await databaseService.updateLedState(location, newState);

                  // Atualiza o estado local e reconstrói a interface
                  setState(() {
                    widget.onLightUpdate(index, newState, light.color);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar o LED: $e')),
                  );
                }
              },
              onColorChanged: (color) async {
                try {
                  // Atualizar cor no Firebase
                  await databaseService.updateLedColor(location, color);

                  // Atualizar no estado local
                  setState(() {
                    widget.onLightUpdate(index, light.isOn, color);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao atualizar a cor: $e')),
                  );
                }
              },
              showColorButton: light.name == "Luz do Quarto",
                 // Permitir alteração de cor para todas as luzes
            );
          }).toList(),
          FanCard(
            isOn: isFanOn,
            onToggle: () async {
              final newState = !isFanOn; // Inverte o estado atual do ventilador
              try {
                await databaseService.updateFanState('quarto', newState); // Atualiza o estado no Firebase

                setState(() {
                  isFanOn = newState; // Atualiza o estado local
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao atualizar o ventilador: $e')),
                );
              }
            },
          ),
          FanPowerControlCard(room: 'quarto'),
        ],
      ),
    );
  }
}

class Light {
  String name;
  bool isOn;
  Color color;

  Light({required this.name, this.isOn = false, this.color = Colors.white});
}

class LightCard extends StatelessWidget {
  final Light light;
  final VoidCallback onToggle;
  final ValueChanged<Color> onColorChanged; // Mantido como Color
  final bool showColorButton;

  const LightCard({
    required this.light,
    required this.onToggle,
    required this.onColorChanged,
    this.showColorButton = false,
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
            Text(
              light.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: light.name == "Luz do Quarto"
                      ? () async {
                    final databaseService =
                    Provider.of<DatabaseService>(context, listen: false);
                    final location = "quarto";

                    final isAnyLedOn = light.color.blue > 0; // Verifica se o LED azul está ligado

                    if (isAnyLedOn) {
                      // Desliga todos os LEDs do quarto
                      final newColor = Colors.black; // Apaga todas as cores
                      await databaseService.updateLedColor(location, newColor);
                      // Atualiza o estado local
                      onColorChanged(newColor);
                    } else {
                      // Liga o LED azul
                      final newColor = Colors.blue;
                      await databaseService.updateLedColor(location, newColor);
                      // Atualiza o estado local
                      onColorChanged(newColor);
                    }
                  }
                      : onToggle, // Mantém o comportamento padrão para outras luzes
                  style: ElevatedButton.styleFrom(
                    backgroundColor: light.name == "Luz do Quarto" && light.color.blue > 0 ||light.isOn
                        ? Colors.green
                        : Colors.red,
                  ),
                  child: Text(
                    light.name == "Luz do Quarto" && light.color.blue > 0 || light.isOn
                        ? "Ligado"
                        : "Desligado",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (showColorButton)
                  ElevatedButton(
                    onPressed: () async {
                      final Color? pickedColor = await showDialog(
                        context: context,
                        builder: (context) =>
                            RGBPickerDialog(currentState: light.color),
                      );
                      if (pickedColor != null) {
                        final databaseService =
                        Provider.of<DatabaseService>(context, listen: false);
                        final location = "quarto"; // Nome fixo para o exemplo. Substitua se necessário.

                        // Verifica se a cor atual é diferente da nova
                        if (light.color != pickedColor) {
                          // Apaga o LED anterior antes de ativar o novo
                          await databaseService.updateLedColor(location, Colors.black);
                          await databaseService.updateLedColor(location, pickedColor);

                          // Atualiza localmente
                          onColorChanged(pickedColor);
                        }
                      }
                    },
                    child: const Text("Alterar Cor"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RGBPickerDialog extends StatelessWidget {
  final Color currentState;

  const RGBPickerDialog({required this.currentState, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Escolha uma cor"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(Colors.red),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Vermelho"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(Colors.green),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Verde"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(Colors.blue),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Azul"),
          ),
        ],
      ),
    );
  }
}


// Card para controle do ar-condicionado
class AirConditionerCard extends StatelessWidget {
  final bool isOn;
  final VoidCallback onToggle;

  const AirConditionerCard({required this.isOn, required this.onToggle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isOn ? "Ar-Condicionado: Ligado" : "Ar-Condicionado: Desligado",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch(
              value: isOn,
              onChanged: (_) => onToggle(),
            ),
          ],
        ),
      ),
    );
  }
}

// Card para controle da temperatura
class TemperatureCard extends StatelessWidget {
  final double temperature;
  final ValueChanged<double> onTemperatureChanged;

  const TemperatureCard({required this.temperature, required this.onTemperatureChanged, Key? key})
      : super(key: key);

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
            Text(
              "Temperatura: ${temperature.toStringAsFixed(1)}°C",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider(
              value: temperature,
              min: 16,
              max: 26,
              divisions: 10,
              label: "${temperature.toStringAsFixed(1)}°C",
              onChanged: onTemperatureChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class FanCard extends StatelessWidget {
  final bool isOn;
  final VoidCallback onToggle; // Função para alternar o estado do ventilador

  const FanCard({required this.isOn, required this.onToggle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isOn ? "Ventilador: Ligado" : "Ventilador: Desligado",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch(
              value: isOn,
              onChanged: (_) => onToggle(), // Alterna o estado do ventilador
            ),
          ],
        ),
      ),
    );
  }
}
class FanPowerControlCard extends StatefulWidget {
  final String room;

  const FanPowerControlCard({required this.room, Key? key}) : super(key: key);

  @override
  _FanPowerControlCardState createState() => _FanPowerControlCardState();
}

class _FanPowerControlCardState extends State<FanPowerControlCard> {
  int powerLevel = 1;  // Nível de potência padrão (1)

  // Função para alterar o nível de potência
  void _changePowerLevel(int newLevel) async {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);

    try {
      await databaseService.updateFanPowerState(widget.room, newLevel);

      setState(() {
        powerLevel = newLevel;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar o nível de potência: $e')),
      );
    }
  }

  // Função para garantir que a potência padrão seja ajustada conforme o estado do ventilador
  void _setDefaultPowerLevelIfFanOn() async {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    try {
      bool isFanOn = await databaseService.getFanState(widget.room);  // Agora usando o método correto
      if (isFanOn && powerLevel != 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _changePowerLevel(1);  // Se o ventilador estiver ligado, define potência 1
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar o estado do ventilador: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o ventilador está ligado ao montar o widget
    _setDefaultPowerLevelIfFanOn();

    return Card(
      color: Theme.of(context).colorScheme.onSecondary,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Potência do Ventilador - Nível: $powerLevel",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _changePowerLevel(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: powerLevel == 1
                        ? Colors.green
                        : Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text("Potência 1"),
                ),
                ElevatedButton(
                  onPressed: () => _changePowerLevel(2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: powerLevel == 2
                        ? Colors.green
                        : Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text("Potência 2"),
                ),
                ElevatedButton(
                  onPressed: () => _changePowerLevel(3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: powerLevel == 3
                        ? Colors.green
                        : Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(100, 40),
                  ),
                  child: const Text("Potência 3"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// // Card Placeholder
// class PlaceholderCard extends StatelessWidget {
//   final String title;

//   const PlaceholderCard({required this.title, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           title,
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//       ),
//     );
//   }
// }