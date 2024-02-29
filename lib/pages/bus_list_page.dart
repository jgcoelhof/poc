import 'dart:async';
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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchBusData();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) => fetchBusData());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                                          context,
                                          bus["busServiceNumber"].toString(),
                                          bus["patternName"].toString(),
                                          bus["arrivalTime"].toString(),
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
      ),
    );
  }
}
