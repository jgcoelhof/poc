import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({Key? key}) : super(key: key);

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  final List<Map<String, dynamic>> busData = [
    {"busServiceNumber": 29, "nameLine": "Parangaba/Naútico", "arrivalTime": 3},
    {
      "busServiceNumber": 30,
      "nameLine": "Siqueira/Papicu/13 de Maio",
      "arrivalTime": 10
    },
    // Adicione mais dados conforme necessário
  ];

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
        body: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Icon(
                  Icons.directions_bus,
                  size: 24,
                  color: Colors.black,
                ),
                Image.asset(
                  'assets/icons/line_start_icon.png',
                  width: 24,
                  height: 24,
                ),
                const Icon(
                  Icons.access_time_filled_rounded,
                  size: 24,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: busData.length,
                    itemBuilder: (context, index) {
                      final bus = busData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${bus["busServiceNumber"]}',
                              style: GoogleFonts.roboto(
                                color: const Color(0xFF4BA4E3),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                height: 0.09,
                              ),
                            ),
                            Text(
                              bus["nameLine"],
                              style: GoogleFonts.roboto(
                                color: Color(0xFF132632),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0.09,
                              ),
                            ),
                            Text(
                              "${bus["arrivalTime"]} min",
                              style: GoogleFonts.roboto(
                                color: Color(0xFF4BA4E3),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 0.09,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
