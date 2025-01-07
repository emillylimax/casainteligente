import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:casa_inteligente/ui/pages/routinePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import 'controlPage.dart';
import 'homePage.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Casa Inteligente",
      theme: ThemeData(
        brightness: brightness,
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
        splash: Transform.scale(
          scale: 5.0, // Aumenta o tamanho
          child: Image.asset('assets/icons/logo.png'),
        ),
        nextScreen: const Home(title: "Minha Casa Inteligente"),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: const Color.fromARGB(255, 88, 42, 69), // Cor de fundo
        duration: 3000, // Duração em milissegundos
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Light> _lights = [
    Light(name: "Luz do Banheiro", color: Colors.white),
    Light(name: "Luz da Cozinha", color: Colors.white),
    Light(name: "Luz do Quarto", color: Colors.white),
    Light(name: "Luz da Sala", color: Colors.white),
  ];

  bool isCurtainOpen = false;
  bool isAirConditionerOn = false;
  double temperature = 20;
  bool isGasOn = false;

  int _currentIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HousePage(
        lights: _lights,
        isCurtainOpen: isCurtainOpen,
        isAirConditionerOn: isAirConditionerOn,
        temperature: temperature,
        isGasOn: isGasOn,
      ),
      ControlPage(
        lights: _lights,
        isCurtainOpen: isCurtainOpen,
        isAirConditionerOn: isAirConditionerOn,
        temperature: temperature,
        onCurtainToggle: _updateCurtainState,
        onLightUpdate: _updateLightState,
        onTemperatureChange: _updateTemperatureState,
      ),
      const RoutinePage(),
    ];
  }

  void _updateCurtainState(bool value) {
    setState(() {
      isCurtainOpen = value;
    });
  }

  void _updateLightState(int index, bool isOn, Color color) {
    setState(() {
      _lights[index].isOn = isOn;
      _lights[index].color = color;
    });
  }

  void _updateTemperatureState(double value) {
    setState(() {
      temperature = value;
    });
  }

  void _updateGasState(bool value) {
    setState(() {
      isGasOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Controle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rotina',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimaryFixed,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        showUnselectedLabels: true,
      ),
    );
  }
}