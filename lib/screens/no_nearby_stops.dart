import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoNearbyStop extends StatelessWidget {
  const NoNearbyStop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 255, 237),
        body: Column(
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Text(
                  "PARADA DE   ÔNIBUS ACESSÍVEL",
                  style: GoogleFonts.rubikMonoOne(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Text(
                "Nenhuma parada de\n ônibus detectada.",
                style: GoogleFonts.roboto(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  height:1.515, 
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
