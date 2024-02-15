// Copyright 2017-2023, Charles Weinberger & Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:poc/screens/bus_list.dart';
import 'package:poc/screens/no_nearby_stops.dart';
import 'package:poc/screens/waiting_bus.dart';

import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';
/*
void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
    runApp(const BusList());
}
*/
void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  runApp(MaterialApp(
    home: const BusListPage(),
    color: Colors.lightBlue,
    navigatorObservers: [BluetoothAdapterStateObserver()],
  ));
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
    _adapterStateStateSubscription = FlutterBluePlus.adapterState.listen((state) {
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
        ? const ScanScreen()
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
      _adapterStateSubscription ??= FlutterBluePlus.adapterState.listen((state) {
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

*/ /*
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final json = await fetch();
  print(json);
}

Future<List<dynamic>> fetch() async {
  var url = 'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/forecast/lines/fromPoint/106053/281';
  var response = await http.get(Uri.parse(url));
  var json = jsonDecode(response.body);
  return json;
}
*/

import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final json = await fetch();
  print(json[0]['id']);
}

Future<List<dynamic>> fetch() async {
  var url = 'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/busStop/-3.7420233/-38.53712/281?radiusInMeters=500';
  var response = await http.get(Uri.parse(url));
  var json = jsonDecode(response.body);
  return json;
}
