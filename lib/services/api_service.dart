import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchBusAPI() async {
          log("chamou");

  var url =
      'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/forecast/lines/fromPoint/106053/281';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    return json;
  } else {
    log('Erro ao acessar a API. Código de status: ${response.statusCode}');
    return [];
  }
}


Future<List<dynamic>> fetchBusStopsAPI() async {
  var url =
      'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/busStop/-3.7420233/-38.53712/281?radiusInMeters=500';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    return json;
  } else {
    log('Erro ao acessar a API. Código de status: ${response.statusCode}');
    return [];
  }
}



