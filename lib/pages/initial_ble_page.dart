import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poc/utils/snackbar.dart';

/// Funcionamento semelhante a BluetoothOffScreen
class InitialBlePage extends StatelessWidget {
  final BluetoothAdapterState? adapterState;
  const InitialBlePage({
    super.key,
    required this.adapterState,
  });

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Color(0xFF5EB4F0), // Color(0xFF49454F),
    );
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState?.toString().split(".").last;
    if (state != null && state == "off") {
      state = "desativado";
    }
    return Text('O adaptador Bluetooth está ${state ?? 'indisponível'}',
        style: Theme.of(context)
            .primaryTextTheme
            .titleSmall
            ?.copyWith(color: const Color(0xFF49454F)));
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        child: const Text(
          'ATIVAR',
          style: TextStyle(color: Color(0xFF4BA4E7)),
        ),
        onPressed: () async {
          try {
            if (Platform.isAndroid) {
              await FlutterBluePlus.turnOn();
            }
          } catch (e) {
            Snackbar.show(ABC.a, prettyException("Error Turning On:", e),
                success: false);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF5EB4F0),
          centerTitle: true,
          title: Text(
            "Talking Map",
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildBluetoothOffIcon(context),
              buildTitle(context),
              if (Platform.isAndroid) buildTurnOnButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
