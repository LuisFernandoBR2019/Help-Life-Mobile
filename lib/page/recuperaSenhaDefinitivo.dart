import 'dart:convert';

import 'package:helplifeandroid/entity/Formulario.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/dadosLogin.dart';


const _request = "http://192.168.0.104:9006/api/v1/helplife/alterarSenha";

class RecuperaSenhaDefinitivo extends StatefulWidget {
  @override
  _RecuperaSenhaDefinitivoState createState() => _RecuperaSenhaDefinitivoState();
}

class _RecuperaSenhaDefinitivoState extends State<RecuperaSenhaDefinitivo> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController senhaControllerRep = TextEditingController();
  TextEditingController codigoController = TextEditingController();

  Future<String> efetuarAlteracaoSenha(Formulario user) async {
    var userJson = jsonEncode(user);
    http.Response response = await http.post(_request,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: userJson);
    String alteracao = (response.body);
    if (alteracao == "Ok") {
      _showDialogSuccessUsuario();
      _resetFields();
    } else {
      _showDialogFailed();
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = "Informe seus Dados";

  void _resetFields() {
    setState(() {
      emailController.text = "";
      senhaController.text = "";
      senhaControllerRep.text = "";
      codigoController.text = "";
      _infoText = "Informe seus Dados";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _showDialogSuccessUsuario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Center(child: CircularProgressIndicator());

          Future.delayed(Duration(seconds: 3), () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginStart()));
          });
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Alteração efetuada com sucesso!"),
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
          title: new Text("Não foi possível efetuar a alteração!"),
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
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        labelText: "Repita sua Senha:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: senhaControllerRep,
                    validator: (value) {
                      if (value.isEmpty || value.length < 6) {
                        return "Insira sua Senha!";
                      }
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        labelText: "Código informado por email:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: codigoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu código!";
                      }
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    width: 150.0,
                    child: RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Formulario userFormulario = Formulario();
                          userFormulario.email = emailController.text;
                          String senhaRep = senhaControllerRep.text;
                          userFormulario.senha = senhaController.text;
                          if (senhaRep != userFormulario.senha){
                            _showDialogFailed();
                          }else{
                            userFormulario.re_senha = senhaControllerRep.text;
                          }
                          userFormulario.codigo = codigoController.text;
                          efetuarAlteracaoSenha(userFormulario);
                        } else {
                          _showDialogFailed();
                        }
                      },
                      child: Text(
                        "Alterar Senha",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                    ),
                  ),
                  Text(_infoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontSize: 25.0)),
                ],
              ),
            )));
  }
}
