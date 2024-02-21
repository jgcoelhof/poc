import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poc/services/api_service.dart';
import 'package:poc/widgets/dialogs.dart';

class BusListPage extends StatefulWidget {
  const BusListPage({Key? key}) : super(key: key);

  @override
  State<BusListPage> createState() => _BusListPageState();
}

class _BusListPageState extends State<BusListPage> {
  late List<Map<String, dynamic>> busData = [];

  @override
  void initState() {
    super.initState();
    fetchBusData();
  }

  Future<void> fetchBusData() async {
    try {
      final List<dynamic> json = await fetchAPI();
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
        // ignore: unnecessary_null_comparison
        body: busData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
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
          context,
          bus["busServiceNumber"].toString(),
          bus["patternName"].toString(),
          bus["arrivalTime"].toString()
        );
      },
    );
  },
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          8.0), // Ajuste o padding conforme necessário
                                      child: Row(
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
                                          const SizedBox(
                                            width: 55,
                                          ),
                                          Text(
                                            bus["nameLine"]
                                                .split("-")[1]
                                                .trim(),
                                            style: GoogleFonts.roboto(
                                              color: const Color(0xFF132632),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              height: 0.09,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "${bus["arrivalTime"]} min",
                                            style: GoogleFonts.roboto(
                                              color: const Color(0xFF4BA4E3),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              height: 0.09,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
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
                ],
              ),
      ),
    );
  }
}
