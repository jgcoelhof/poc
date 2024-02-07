import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BusList extends StatefulWidget {
  const BusList({super.key});

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: kToolbarHeight,
              color: const Color(0xFF5EB4F0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                  SizedBox(
                      width:
                          8), // Adiciona um espaçamento entre o ícone e o texto
                  Expanded(
                    child: Text(
                      "Get da API",
                      style: GoogleFonts.quicksand(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        height: 1.364,
                        letterSpacing: 0.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center, // Centraliza o texto na Row
                    ),
                  ),
                ],
              ),
            ),
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
                    const Icon(
                      Icons.access_time_filled_rounded,
                      size: 24,
                      color: Colors.black,
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
              ],
            ),
   
          ],
        ),
      ),
    );
  }
}