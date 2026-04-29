import 'package:flutter/material.dart';
import 'package:atividadesql/control/controlcliente.dart';
import '../widgets/widget_button.dart';
import '../widgets/widget_input.dart';
import '../widgets/widget_text_custom.dart';
class TelaConsulta extends StatefulWidget {
  @override
  _TelaConsultaState createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  String textoPesquisa = "";
  final _inputPesquisa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultar cliente"),
      ),
      body: _body(),
    );
  }

  _body() {
    return ListView(

      children: [
        Buttons("Pesquisar", onPressed: _pesquisar),
        InputTextos(
            "", "Digite um nome para pesquisa", controller: _inputPesquisa),
        TextosCustom(textoPesquisa, 19, Colors.red)
      ],
    );
  }

  Future _pesquisar() async {
     var control = ControlCliente();
     int index = 0;
     textoPesquisa = "\n";
     List<Map<String, dynamic>> list = await control.queryFind("e");
     list.forEach((element){
       textoPesquisa = textoPesquisa + list[index]['nome'].toString() + "\n";
       index ++;
     });
      setState(() {

      });
  }
}

