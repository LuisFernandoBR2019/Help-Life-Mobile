import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helplifeandroid/entity/dadosLogin.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import 'cadastroHemocentro.dart';
import 'cadastroUsuario.dart';
import 'campanhaView.dart';

const _request = "http://npdi.ddns.net:9006/api/v1/helplife/login";

class LoginStart extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginStart> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = "Informe seus Dados";

  void _resetFields() {
    setState(() {
      emailController.text = "";
      senhaController.text = "";
      _infoText = "Informe seus Dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _showDialogSuccessUsuario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CampanhaView()));
        });
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Acesso efetuado com sucesso!"),
        );
      },
    );
  }

  void _showDialogSuccessHemocentro() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CampanhaView()));
        });
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Acesso efetuado com sucesso!"),
        );
      },
    );
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
          title: new Text("Não foi possível efetuar o acesso!"),
        );
      },
    );
  }

  Future<Usuario> efetuarLogin(Login user) async {
    var userJson = jsonEncode(user);
    http.Response response = await http.post(_request,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: userJson);
    return Usuario.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Help Life"),
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
                  Icon(Icons.person_outline, size: 120.0, color: Colors.red),
                  TextFormField(
                    keyboardType: TextInputType.text,
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
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            Login userLogin = Login();
                            userLogin.email = emailController.text;
                            userLogin.senha = senhaController.text;
                            Usuario user = await efetuarLogin(userLogin);
                            setState(() {
                              if (user.nome != null) {
                                String tipoUsuario = user.dataNascimento;
                                _resetFields();
                                if (tipoUsuario != null) {
                                  _showDialogSuccessUsuario();
                                } else {
                                  _showDialogSuccessHemocentro();
                                }
                              } else {
                                _showDialogFailed();
                              }
                            });
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Text(_infoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 25.0)),
                  Padding(
                      padding: EdgeInsets.only(top: 80.0, bottom: 20.0),
                      child: Container(
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            //Página cria Usuario;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CadUserPage()));
                          },
                          child: Text(
                            "Cadastro Usuário",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          color: Colors.red,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Container(
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            //Página cria Usuario;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CadHemoPage()));
                          },
                          child: Text(
                            "Cadastro Hemocentro",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          color: Colors.red,
                        ),
                      )),
                ],
              ),
            )));
  }
}
