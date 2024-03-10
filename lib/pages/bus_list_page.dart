import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poc/services/api_service.dart';
import 'package:poc/utils/dialogs.dart';
import 'package:poc/utils/extra.dart';
import 'package:poc/utils/snackbar.dart';

const String accessBusStopServiceUUID = '3fd792fc-9e11-4d98-b981-ce0d7532651b';
const String busStopIdUUID = '3fd792fc-9e11-4d98-b981-ce0d7532651c';
const String busRoutesUUID = '3fd792fc-9e11-4d98-b981-ce0d7532651e';

class BusListPage extends StatefulWidget {
  const BusListPage({Key? key}) : super(key: key);

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late List<Map<String, dynamic>> busData = [];
  late Timer _timer;

  /// Scan BLE variables
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  List<Guid> totemService = [Guid.fromString(accessBusStopServiceUUID)];
  // BluetoothCharacteristic? busNumberCharacteristic;
  BluetoothCharacteristic? busRoutesCharacteristic;
  String busStopIdValue = '';

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
      }
      if (_isScanning == false && _scanResults.isEmpty) {
        log('Nenhuma Parada Encontrada!');

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

    _timer.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
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

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
          success: false);
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

      if (busStopIdValue.isNotEmpty) {
        //! After read characteristic busStopIdUUID
        fetchBusData();
        _timer = Timer.periodic(
            const Duration(minutes: 1), (Timer t) => fetchBusData());
      }

      /// get busRoutesCharacteristic
      busRoutesCharacteristic = accessBusStopService.characteristics.firstWhere(
          (element) =>
              element.characteristicUuid == Guid.fromString(busRoutesUUID));
      log('busRoutesCharacteristic: $busRoutesCharacteristic');
    }

    // MaterialPageRoute route = MaterialPageRoute(
    //     builder: (context) => DeviceScreen(device: device),
    //     settings: const RouteSettings(name: '/DeviceScreen'));
    // Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> fetchBusData() async {
    try {
      final List<dynamic> json = await fetchBusAPI();
      setState(() {
        busData = List<Map<String, dynamic>>.from(json);
      });
    } catch (e) {
      log('Erro ao buscar dados da API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'assets/icons/distance_icon.png',
            width: 24,
            height: 24,
          ),
          backgroundColor: const Color(0xFF5EB4F0),
          centerTitle: true,
          title: Text(
            "Parada Carrefour Barão de Studart",
            style: GoogleFonts.quicksand(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              height: 1.364,
              letterSpacing: 0.0,
              color: Colors.white,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: fetchBusData,
          child: busData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.directions_bus,
                                size: 24,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 1,
                                width: 40,
                                color: const Color(0xFFD4DADE),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset(
                                'assets/icons/line_start_icon.png',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 1,
                                width: 200,
                                color: const Color(0xFFD4DADE),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Icon(
                                Icons.access_time_filled_rounded,
                                size: 24,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: 1,
                                width: 40,
                                color: const Color(0xFFD4DADE),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: busData.length,
                          itemBuilder: (context, index) {
                            final bus = busData[index];
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 25,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return confirmBusDialog(
                                          context: context,
                                          busNumber: bus["busServiceNumber"]
                                              .toString(),
                                          busName:
                                              bus["patternName"].toString(),
                                          arrivalTime:
                                              bus["arrivalTime"].toString(),
                                          busNumberCharacteristic:
                                              busRoutesCharacteristic!,
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            width: bus["busServiceNumber"]
                                                        .toString()
                                                        .length ==
                                                    4
                                                ? 45
                                                : 40,
                                            child: Center(
                                              child: Text(
                                                '${bus["busServiceNumber"]}',
                                                style: GoogleFonts.roboto(
                                                  color:
                                                      const Color(0xFF4BA4E3),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  height: 0.09,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: 200,
                                            child: Text(
                                              bus["nameLine"]
                                                  .split("-")[1]
                                                  .trim(),
                                              style: GoogleFonts.roboto(
                                                color: const Color(0xFF132632),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                //  height: 0.09,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          child: Center(
                                            child: Text(
                                              "${bus["arrivalTime"]} min",
                                              style: GoogleFonts.roboto(
                                                color: const Color(0xFF4BA4E3),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                height: 0.09,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: const ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign:
                                            BorderSide.strokeAlignCenter,
                                        color: Color(0xFFD4DADE),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return confirmBusDialog(
                  context: context,
                  busNumber: '075', // bus["busServiceNumber"].toString(),
                  busName:
                      '075 - Pici Unifor', // bus["patternName"].toString(),
                  arrivalTime: '25', // bus["arrivalTime"].toString(),
                  busNumberCharacteristic: busRoutesCharacteristic!,
                );
              },
            );
          },
          child: const Icon(Icons.bus_alert),
        ),
      ),
    );
  }
}