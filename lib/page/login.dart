import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helplifeandroid/entity/dadosLogin.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/dashboardHemocentro.dart';
import 'package:helplifeandroid/page/dashboardUsuario.dart';
import 'package:helplifeandroid/page/recuperarSenha.dart';
import 'package:http/http.dart' as http;

import 'cadastroHemocentro.dart';
import 'cadastroUsuario.dart';

const _request = "http://192.168.0.104:9006/api/v1/helplife/login";

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

  Future<void> efetuarLogin(Login user) async {
    var userJson = jsonEncode(user);
    http.Response response = await http.post(_request,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: userJson);
    Usuario usuario = Usuario.fromJson(jsonDecode(response.body));
    if (usuario.id != null) {
      _showDialogSuccessUsuario(usuario.tipo, usuario);
      _resetFields();
    } else {
      _showDialogFailed();
    }
  }

  void _showDialogSuccessUsuario(int tipoUsuario, Usuario user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Center(child: CircularProgressIndicator());
        if (tipoUsuario == 0) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardUsuario(user)));
          });
        }
        if (tipoUsuario == 1) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DashboardHemocentro(user)));
          });
        }
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
        Center(child: CircularProgressIndicator());
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
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person_outline, size: 120.0, color: Colors.red),
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
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    width: 150.0,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Login userLogin = Login();
                          userLogin.email = emailController.text;
                          userLogin.senha = senhaController.text;
                          efetuarLogin(userLogin);
                        } else {
                          _showDialogFailed();
                        }
                      },
                      child: Text(
                        "Acessar",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                    ),
                  ),
                  Text(_infoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 25.0)),
                  Container(
                    width: 220.0,
                    padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                    child: RaisedButton(
                      onPressed: () {
                        //Página cria Usuario;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Cadastro()));
                      },
                      child: Text(
                        "Cadastrar-se",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        //Página cria Usuario;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecuperarSenha()));
                      },
                      child: Text(
                        "Recuperar senha",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            )));
  }
}

class Cadastro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 175,
                    height: 100,
                    padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                    child: RaisedButton(
                      child: Text(
                        "Usuário",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadUserPage()));
                      },
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 175,
                    height: 100,
                    padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                    child: RaisedButton(
                      child: Text(
                        "Hemocentro",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadHemoPage()));
                      },
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
