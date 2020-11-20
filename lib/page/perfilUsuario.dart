import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;

var _request = "http://192.168.0.105:9006/api/v1/helplife/usuario/";
var _requestPut = "http://192.168.0.105:9006/api/v1/helplife/";
TipoSanguineo tp = TipoSanguineo();
bool _A1 = false;
bool _A2 = false;
bool _B1 = false;
bool _B2 = false;
bool _AB1 = false;
bool _AB2 = false;
bool _O1 = false;
bool _O2 = false;

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

Usuario usuario = Usuario();

Future getUsuario(String usuarioId) async {
  http.Response response = await http.get(_request + usuarioId);
  usuario = Usuario.fromJson(jsonDecode(response.body));
  preencherDados();
  preencheTipoSanguineo();
}

void preencherDados() {
  nomeController.text = usuario.nome;
  enderecoController.text = usuario.endereco;
  telefoneController.text = usuario.telefone;
  emailController.text = usuario.email;
  senhaController.text = usuario.senha;
  estadoController.text = usuario.estado;
  cidadeController.text = usuario.cidade;
  cepController.text = usuario.cep;
  sexoController.text = usuario.sexo;
  dataNascimentoController.text = usuario.dataNascimento;
}

void preencheTipoSanguineo() {
  tp = usuario.tipoSanguineo;
  if (tp.id == 2) {
    _O1 = true;
  } else if (tp.id == 1) {
    _O2 = true;
  } else if (tp.id == 4) {
    _A2 = true;
  } else if (tp.id == 3) {
    _A1 = true;
  } else if (tp.id == 6) {
    _B2 = true;
  } else if (tp.id == 5) {
    _B1 = true;
  } else if (tp.id == 8) {
    _AB2 = true;
  } else if (tp.id == 7) {
    _AB1 = true;
  }
}

class PerfilUsuario extends StatefulWidget {
  final Usuario user;

  PerfilUsuario(this.user);

  @override
  _PerfilUsuarioState createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Perfil"),
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
        body: FutureBuilder(
          future: getUsuario(widget.user.id.toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Perfil(widget.user);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class Perfil extends StatefulWidget {
  final Usuario user;

  Perfil(this.user);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  void validaCheck() {
    if (_A1 == true) {
      tp.tipoSangue = "A+";
      tp.id = 3;
    } else if (_A2 == true) {
      tp.tipoSangue = "A-";
      tp.id = 4;
    } else if (_B1 == true) {
      tp.tipoSangue = "B+";
      tp.id = 5;
    } else if (_B2 == true) {
      tp.tipoSangue = "B-";
      tp.id = 6;
    } else if (_AB1 == true) {
      tp.tipoSangue = "AB+";
      tp.id = 7;
    } else if (_AB2 == true) {
      tp.tipoSangue = "AB-";
      tp.id = 8;
    } else if (_O1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 1;
    } else if (_O2 == true) {
      tp.tipoSangue = "O-";
      tp.id = 2;
    }
  }

  Future<void> updateUsuarioComum(Usuario user) async {
    var userJson = jsonEncode(user);
    if (user.tipo == 0) {
      http
          .put(_requestPut + "usuariocomum/" + user.id.toString(),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: userJson)
          .then((http.Response response) {
        print(response.statusCode);
        if (response.statusCode == 202) {
          _showDialogSuccess();
        } else if (response.statusCode == 406) {
          _showDialogFailed();
        }
      });
    } else if (user.tipo == 1) {
      http
          .put(_requestPut + "hemocentro/" + user.id.toString(),
              headers: <String, String>{
                'Content-Type': 'application/json',
              },
              body: userJson)
          .then((http.Response response) {
        print(response.statusCode);
        if (response.statusCode == 202) {
          _showDialogSuccess();
        } else if (response.statusCode == 406) {
          _showDialogFailed();
        }
      });
    }
  }

  void _showDialogSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text('Alteração efetuada com sucesso!'),
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
          title: new Text("Não foi possível efetuar a alteração!"),
        );
      },
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: "Celular:",
                      labelStyle: TextStyle(color: Colors.red)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 25.0),
                  controller: telefoneController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return "Insira seu Celular!";
                    }
                  },
                ),
                TextFormField(
                  enabled: false,
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
                  keyboardType: TextInputType.text,
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
                    "Tipo Sanguíneo",
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
                        user.id = widget.user.id;
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
                        user.tipo = widget.user.tipo;
                        if (_formKey.currentState.validate()) {
                          updateUsuarioComum(user);
                          //_resetFields();
                        } else {
                          _showDialogFailed();
                        }
                      },
                      child: Text(
                        "Alterar",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
