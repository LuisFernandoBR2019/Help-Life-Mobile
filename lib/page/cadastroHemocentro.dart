import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';

const _request = "http://192.168.0.105:9006/api/v1/helplife/hemocentro";

class CadHemoPage extends StatefulWidget {
  @override
  _CadHemoPageState createState() => _CadHemoPageState();
}

class _CadHemoPageState extends State<CadHemoPage> {
  Future<void> criaUsuarioHemocentro(Usuario user) async {
    var userJson = jsonEncode(user);
    print(userJson);
    http
        .post(_request,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: userJson)
        .then((http.Response response) {
      print(response.statusCode);
      if (response.statusCode == 201) {
        _showDialogSuccess();
        _resetFields();
      } else if (response.statusCode == 406) {
        _showDialogFailed();
      }
    });
  }

  TextEditingController nomeController = TextEditingController();
  TextEditingController enderecoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController cepController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = "Informe seus Dados";

  void _resetFields() {
    setState(() {
      emailController.text = "";
      senhaController.text = "";
      estadoController.text = "";
      cidadeController.text = "";
      cepController.text = "";
      nomeController.text = "";
      enderecoController.text = "";
      telefoneController.text = "";
      _infoText = "Informe seus Dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _showDialogSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginStart()));
          });
          return AlertDialog(
            title: Text('Cadastro efetuado com sucesso!'),
          );
        });
  }

  void _showDialogFailed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Não foi possível efetuar o Cadastro!"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro Hemocentro"),
          centerTitle: true,
          backgroundColor: Colors.red,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(Icons.location_city, size: 120.0, color: Colors.red),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Nome:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: nomeController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu Nome!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Endereço:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: enderecoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu Endereço!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Número de Telefone:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: telefoneController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return "Insira seu Telefone!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: emailController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return "Insira seu Email!";
                      }
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        labelText: "Senha:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: senhaController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return "Insira sua Senha!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Unidade de Federação:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: estadoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira sua Unidade de Federação!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Município:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: cidadeController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu Município!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "CEP:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: cepController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu CEP!";
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50.0, bottom: 50.0),
                    child: Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () async {
                          Usuario user = Usuario();
                          user.nome = nomeController.text;
                          user.endereco = enderecoController.text;
                          user.telefone = telefoneController.text;
                          user.email = emailController.text;
                          user.senha = senhaController.text;
                          user.estado = estadoController.text;
                          user.cidade = cidadeController.text;
                          user.cep = cepController.text;
                          print(user);
                          if (_formKey.currentState.validate()) {
                            criaUsuarioHemocentro(user);

                            MaterialPageRoute(
                                builder: (context) => LoginStart());
                          } else {
                            _showDialogFailed();
                          }
                        },
                        child: Text(
                          "Cadastrar",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
