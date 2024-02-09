import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingBusPage extends StatefulWidget {
  const WaitingBusPage({super.key});

  @override
  State<WaitingBusPage> createState() => _WaitingBusPageState();
}

class _WaitingBusPageState extends State<WaitingBusPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
            leading: const Icon(Icons.watch_later_rounded,color: Colors.white,),
            backgroundColor: const Color(0xFF5EB4F0),
            centerTitle: true,
            title: Text(
              "Aguardando ônibus",
              style: GoogleFonts.quicksand(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                height: 1.364,
                letterSpacing: 0.0,
                color: Colors.white,
              ),
            )),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              const Text(
                '075',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF4BA4E3),
                  fontSize: 120,
                  fontFamily: 'Saira SemiCondensed',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: Text(
                  "Campus do Pici/Unifor",
                  style: TextStyle(
                    color: Color(0xFF132632),
                    fontSize: 24,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Chega em ',
                      style: TextStyle(
                        color: Color(0xFF132632),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: '1 minuto',
                      style: TextStyle(
                        color: Color(0xFF132632),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/zona_urbana/arvore.png'),
                  const SizedBox(
                    width: 20,
                  ),
                  Image.asset('assets/images/zona_urbana/onibus.png'),
                  const SizedBox(
                    width: 50,
                  ),
                  Image.asset('assets/images/zona_urbana/sinal.png')
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Image.asset('assets/images/zona_urbana/linha.png'),
              const Spacer(),
              Container(
                width: 310,
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
                        'Cancelar',
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
              ),const SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}
