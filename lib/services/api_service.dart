import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  try {
    final json = await fetchAPI();
    if (json.isNotEmpty) {
      print(json);
    } else {
      print('A resposta da API está vazia.');
    }
  } catch (e) {
    print('Erro ao buscar dados da API: $e');
  }
}

Future<List<dynamic>> fetchAPI() async {
  var url =
      'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/forecast/lines/fromPoint/106751/281';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    return json;
  } else {
    print('Erro ao acessar a API. Código de status: ${response.statusCode}');
    return [];
  }
}
