import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import '../widgets/widget_input.dart';
import '../widgets/widget_button.dart';

class TelaMqtt extends StatefulWidget {
  final String id;

  TelaMqtt(this.id);

  @override
  _TelaMqttState createState() => _TelaMqttState();
}

class _TelaMqttState extends State<TelaMqtt> {

  final txtMensagem = TextEditingController();

  final client = MqttServerClient('test.mosquitto.org', '');

  String pubTopic = "meuTopico/teste";
  String texto = "";

  @override
  void initState() {
    super.initState();
    conectar();
  }

  Future<void> conectar() async {
    client.logging(on: false);
    client.setProtocolV311();
    client.keepAlivePeriod = 20;

    try {
      await client.connect();
    } catch (e) {
      print("Erro: $e");
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print("Conectado ao broker");
      client.subscribe(pubTopic, MqttQos.atLeastOnce);
      ouvirMensagens();
    } else {
      print("Falha na conexão");
    }
  }

  void ouvirMensagens() {
    client.updates!.listen((event) {
      final recMess = event[0].payload as MqttPublishMessage;
      final mensagem = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message);

      setState(() {
        texto += mensagem + "\n";
      });
    });
  }

  void _registrar() {
    final builder = MqttClientPayloadBuilder();
    builder.addString(txtMensagem.text);

    client.publishMessage(
      pubTopic,
      MqttQos.atLeastOnce,
      builder.payload!,
    );

    print("Mensagem enviada");
  }

  void _buscar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MQTT"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          InputTextos(
            "Digite sua mensagem",
            "Informe o texto",
            controller: txtMensagem,
          ),
          Buttons("Enviar mensagem", onPressed: _registrar),
          SizedBox(height: 20),
          Text("Mensagens recebidas:\n$texto"),
        ],
      ),
    );
  }
}