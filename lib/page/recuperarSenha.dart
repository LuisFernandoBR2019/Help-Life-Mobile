import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/login.dart';
import 'package:http/http.dart' as http;

const _request = "http://192.168.0.101:9030/api/v1/helplife/recuperarSenha";

class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  TextEditingController emailController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = "Informe seu Email";

  Future<String> efetuarLogin(Usuario user) async {
    var userJson = jsonEncode(user);
    http.Response response = await http.post(_request,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: userJson);
    return (response.body);
  }

  void _resetFields() {
    setState(() {
      emailController.text = "";
      _infoText = "Informe seus Dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _showDialogSuccessUsuario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginStart()));
        });

        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Email de recuperação de senha enviado!"),
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
          title: new Text(
              "Não foi encontrado seu email\n em nosso banco de dados!"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.email, size: 120.0, color: Colors.red),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Email:",
                          labelStyle: TextStyle(color: Colors.red),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return "Insira seu Email!";
                          }
                        },
                      ),
                      Text(_infoText,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 25.0)),
                      Container(
                        width: 220.0,
                        padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                        child: RaisedButton(
                          onPressed: () async {
                            Usuario userLogin = Usuario();
                            userLogin.email = emailController.text;
                            String resposta = await efetuarLogin(userLogin);
                            print(resposta);
                            if (resposta == 'OK') {
                              _showDialogSuccessUsuario();
                            } else if (resposta == 'NOK') {
                              _showDialogFailed();
                            }
                          },
                          child: Text(
                            "Recuperar",
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          color: Colors.red,
                        ),
                      ),
                    ]))));
  }
}
