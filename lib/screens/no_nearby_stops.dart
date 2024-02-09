import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoNearbyStopPage extends StatelessWidget {
  const NoNearbyStopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFCFF3EC),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icons/street_icon.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 120),
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
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Image.asset(
                  'assets/icons/totem_to_phone_icon.png',
                  width: 250,
                  height: 210,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Text(
                  "Nenhuma parada de\n ônibus detectada.",
                  style: GoogleFonts.roboto(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    height: 1.515,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
