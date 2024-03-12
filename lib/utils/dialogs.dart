import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:poc/pages/waiting_bus_page.dart';
import 'package:poc/utils/snackbar.dart';

Future<bool> onWritePressed(
    String busNumber, BluetoothCharacteristic busNumberCharacteristic) async {
  try {
    await busNumberCharacteristic.write(
      utf8.encode(busNumber),
      withoutResponse: busNumberCharacteristic.properties.writeWithoutResponse,
    );
    Snackbar.show(ABC.c, "Write: Success", success: true);
    if (busNumberCharacteristic.properties.read) {
      List<int> readBusNumberCharResult = await busNumberCharacteristic.read();
      log('readBusNumberCharResult: $readBusNumberCharResult ==> ${String.fromCharCodes(readBusNumberCharResult)}');
    }
    return true;
  } catch (e) {
    Snackbar.show(ABC.c, prettyException("Write Error:", e), success: false);
    return false;
  }
}

Widget confirmBusDialog({
  required BuildContext context,
  required String busNumber,
  required String busName,
  required String arrivalTime,
  required BluetoothCharacteristic busNumberCharacteristic,
}) {
  final int numberOfLines = busName.split('\n').length;
  double additionalHeight = numberOfLines * 20.0;
  const double minDialogHeight = 205.0;
  const double maxDialogHeight = 265.0;
  double dialogHeight = minDialogHeight + additionalHeight;
  dialogHeight =
      dialogHeight > maxDialogHeight ? maxDialogHeight : dialogHeight;

  return AlertDialog(
    content: SingleChildScrollView(
      child: SizedBox(
        width: 310,
        height: dialogHeight,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              busName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF132632),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: 264,
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 8),
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                color: Color(0xFF2F95DF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: TextButton(
                onPressed: () async  {
                  bool writeResult =
                      await onWritePressed(busNumber, busNumberCharacteristic);
                  if (writeResult) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaitingBusPage(
                          busNumber: busNumber,
                          busName: busName,
                          arrivalTime: arrivalTime,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Confirmar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.09,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 264,
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 8),
              clipBehavior: Clip.antiAlias,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Color(0xFF2F95DF)),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Voltar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2F95DF),
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0.09,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    ),
  );
}