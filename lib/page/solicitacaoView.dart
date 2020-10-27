import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/hemocentro.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/solicitacaoCadastro.dart';
import 'package:http/http.dart' as http;
import 'package:helplifeandroid/entity/solicitacao.dart';
import 'package:share/share.dart';

const _request = "http://192.168.0.104:9006/api/v1/helplife/solicitacao";

List<dynamic> solicitacoes = new List<dynamic>();
List<Solicitacao> listaSolicitacao = null;

Future getListaSolicitacao() async {
  http.Response response = await http.get(_request);
  solicitacoes = jsonDecode(response.body);
  listaSolicitacao = List<Solicitacao>();
  print(listaSolicitacao.length);
  for (var solicitacao in solicitacoes) {
    Solicitacao _solicitacao = Solicitacao();
    _solicitacao.id = solicitacao["id"];
    _solicitacao.descricao = solicitacao["descricao"];
    _solicitacao.status = solicitacao["status"];
    _solicitacao.dataHora = solicitacao["dataHora"];
    _solicitacao.hemocentro = Hemocentro.fromJson(solicitacao["hemocentro"]);
    _solicitacao.usuario = Usuario.fromJson(solicitacao["usuarioComum"]);
    List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
        solicitacao["tipoSanguineoList"]
            .map((data) => TipoSanguineo.fromJson(data)));
    _solicitacao.tipoSanguineo = tipoSanguineoList;
    if (_solicitacao.status == "STATUS_ATIVA") {
      listaSolicitacao.add(_solicitacao);
    }
  }
}

class SolicitacaoMenu extends StatefulWidget {
  final Usuario user;

  SolicitacaoMenu(this.user);

  @override
  _SolicitacaoMenuState createState() => _SolicitacaoMenuState();
}

class _SolicitacaoMenuState extends State<SolicitacaoMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitação"),
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
                    height: 125,
                    padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                    child: RaisedButton(
                      child: Text(
                        "Listar Solicitações",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SolicitacaoList()));
                      },
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 175,
                    height: 125,
                    padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                    child: RaisedButton(
                      child: Text(
                        "Minhas Solicitações",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MySolicitacao(widget.user)));
                      },
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 175,
                    height: 125,
                    padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                    child: RaisedButton(
                      child: Text(
                        "Criar Solicitação",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SolicitacaoCadastro(widget.user)));
                      },
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MySolicitacao extends StatefulWidget {
  final Usuario user;

  MySolicitacao(this.user);

  @override
  _MySolicitacaoState createState() => _MySolicitacaoState();
}

class _MySolicitacaoState extends State<MySolicitacao> {
  var ativaSolicitacao =
      "http://192.168.0.104:9006/api/v1/helplife/solicitacao/ativa/";
  var desativaSolicitacao =
      "http://192.168.0.104:9006/api/v1/helplife/solicitacao/inativa/";

  Future<void> ativarSolicitacao(int idCampanha) async {
    http.get(ativaSolicitacao + idCampanha.toString(),
        headers: <String, String>{
          'Content-Type': 'application/json',
        }).then((http.Response response) {
      print(response.statusCode);
      if (response.statusCode == 202) {
        _showDialogSuccess();
      } else {
        _showDialogFailed();
      }
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
            title: Text('Solicitação ativada com sucesso!'),
          );
        });
  }

  void _showDialogSuccessTwo() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text('Solicitação desativada com sucesso!'),
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
          title: new Text("Não foi possível ativar a Solicitação!"),
        );
      },
    );
  }

  Future<void> desativarSolicitacao(int idCampanha) async {
    http.get(desativaSolicitacao + idCampanha.toString(),
        headers: <String, String>{
          'Content-Type': 'application/json',
        }).then((http.Response response) {
      print(response.statusCode);
      if (response.statusCode == 202) {
        _showDialogSuccessTwo();
      } else {
        _showDialogFailed();
      }
    });
  }

  List<dynamic> solicitacoesUsuario = new List<dynamic>();
  List<Solicitacao> listaSolicitacaoUsuario = null;

  Future getListaSolicitacaoUsuario() async {
    http.Response response = await http.get(_request);
    solicitacoesUsuario = jsonDecode(response.body);
    listaSolicitacaoUsuario = List<Solicitacao>();
    for (var solicitacao in solicitacoesUsuario) {
      Solicitacao _solicitacao = Solicitacao();
      _solicitacao.id = solicitacao["id"];
      _solicitacao.descricao = solicitacao["descricao"];
      _solicitacao.status = solicitacao["status"];
      _solicitacao.dataHora = solicitacao["dataHora"];
      _solicitacao.hemocentro = Hemocentro.fromJson(solicitacao["hemocentro"]);
      _solicitacao.usuario = Usuario.fromJson(solicitacao["usuarioComum"]);
      List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
          solicitacao["tipoSanguineoList"]
              .map((data) => TipoSanguineo.fromJson(data)));
      _solicitacao.tipoSanguineo = tipoSanguineoList;
      if (_solicitacao.usuario.id == widget.user.id) {
        listaSolicitacaoUsuario.add(_solicitacao);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Solicitação"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder(
          future: getListaSolicitacaoUsuario(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: listaSolicitacaoUsuario.length,
                        itemBuilder: (context, index) {
                          return getItem(listaSolicitacaoUsuario[index]);
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget getItem(Solicitacao solicitacao) {
    if (solicitacao != null) {
      return new Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: Icon(
                  Icons.all_inclusive,
                  size: 40.0,
                ),
                title: Text(
                  solicitacao.descricao,
                ),
              ),
              Row(
                children: <Widget>[
                  ButtonBar(
                    children: <Widget>[
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: const Text('Editar'),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySolicitacaoUpdate(
                                          widget.user, solicitacao.id)));
                            },
                          )
                        ],
                      ),
                      FlatButton(
                        child: const Text('Visualizar'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SolicitacaoSimpleID(solicitacao.id)));
                        },
                      )
                    ],
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Ativar'),
                        onPressed: () {
                          ativarSolicitacao(solicitacao.id);
                        },
                      )
                    ],
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Desativar'),
                        onPressed: () {
                          desativarSolicitacao(solicitacao.id);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

class SolicitacaoList extends StatefulWidget {
  @override
  _SolicitacaoState createState() => _SolicitacaoState();
}

class _SolicitacaoState extends State<SolicitacaoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Lista de Solicitação"),
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder(
          future: getListaSolicitacao(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: listaSolicitacao.length,
                        itemBuilder: (context, index) {
                          return getItem(listaSolicitacao[index]);
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Widget getItem(Solicitacao solicitacao) {
    if (solicitacao != null) {
      return new Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: Icon(
                  Icons.all_inclusive,
                  size: 40.0,
                ),
                title: Text(
                  solicitacao.descricao,
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Visualizar'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SolicitacaoSimpleID(solicitacao.id)));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
}

var _requestTwo = "http://192.168.0.104:9006/api/v1/helplife/usuario";

class SolicitacaoSimpleID extends StatefulWidget {
  final int SolicitacaoID;

  SolicitacaoSimpleID(this.SolicitacaoID);

  @override
  _SolicitacaoSimpleIDState createState() => _SolicitacaoSimpleIDState();
}

Solicitacao solicitacaoID = Solicitacao();
dynamic solicitacaoUnique;

class _SolicitacaoSimpleIDState extends State<SolicitacaoSimpleID> {
  Future getSolicitacaoId(int solicitacaoId) async {
    http.Response response =
        await http.get(_request + '/' + solicitacaoId.toString());
    solicitacaoUnique = (jsonDecode(response.body));
    solicitacaoID.id = solicitacaoUnique["id"];
    solicitacaoID.descricao = solicitacaoUnique["descricao"];
    solicitacaoID.status = solicitacaoUnique["status"];
    solicitacaoID.dataHora = solicitacaoUnique["dataHora"];
    solicitacaoID.hemocentro =
        Hemocentro.fromJson(solicitacaoUnique["hemocentro"]);
    solicitacaoID.usuario = Usuario.fromJson(solicitacaoUnique["usuarioComum"]);
    List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
        solicitacaoUnique["tipoSanguineoList"]
            .map((data) => TipoSanguineo.fromJson(data)));
    solicitacaoID.tipoSanguineo = tipoSanguineoList;
    List<TipoSanguineo> listTP = solicitacaoID.tipoSanguineo;
    preencherDados();
    for (var tp in listTP) {
      preencheTipoSanguineo(tp);
    }
  }

  void preencherDados() {
    descricaoController.text = solicitacaoID.descricao;
    dataHoraController.text = solicitacaoID.dataHora;
    usuarioNomeController.text = solicitacaoID.usuario.nome;
    hemocentroNomeController.text = solicitacaoID.hemocentro.nome;
    hemocentroEnderecoController.text = solicitacaoID.hemocentro.endereco;
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

  TextEditingController nomeController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataHoraController = TextEditingController();
  TextEditingController usuarioNomeController = TextEditingController();
  TextEditingController hemocentroNomeController = TextEditingController();
  TextEditingController hemocentroEnderecoController = TextEditingController();

  void preencheTipoSanguineo(TipoSanguineo tp) {
    if (tp.id == 1) {
      _O1 = true;
    }
    if (tp.id == 2) {
      _O2 = true;
    }
    if (tp.id == 3) {
      _A2 = true;
    }
    if (tp.id == 4) {
      _A1 = true;
    }
    if (tp.id == 5) {
      _B2 = true;
    }
    if (tp.id == 6) {
      _B1 = true;
    }
    if (tp.id == 7) {
      _AB2 = true;
    }
    if (tp.id == 8) {
      _AB1 = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Solicitação"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            color: Colors.red,
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.share('HELP LIFE \n'
                  'Solicitação de Doação de Sangue\n \n'
                  'Descrição: ${solicitacaoID.descricao}\n'
                  'Data: ${solicitacaoID.dataHora}\n'
                  'Criado por: ${solicitacaoID.usuario.nome}\n'
                  'Para ser doado no Hemocentro: ${solicitacaoID.hemocentro.nome}\n'
                  'No endereço: ${solicitacaoID.hemocentro.endereco}\n'
                  '\n'
                  'Ajude a Salvar Vidas !');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getSolicitacaoId(widget.SolicitacaoID),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Form(
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
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Usuário:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: usuarioNomeController,
                      ),
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Hemocentro:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: hemocentroNomeController,
                      ),
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Hemocentro Endereço:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: hemocentroEnderecoController,
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
                                            value: _A1,
                                          )),
                                      Text("A-",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.red)),
                                      new Transform.scale(
                                          scale: 1.5,
                                          child: new Checkbox(
                                            value: _A2,
                                          )),
                                      Text("B+",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.red)),
                                      new Transform.scale(
                                          scale: 1.5,
                                          child: new Checkbox(
                                            value: _B1,
                                          )),
                                      Text("B-",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.red)),
                                      new Transform.scale(
                                          scale: 1.5,
                                          child: new Checkbox(
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
                                            value: _AB1,
                                          )),
                                      Text("AB-",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.red)),
                                      new Transform.scale(
                                          scale: 1.5,
                                          child: new Checkbox(
                                            value: _AB2,
                                          )),
                                      Text("O+",
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.red)),
                                      new Transform.scale(
                                          scale: 1.5,
                                          child: new Checkbox(
                                            value: _O1,
                                          )),
                                      Text("O-",
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.red)),
                                      new Transform.scale(
                                          scale: 1.5,
                                          child: new Checkbox(
                                            value: _O2,
                                          ))
                                    ]),
                              ],
                            )
                          ]),
                    ],
                  ),
                ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

List<dynamic> hemocentroListUpdate = null;
List<Hemocentro> listHemocentroUpdate = List<Hemocentro>();
List<Hemocentro> HemocentroListUpdate = List<Hemocentro>();
int HemocentroIDUpdate = -1;
Hemocentro hemoUpdate = null;
TipoSanguineo tpUpdate = TipoSanguineo();
Solicitacao solicitacaoIDUpdate = Solicitacao();

class MySolicitacaoUpdate extends StatefulWidget {
  final Usuario user;
  final int solicitacaoID;

  MySolicitacaoUpdate(this.user, this.solicitacaoID);

  @override
  _MySolicitacaoUpdateState createState() => _MySolicitacaoUpdateState();
}

class _MySolicitacaoUpdateState extends State<MySolicitacaoUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Solicitações"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: getSolicitacaoIdUpdate(widget.solicitacaoID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SolicitacaoIDSimple(widget.user, widget.solicitacaoID);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

Future getSolicitacaoIdUpdate(int solicitacaoId) async {
  http.Response response = await http.get(_requestTwo);
  hemocentroListUpdate = new List<dynamic>();
  if (listHemocentroUpdate.length <= 0) {
    hemocentroListUpdate = jsonDecode(response.body);
    for (var hemocentro in hemocentroListUpdate) {
      hemoUpdate = Hemocentro();
      int tipoUsuario = hemocentro["tipo"];
      if (tipoUsuario == 1) {
        hemoUpdate = Hemocentro.fromJson(hemocentro);
        listHemocentroUpdate.add(hemoUpdate);
      }
    }
  }
  if (HemocentroListUpdate.length <= listHemocentroUpdate.length) {
    HemocentroListUpdate = listHemocentroUpdate;
  }

  http.Response responseTwo =
      await http.get(_request + '/' + solicitacaoId.toString());
  solicitacaoUnique = (jsonDecode(responseTwo.body));
  solicitacaoIDUpdate.id = solicitacaoUnique["id"];
  solicitacaoIDUpdate.descricao = solicitacaoUnique["descricao"];
  solicitacaoIDUpdate.status = solicitacaoUnique["status"];
  solicitacaoIDUpdate.dataHora = solicitacaoUnique["dataHora"];
  solicitacaoIDUpdate.hemocentro =
      Hemocentro.fromJson(solicitacaoUnique["hemocentro"]);
  solicitacaoID.usuario = Usuario.fromJson(solicitacaoUnique["usuarioComum"]);
  List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
      solicitacaoUnique["tipoSanguineoList"]
          .map((data) => TipoSanguineo.fromJson(data)));
  solicitacaoIDUpdate.tipoSanguineo = tipoSanguineoList;
  List<TipoSanguineo> listTP = solicitacaoIDUpdate.tipoSanguineo;
  preencherDados();
  for (var tp in listTP) {
    preencheTipoSanguineo(tp);
  }
}

void preencheTipoSanguineo(TipoSanguineo tp) {
  if (tp.id == 1) {
    _O1 = true;
  }
  if (tp.id == 2) {
    _O2 = true;
  }
  if (tp.id == 3) {
    _A2 = true;
  }
  if (tp.id == 4) {
    _A1 = true;
  }
  if (tp.id == 5) {
    _B2 = true;
  }
  if (tp.id == 6) {
    _B1 = true;
  }
  if (tp.id == 7) {
    _AB2 = true;
  }
  if (tp.id == 8) {
    _AB1 = true;
  }
}

TextEditingController descricaoController = TextEditingController();
TextEditingController dataHoraController = TextEditingController();

bool _A1 = false;
bool _A2 = false;
bool _B1 = false;
bool _B2 = false;
bool _AB1 = false;
bool _AB2 = false;
bool _O1 = false;
bool _O2 = false;

void preencherDados() {
  descricaoController.text = solicitacaoID.descricao;
  dataHoraController.text = solicitacaoID.dataHora;
}

class SolicitacaoIDSimple extends StatefulWidget {
  final Usuario user;
  final int solicitacaoID;

  SolicitacaoIDSimple(this.user, this.solicitacaoID);

  @override
  _SolicitacaoIDSimpleState createState() => _SolicitacaoIDSimpleState();
}

class _SolicitacaoIDSimpleState extends State<SolicitacaoIDSimple> {
  Future<void> alterarSolicitacao(Solicitacao solicitacao) async {
    var solicitacaoJson = jsonEncode(solicitacao);

    http
        .put(_request + '/' + solicitacao.id.toString(),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: solicitacaoJson)
        .then((http.Response response) {
      print(response.statusCode);
      if (response.statusCode == 202) {
        _showDialogSuccess();
        _resetFields();
      } else if (response.statusCode == 406) {
        _showDialogFailed();
      }
    });
  }

  void _resetFields() {
    setState(() {
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

  void criaListaTipoSanguineoUpdate(List<TipoSanguineo> listTipoSangue) {
    if (_A1 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 4;
      listTipoSangue.add(tpUpdate);
    }
    if (_A2 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 3;
      listTipoSangue.add(tpUpdate);
    }
    if (_B1 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 6;
      listTipoSangue.add(tpUpdate);
    }
    if (_B2 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 5;
      listTipoSangue.add(tpUpdate);
    }
    if (_AB1 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 8;
      listTipoSangue.add(tpUpdate);
    }
    if (_AB2 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 7;
      listTipoSangue.add(tpUpdate);
    }
    if (_O1 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 1;
      listTipoSangue.add(tpUpdate);
    }
    if (_O2 == true) {
      tpUpdate = TipoSanguineo();
      tpUpdate.tipoSangue = "O-";
      tpUpdate.id = 2;
      listTipoSangue.add(tpUpdate);
    }
  }

  void validaCheck() {
    if (_A1 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 4;
    } else if (_A2 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 3;
    } else if (_B1 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 6;
    } else if (_B2 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 5;
    } else if (_AB1 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 8;
    } else if (_AB2 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 7;
    } else if (_O1 == true) {
      tpUpdate.tipoSangue = "O+";
      tpUpdate.id = 1;
    } else if (_O2 == true) {
      tpUpdate.tipoSangue = "O-";
      tpUpdate.id = 2;
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
          title: new Text("Não foi possível efetuar a Alteração!"),
        );
      },
    );
  }

  Hemocentro _selectedHemocentro;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                items: HemocentroListUpdate.map((hemocentro) {
                  return DropdownMenuItem(
                    onTap: () {
                      setState(() {
                        HemocentroIDUpdate = hemocentro.id;
                      });
                    },
                    child: new Text(
                      hemocentro.nome,
                      style: TextStyle(color: Colors.red, fontSize: 25.0),
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
              new Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("A+",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("AB+",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
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
                              style:
                                  TextStyle(fontSize: 30.0, color: Colors.red)),
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
                      solicitacao.id = solicitacaoIDUpdate.id;
                      solicitacao.descricao = descricaoController.text;
                      solicitacao.dataHora = dataHoraController.text;
                      solicitacao.status = solicitacaoIDUpdate.status;
                      Hemocentro hemocentroCampanha = Hemocentro();
                      hemocentroCampanha.id = HemocentroIDUpdate;
                      solicitacao.hemocentro = hemocentroCampanha;
                      solicitacao.usuario = widget.user;

                      List<TipoSanguineo> listTipoSangue =
                          List<TipoSanguineo>();
                      criaListaTipoSanguineoUpdate(listTipoSangue);

                      solicitacao.tipoSanguineo = listTipoSangue;

                      print(solicitacao);
                      if (_formKey.currentState.validate()) {
                        alterarSolicitacao(solicitacao);
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
        ));
  }
}
