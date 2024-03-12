import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:poc/main.dart';
import 'package:poc/utils/snackbar.dart';
import 'package:poc/utils/utils.dart';

final Map<DeviceIdentifier, StreamControllerReemit<bool>> _dglobal = {};

extension Extra on BluetoothDevice {
  Future<void> disconnectAndUpdateStream({bool queue = true}) async {
    _dstream.add(true);
    try {
      await disconnect(queue: queue);
    } finally {
      _dstream.add(false);
    }
  }

  StreamControllerReemit<bool> get _dstream {
    _dglobal[remoteId] ??= StreamControllerReemit(initialValue: false);
    return _dglobal[remoteId]!;
  }
}

Future<void> onDisconnectPressed(BluetoothDevice device) async {
  try {
    await device.disconnectAndUpdateStream();
    Snackbar.show(ABC.c, "Disconnect: Success", success: true);
  } catch (e) {
    Snackbar.show(ABC.c, prettyException("Disconnect Error:", e),
        success: false);
  }
}

Future<Map<String, dynamic>?> fetchBusData() async {
  var url =
      'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/forecast/lines/fromPoint/106751/281';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    log('API response: $json');

    if (json is List && json.isNotEmpty) {
      var firstBus = json[0];
      return {
        'busNumber': firstBus['busServiceNumber'] ?? '',
        'arrivalTime': firstBus['arrivalTime'] ?? '',
        'busName': firstBus['patternName'] ?? '',
      };
    }
  } else {
    log('Erro ao acessar a API. Código de status: ${response.statusCode}');
  }
  return null;
}

class WaitingBusPage extends StatefulWidget {
  final String busNumber;
  final String busName;
  final String arrivalTime;

  const WaitingBusPage({
    Key? key,
    required this.busNumber,
    required this.busName,
    required this.arrivalTime,
  }) : super(key: key);

  @override
  State<WaitingBusPage> createState() => _WaitingBusPageState();
}

class _WaitingBusPageState extends State<WaitingBusPage> {
  late String busNumber;
  late String busName;
  late String arrivalTime;
  late BluetoothDevice systemDevices;

  @override
  void initState() {
    super.initState();
    log('initState_WaitingBusPage');
    busNumber = widget.busNumber;
    busName = widget.busName;
    arrivalTime = widget.arrivalTime;
    List<BluetoothDevice> connectedDevices = FlutterBluePlus.connectedDevices;
    for (var connectedDevice in connectedDevices) {
      log('connectedDevice: $connectedDevice');
      systemDevices = connectedDevice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.watch_later_rounded,
            color: Colors.white,
          ),
          backgroundColor: const Color(0xFF5EB4F0),
          centerTitle: true,
          title: Text(
            "Aguardando ônibus",
            style: GoogleFonts.quicksand(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              height: 1.364,
              letterSpacing: 0.0,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              Text(
                busNumber,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4BA4E3),
                  fontSize: 120,
                  fontFamily: 'Saira SemiCondensed',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Center(
                  child: Text(
                    busName.split("-")[1].trim(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF132632),
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Chega em ',
                      style: TextStyle(
                        color: Color(0xFF132632),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: arrivalTime,
                      style: const TextStyle(
                        color: Color(0xFF132632),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: arrivalTime == '1' ? ' minuto' : ' minutos',
                      style: const TextStyle(
                        color: Color(0xFF132632),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/zona_urbana/arvore.png'),
                  const SizedBox(
                    width: 20,
                  ),
                  Image.asset('assets/images/zona_urbana/onibus.png'),
                  const SizedBox(
                    width: 50,
                  ),
                  Image.asset('assets/images/zona_urbana/sinal.png')
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Image.asset('assets/images/zona_urbana/linha.png'),
              const Spacer(),
              Container(
                width: 310,
                height: 40,
                padding: const EdgeInsets.symmetric(vertical: 8),
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFF2F95DF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    await onDisconnectPressed(systemDevices);
                    if (mounted) {
                      // Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const FlutterBlueApp() /* ScanByStopsPage() */),
                          (route) => false);
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Cancelar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 0.09,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
