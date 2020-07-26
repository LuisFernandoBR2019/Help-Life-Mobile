import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

const _request = "http://192.168.0.100:9030/api/v1/helplife/usuariocomum";

class CadUserPage extends StatefulWidget {
  @override
  _CadUserPage createState() => _CadUserPage();
}

class _CadUserPage extends State<CadUserPage> {
  Future<void> criaUsuarioComum(Usuario user) async {
    var userJson = jsonEncode(user);

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
  TextEditingController sexoController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _infoText = "Informe seus Dados";

  TipoSanguineo tp = TipoSanguineo();
  bool _A1 = false;
  bool _A2 = false;
  bool _B1 = false;
  bool _B2 = false;
  bool _AB1 = false;
  bool _AB2 = false;
  bool _O1 = false;
  bool _O2 = false;

  void validaCheck() {
    if (_A1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 4;
    } else if (_A2 == true) {
      tp.tipoSangue = "O+";
      tp.id = 3;
    } else if (_B1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 6;
    } else if (_B2 == true) {
      tp.tipoSangue = "O+";
      tp.id = 5;
    } else if (_AB1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 8;
    } else if (_AB2 == true) {
      tp.tipoSangue = "O+";
      tp.id = 7;
    } else if (_O1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 1;
    } else if (_O2 == true) {
      tp.tipoSangue = "O-";
      tp.id = 2;
    }
  }

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
      sexoController.text = "";
      dataNascimentoController.text = "";
      _infoText = "Informe seus Dados";
      _formKey = GlobalKey<FormState>();
      _A1 = false;
      _A2 = false;
      _B1 = false;
      _B2 = false;
      _AB1 = false;
      _AB2 = false;
      _O1 = false;
      _O2 = false;
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
          title: Text("Cadastro Usuário"),
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
                  Icon(Icons.child_care, size: 120.0, color: Colors.red),
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
                        labelText: "Telefone:",
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
                        return "Insira sua Senha ou Insira uma senha de pelo menos 06 digitos.";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Estado:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: estadoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira seu Estado!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Cidade:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: cidadeController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira sua Cidade!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Cep:",
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
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Sexo:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: sexoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Selecione seu Sexo!";
                      }
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                        labelText: "Data de Nascimento:",
                        labelStyle: TextStyle(color: Colors.red)),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 25.0),
                    controller: dataNascimentoController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Insira sua Data de Nascimento!";
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                    child: Text(
                      "Escolha seu Tipo Sanguineo",
                      style: TextStyle(color: Colors.red, fontSize: 25.0),
                    ),
                  ),
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("A+",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _A1 = resp;
                                            if (_A1 == true) {
                                              _A2 = false;
                                              _AB1 = false;
                                              _AB2 = false;
                                              _B1 = false;
                                              _B2 = false;
                                              _O1 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _A1,
                                      )),
                                  Text("A-",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _A2 = resp;
                                            if (_A2 == true) {
                                              _A1 = false;
                                              _AB1 = false;
                                              _AB2 = false;
                                              _B1 = false;
                                              _B2 = false;
                                              _O1 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _A2,
                                      )),
                                  Text("B+",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _B1 = resp;
                                            if (_B1 == true) {
                                              _A1 = false;
                                              _AB1 = false;
                                              _AB2 = false;
                                              _A2 = false;
                                              _B2 = false;
                                              _O1 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _B1,
                                      )),
                                  Text("B-",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _B2 = resp;
                                            if (_B2 == true) {
                                              _A1 = false;
                                              _AB1 = false;
                                              _AB2 = false;
                                              _B1 = false;
                                              _A2 = false;
                                              _O1 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _B2,
                                      )),
                                ]),
                            new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("AB+",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _AB1 = resp;
                                            if (_AB1 == true) {
                                              _A1 = false;
                                              _A2 = false;
                                              _AB2 = false;
                                              _B1 = false;
                                              _B2 = false;
                                              _O1 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _AB1,
                                      )),
                                  Text("AB-",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _AB2 = resp;
                                            if (_AB2 == true) {
                                              _A1 = false;
                                              _AB1 = false;
                                              _A2 = false;
                                              _B1 = false;
                                              _B2 = false;
                                              _O1 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _AB2,
                                      )),
                                  Text("O+",
                                      style: TextStyle(
                                          fontSize: 25.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _O1 = resp;
                                            if (_O1 == true) {
                                              _A1 = false;
                                              _AB1 = false;
                                              _AB2 = false;
                                              _B1 = false;
                                              _B2 = false;
                                              _A2 = false;
                                              _O2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _O1,
                                      )),
                                  Text("O-",
                                      style: TextStyle(
                                          fontSize: 30.0, color: Colors.red)),
                                  new Transform.scale(
                                      scale: 1.5,
                                      child: new Checkbox(
                                        onChanged: (bool resp) {
                                          setState(() {
                                            _O2 = resp;
                                            if (_O2 == true) {
                                              _A1 = false;
                                              _AB1 = false;
                                              _AB2 = false;
                                              _B1 = false;
                                              _B2 = false;
                                              _O1 = false;
                                              _A2 = false;
                                            }
                                            validaCheck();
                                          });
                                        },
                                        value: _O2,
                                      ))
                                ]),
                          ],
                        )
                      ]),
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
                          user.sexo = sexoController.text;
                          user.dataNascimento = dataNascimentoController.text;
                          user.tipoSanguineo = tp;
                          if (_formKey.currentState.validate()) {
                            criaUsuarioComum(user);
                            // _showDialogSuccess();
                            _resetFields();
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
