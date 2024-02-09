import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poc/screens/no_nearby_stops.dart';
import 'package:poc/screens/waiting_bus.dart';
import 'package:poc/widgets/dialogs.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({super.key});

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
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
            )),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
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
                      height: 20,
                    ),
                    Container(
                        height: 1, width: 40, color: const Color(0xFFD4DADE)),
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
                      height: 20,
                    ),
                    Container(
                        height: 1, width: 200, color: const Color(0xFFD4DADE)),
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
                      height: 20,
                    ),
                    Container(
                        height: 1, width: 40, color: const Color(0xFFD4DADE)),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => confirmBusDialog(context),
                );
              },
              child: const Text("CONFIRM BUS ALERT"),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => fullNearbyDialog(context),
                );
              },
              child: const Text("FULL NEARBY STOP ALERT"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoNearbyStopPage()),
            );
              },
              child: const Text("NO NEARBY STOPS PAGE"),
            ),ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WaitingBusPage()),
            );
              },
              child: const Text("WAITING BUS PAGE"),
            )
          ],
        ),
      ),
    );
  }
}
