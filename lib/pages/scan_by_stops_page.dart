import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poc/consts.dart';
import 'package:poc/pages/bus_list_page.dart';
import 'package:poc/pages/no_nearby_stops_page.dart';
import 'package:poc/utils/extra.dart';
import 'package:poc/utils/snackbar.dart';

class ScanByStopsPage extends StatefulWidget {
  const ScanByStopsPage({super.key});

  @override
  State<ScanByStopsPage> createState() => _ScanByStopsPageState();
}

class _ScanByStopsPageState extends State<ScanByStopsPage> {
  /// Scan BLE variables
  //! _systemDevices Não é utilizada
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  List<Guid> totemService = [Guid.fromString(accessBusStopServiceUUID)];
  BluetoothCharacteristic? busRoutesCharacteristic;
  String busStopIdValue = '';
  bool alreadyScanned = false;

  @override
  void initState() {
    super.initState();

    /// Scan BLE devices
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      log('_scanResults: $_scanResults');
      if (_scanResults.isNotEmpty) {
        onConnectPressed(_scanResults.first.device);
      }
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;

      log('_isScanning: $_isScanning');
      if (_isScanning) {
        /// implement numberOfScans logic
        alreadyScanned = true;
      }
      if (_isScanning == false && alreadyScanned && _scanResults.isEmpty) {
        log('Nenhuma Parada Encontrada!');
        //! Fazer navegação para a NoNearbyStopPage
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const NoNearbyStopPage(),
            ));

        /// implement numberOfScans logic
      }
      if (mounted) {
        setState(() {});
      }
    });

    onScanPressed();
  }

  @override
  void dispose() {
    /// dispose scan ble subscriptions
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
      log('_systemDevices: $_systemDevices');
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
          success: false);
    }
    try {
      await FlutterBluePlus.startScan(
          withServices: totemService, timeout: const Duration(seconds: 15));
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
          success: false);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void onConnectPressed(BluetoothDevice device) async {
    await device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    log('Connected with $device !?');

    List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
    for (var connectedDevice in connectedDevices) {
      log('connectedDevice: $connectedDevice');
    }

    /// Discover Device Services
    // Note: You must call discoverServices after every re-connection!
    List<BluetoothService> services = await device.discoverServices();
    // for (var service in services) {
    //   // do something with service
    //   log('Device_Service: $service');
    // }

    /// Read Characteristic ID da Parada
    BluetoothService accessBusStopService = services.firstWhere((element) =>
        element.serviceUuid == Guid.fromString(accessBusStopServiceUUID));
    log('accessBusStopService: $accessBusStopService');
    BluetoothCharacteristic busStopIdCharacteristic =
        accessBusStopService.characteristics.firstWhere((element) =>
            element.characteristicUuid == Guid.fromString(busStopIdUUID));
    log('busStopIdCharacteristic: $busStopIdCharacteristic');
    if (busStopIdCharacteristic.properties.read) {
      List<int> readCharResult = await busStopIdCharacteristic.read();
      log('readCharResult: $readCharResult');

      // converte to String
      busStopIdValue = String.fromCharCodes(readCharResult);
      log('busStopIdValue: $busStopIdValue');

      if (busStopIdValue.isNotEmpty && mounted) {
        //! Fazer a navegação para a BusListPage enviando o accessBusStopService!
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => BusListPage(
                accessBusStopService: accessBusStopService,
                busStopId: busStopIdValue,
              ),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFCFF3EC),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/street_icon.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: Text(
                    "PARADA DE   ÔNIBUS ACESSÍVEL",
                    style: GoogleFonts.rubikMonoOne(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image.asset(
                  'assets/icons/totem_to_phone_icon.png',
                  width: 250,
                  height: 210,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  "Procurando parada de\n ônibus acessível...",
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    height: 1.515,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
