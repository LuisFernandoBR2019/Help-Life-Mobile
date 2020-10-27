import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/hemocentro.dart';
import 'package:helplifeandroid/entity/solicitacao.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/solicitacaoView.dart';
import 'package:http/http.dart' as http;

const _request = "http://192.168.0.104:9006/api/v1/helplife/solicitacao";

class SolicitacaoCadastro extends StatefulWidget {
  final Usuario user;

  SolicitacaoCadastro(this.user);

  @override
  _SolicitacaoCadastroState createState() => _SolicitacaoCadastroState();
}

List<dynamic> hemocentroList = null;
List<Hemocentro> listHemocentro = List<Hemocentro>();
List<Hemocentro> HemocentroList = List<Hemocentro>();
int HemocentroID = -1;
Hemocentro hemo = null;
const _requestTwo = "http://192.168.0.104:9006/api/v1/helplife/usuario";

class _SolicitacaoCadastroState extends State<SolicitacaoCadastro> {
  Future<void> criarSolicitacao(Solicitacao solicitacao) async {
    var solicitacaoJson = jsonEncode(solicitacao);

    http
        .post(_request,
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: solicitacaoJson)
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

  Future getListHemocentro() async {
    http.Response response = await http.get(_requestTwo);
    hemocentroList = new List<dynamic>();
    if (listHemocentro.length <= 0) {
      hemocentroList = jsonDecode(response.body);
      for (var hemocentro in hemocentroList) {
        hemo = Hemocentro();
        int tipoUsuario = hemocentro["tipo"];
        if (tipoUsuario == 1) {
          hemo = Hemocentro.fromJson(hemocentro);
          listHemocentro.add(hemo);
        }
      }
    }
    if (HemocentroList.length <= listHemocentro.length) {
      HemocentroList = listHemocentro;
    }
  }

  void criaListaTipoSanguineo(List<TipoSanguineo> listTipoSangue) {
    if (_A1 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 4;
      listTipoSangue.add(tp);
    }
    if (_A2 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 3;
      listTipoSangue.add(tp);
    }
    if (_B1 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 6;
      listTipoSangue.add(tp);
    }
    if (_B2 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 5;
      listTipoSangue.add(tp);
    }
    if (_AB1 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 8;
      listTipoSangue.add(tp);
    }
    if (_AB2 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 7;
      listTipoSangue.add(tp);
    }
    if (_O1 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O+";
      tp.id = 1;
      listTipoSangue.add(tp);
    }
    if (_O2 == true) {
      tp = TipoSanguineo();
      tp.tipoSangue = "O-";
      tp.id = 2;
      listTipoSangue.add(tp);
    }
  }

  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataHoraController = TextEditingController();

  void _resetFields() {
    setState(() {
      nomeController.text = "";
      descricaoController.text = "";
      dataHoraController.text = "";
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

  void _showDialogSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MySolicitacao(widget.user)));
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

  Hemocentro _selectedHemocentro;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Solicitação"),
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
          future: getListHemocentro(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.contacts, size: 120.0, color: Colors.red),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Descrição:",
                              labelStyle: TextStyle(color: Colors.red)),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 25.0),
                          controller: descricaoController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Insira a Descrição!";
                            }
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              labelText: "Data:",
                              labelStyle: TextStyle(color: Colors.red)),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 25.0),
                          controller: dataHoraController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Insira a data!";
                            }
                          },
                        ),
                        DropdownButton(
                          hint: Text(
                            'Escolha um Hemocentro:',
                            style: TextStyle(color: Colors.red, fontSize: 25.0),
                          ),
                          value: _selectedHemocentro,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedHemocentro = newValue;
                            });
                          },
                          items: HemocentroList.map((hemocentro) {
                            return DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  HemocentroID = hemocentro.id;
                                });
                              },
                              child: new Text(
                                hemocentro.nome,
                                style: TextStyle(
                                    color: Colors.red, fontSize: 25.0),
                              ),
                              value: hemocentro,
                            );
                          }).toList(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("A+",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _A1 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _A1,
                                            )),
                                        Text("A-",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _A2 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _A2,
                                            )),
                                        Text("B+",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _B1 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _B1,
                                            )),
                                        Text("B-",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _B2 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _B2,
                                            )),
                                      ]),
                                  new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("AB+",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _AB1 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _AB1,
                                            )),
                                        Text("AB-",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _AB2 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _AB2,
                                            )),
                                        Text("O+",
                                            style: TextStyle(
                                                fontSize: 25.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _O1 = resp;
                                                  validaCheck();
                                                });
                                              },
                                              value: _O1,
                                            )),
                                        Text("O-",
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.red)),
                                        new Transform.scale(
                                            scale: 1.5,
                                            child: new Checkbox(
                                              onChanged: (bool resp) {
                                                setState(() {
                                                  _O2 = resp;
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
                                Solicitacao solicitacao = Solicitacao();
                                solicitacao.descricao =
                                    descricaoController.text;
                                solicitacao.dataHora = dataHoraController.text;
                                solicitacao.status = "STATUS_ATIVA";
                                Hemocentro hemocentroCampanha = Hemocentro();
                                hemocentroCampanha.id = HemocentroID;
                                solicitacao.hemocentro = hemocentroCampanha;
                                solicitacao.usuario = widget.user;

                                List<TipoSanguineo> listTipoSangue =
                                    List<TipoSanguineo>();
                                criaListaTipoSanguineo(listTipoSangue);

                                solicitacao.tipoSanguineo = listTipoSangue;

                                print(solicitacao);
                                if (_formKey.currentState.validate()) {
                                  criarSolicitacao(solicitacao);
                                } else {
                                  _showDialogFailed();
                                }
                              },
                              child: Text(
                                "Cadastrar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25.0),
                              ),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
