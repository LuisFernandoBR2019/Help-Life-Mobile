import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;

var _request = "http://192.168.0.105:9006/api/v1/helplife/usuario/";

var _requestPut = "http://192.168.0.105:9006/api/v1/helplife/";

Usuario usuario = Usuario();

TextEditingController nomeController = TextEditingController();
TextEditingController enderecoController = TextEditingController();
TextEditingController telefoneController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController senhaController = TextEditingController();
TextEditingController estadoController = TextEditingController();
TextEditingController cidadeController = TextEditingController();
TextEditingController cepController = TextEditingController();

Future getUsuario(String usuarioId) async {
  http.Response response = await http.get(_request + usuarioId);
  usuario = await Usuario.fromJson(jsonDecode(response.body));
  preencherDados();
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
}

class PerfilHemocentro extends StatefulWidget {
  final Usuario user;

  PerfilHemocentro(this.user);

  @override
  _PerfilHemocentroState createState() => _PerfilHemocentroState();
}

class _PerfilHemocentroState extends State<PerfilHemocentro> {
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
      _formKey = GlobalKey<FormState>();
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
      _formKey = GlobalKey<FormState>();
    });
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

  Future<void> updateUsuarioHemocentro(Usuario user) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  keyboardType: TextInputType.phone,
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
                        user.id = widget.user.id;
                        user.nome = nomeController.text;
                        user.endereco = enderecoController.text;
                        user.telefone = telefoneController.text;
                        user.email = emailController.text;
                        user.senha = senhaController.text;
                        user.estado = estadoController.text;
                        user.cidade = cidadeController.text;
                        user.cep = cepController.text;
                        user.tipo = widget.user.tipo;
                        print(user);
                        if (_formKey.currentState.validate()) {
                          updateUsuarioHemocentro(user);
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
