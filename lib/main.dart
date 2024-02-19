// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:poc/pages/bus_list_page.dart';
import 'pages/bluetooth_off_screen.dart';
import 'package:poc/services/api_service.dart';

Future<void> main() async {
  try {
    final json = await fetchAPI();
    if (json.isNotEmpty) {
      print(json);
    } else {
      print('A resposta da API está vazia.');
    }
  } catch (e) {
    print('Erro ao buscar dados da API: $e');
  }
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(const FlutterBlueApp());
}

//
// This widget shows BluetoothOffScreen or
// ScanScreen depending on the adapter state
//

class FlutterBlueApp extends StatefulWidget {
  const FlutterBlueApp({Key? key}) : super(key: key);

  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? MaterialApp(
            home: const BusListPage(),
            color: Colors.lightBlue,
            navigatorObservers: [BluetoothAdapterStateObserver()])
        : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      color: Colors.lightBlue,
      home: screen,
      navigatorObservers: [BluetoothAdapterStateObserver()],
    );
  }
}

//
// This observer listens for Bluetooth Off and dismisses the DeviceScreen
//
class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      // Start listening to Bluetooth state changes when a new route is pushed
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          // Pop the current route if Bluetooth is off
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}



/*
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  try {
    final json = await fetchAPI();
    if (json.isNotEmpty) {
      print(json);
    } else {
      print('A resposta da API está vazia.');
    }
  } catch (e) {
    print('Erro ao buscar dados da API: $e');
  }
}

Future<List<dynamic>> fetchAPI() async {
  var url =
      'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/forecast/lines/fromPoint/107282/281';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    return json;
  } else {
    print('Erro ao acessar a API. Código de status: ${response.statusCode}');
    return [];
  }
}
*/