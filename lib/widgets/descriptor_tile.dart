import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:poc/pages/waiting_bus.dart';

import "../utils/snackbar.dart";

// Função para buscar os dados da API
Future<List<int>> fetchBusDataForBluetooth() async {
  var url = 'https://zn4.m2mcontrol.com.br/api//forecast/lines/load/forecast/lines/fromPoint/106751/281';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    // Extrair os dados relevantes da API para enviar via Bluetooth
    List<int> dataForBluetooth = [];
    // Exemplo: Vamos supor que você deseja enviar o número de ônibus
    String busNumber = jsonData['busNumber'];
    // Converter o número de ônibus para bytes para enviar via Bluetooth
    dataForBluetooth.addAll(utf8.encode(busNumber));
    return dataForBluetooth;
  } else {
    log('Erro ao acessar a API. Código de status: ${response.statusCode}');
    throw Exception('Erro ao acessar a API');
  }
}

class DescriptorTile extends StatefulWidget {
  final BluetoothDescriptor descriptor;

  const DescriptorTile({Key? key, required this.descriptor}) : super(key: key);

  @override
  State<DescriptorTile> createState() => _DescriptorTileState();
}

class _DescriptorTileState extends State<DescriptorTile> {
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.descriptor.lastValueStream.listen((value) {
      _value = value;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothDescriptor get d => widget.descriptor;

  Future onReadPressed() async {
    try {
      await d.read();
      Snackbar.show(ABC.c, "Descriptor Read : Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Descriptor Read Error:", e), success: false);
    }
  }

Future onWritePressed() async {
  try {
    // Obter os dados da API para enviar via Bluetooth
    Map<String, dynamic>? apiData = await fetchBusData();
    
    // Verificar se os dados da API são válidos
    if (apiData == null || apiData.isEmpty) {
      print('Dados da API não estão disponíveis ou a lista está vazia.');
      Snackbar.show(ABC.c, "API data is not available or the list is empty", success: false);
      return;
    }
    
    // Transformar os dados em uma lista de bytes para escrever no Bluetooth
    List<int> dataForBluetooth = utf8.encode(jsonEncode(apiData));
    
    // Escrever os dados no dispositivo Bluetooth
    await d.write(dataForBluetooth);
    
    // Exibir uma mensagem de sucesso
    Snackbar.show(ABC.c, "Descriptor Write : Success", success: true);
  } catch (e) {
    // Lidar com erros
    Snackbar.show(ABC.c, prettyException("Descriptor Write Error:", e), success: false);
  }
}


  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.descriptor.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      onPressed: onReadPressed,
      child: const Text("Read"),
    );
  }

  Widget buildWriteButton(BuildContext context) {
    return TextButton(
      onPressed: onWritePressed,
      child: const Text("ESCREVER"),
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildReadButton(context),
        buildWriteButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          buildUuid(context),
          buildValue(context),
        ],
      ),
      subtitle: buildButtonRow(context),
    );
  }
}
