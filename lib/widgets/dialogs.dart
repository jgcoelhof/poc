import 'package:flutter/material.dart';
import 'package:poc/pages/waiting_bus.dart';

Widget confirmBusDialog(BuildContext context, String busNumber, String busName, String arrivalTime) {
  final int numberOfLines = busName.split('\n').length;
  double additionalHeight = numberOfLines * 20.0;
  const double minDialogHeight = 205.0;
  const double maxDialogHeight = 265.0;
  double dialogHeight = minDialogHeight + additionalHeight;
  dialogHeight = dialogHeight > maxDialogHeight ? maxDialogHeight : dialogHeight;

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
                onPressed: () {
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



Widget fullNearbyDialog(BuildContext context) {
  return AlertDialog(
    content: SingleChildScrollView(
      child: SizedBox(
        width: 310,
        height: 160,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Parada cheia.\nTente Novamente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF132632),
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Container(
              width: 264,
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'OK',
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
          ],
        ),
      ),
    ),
  );
}
