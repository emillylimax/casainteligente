import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<void> updateLedState(String location, bool isOn) async {
    try {
      await _database.child('Casa/$location/led').set(isOn);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLedColor(String location, Color color) async {
    try {
      // Determinar quais campos devem ser `true` ou `false` com base na cor selecionada
      final Map<String, bool> colorData = {
        "ledR": color == Colors.red,
        "ledG": color == Colors.green,
        "ledB": color == Colors.blue,
      };

      // Atualizar no banco de dados
      await _database.child('Casa/$location').update(colorData);
    } catch (e) {
      rethrow;
    }
  }

  // Verificar se pelo menos uma das cores está ativa para determinar o estado geral do LED
  Future<bool> isLedOn(String location) async {
    try {
      final snapshot = await _database.child('Casa/$location').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map;
        return data["ledR"] == true || data["ledG"] == true || data["ledB"] == true;
      }

      return false;
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> isLedOn2(String location) async {
    try {
      final snapshot = await _database.child('Casa/$location/led').get();

      if (snapshot.exists) {
        return snapshot.value as bool;
      }

      return false; // Caso não exista o valor ou a chave, retornamos falso
    } catch (e) {
      rethrow;
    }
  }
  Stream<double> getTemperatureStream(String location) {
    location = location.toLowerCase(); // Força o uso de minúsculas
    return _database.child('Casa/$location/temp').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/temp: $data');
      if (data != null) {
        return double.tryParse(data.toString()) ?? 0.0;
      }
      return 0.0; // Retorno padrão
    });
  }
  Stream<double> getLdrStream(String location) {
    location = location.toLowerCase(); // Garante consistência no uso de minúsculas
    return _database.child('Casa/$location/ldr').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/ldr: $data');
      if (data != null) {
        return double.tryParse(data.toString()) ?? 0.0;
      }
      return 0.0; // Valor padrão caso os dados sejam nulos
    });
  }

  Stream<double> getHumidityStream(String location) {
    location = location.toLowerCase();
    return _database.child('Casa/$location/umidade').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/umidade: $data');
      if (data != null) {
        return double.tryParse(data.toString()) ?? 0.0;
      }
      return 0.0;
    });
  }
  Stream<bool> getFanStateStream(String location) {
    location = location.toLowerCase();
    return _database.child('Casa/$location/ventilador').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/ventilador: $data');
      if (data != null) {
        return data.toString() == 'true';
      }
      return false; // Valor padrão, supondo que o ventilador está desligado
    });
  }
  Stream<bool> getLedRStateStream(String location) {
    location = location.toLowerCase();
    return _database.child('Casa/$location/ledR').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/ledR: $data');
      if (data != null) {
        return data.toString() == 'true';
      }
      return false; // Valor padrão, considerando que o LED está desligado
    });
  }

  // Método para obter o estado do LED verde (ledG)
  Stream<bool> getLedGStateStream(String location) {
    location = location.toLowerCase();
    return _database.child('Casa/$location/ledG').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/ledG: $data');
      if (data != null) {
        return data.toString() == 'true';
      }
      return false; // Valor padrão, considerando que o LED está desligado
    });
  }

  // Método para obter o estado do LED azul (ledB)
  Stream<bool> getLedBStateStream(String location) {
    location = location.toLowerCase();
    return _database.child('Casa/$location/ledB').onValue.map((event) {
      final data = event.snapshot.value;
      print('Dados recebidos do Firebase para $location/ledB: $data');
      if (data != null) {
        return data.toString() == 'true';
      }
      return false; // Valor padrão, considerando que o LED está desligado
    });
  }
  //ventilador ligar / desligar
  Future<void> updateFanState(String room, bool isOn) async {
    try {
      await _database.child('Casa/$room/ventilador').set(isOn);
    } catch (e) {
      rethrow;
    }
  }
  //potencia do ventilador
  Future<void> updateFanPowerState(String room, int powerLevel) async {
    try {
      // Atualiza o estado dos LEDs de potência conforme o nível de potência
      await _database.child('Casa/$room/ledP1').set(powerLevel >= 1);
      await _database.child('Casa/$room/ledP2').set(powerLevel >= 2);
      await _database.child('Casa/$room/ledP3').set(powerLevel == 3);
    } catch (e) {
      throw Exception("Erro ao atualizar os LEDs de potência: $e");
    }
  }
  Future<bool> getFanState(String location) async {
    location = location.toLowerCase();
    final snapshot = await _database.child('Casa/$location/ventilador').get();
    final data = snapshot.value;
    print('Dados recebidos do Firebase para $location/ventilador: $data');
    if (data != null) {
      return data.toString() == 'true';
    }
    return false; // Valor padrão, supondo que o ventilador está desligado
  }
  Stream<bool> getPresenceSensorStream(String location) {
    return _database.child('Casa/$location/presenca').onValue.map((event) {
      return event.snapshot.value as bool? ?? false;
    });
  }




}


