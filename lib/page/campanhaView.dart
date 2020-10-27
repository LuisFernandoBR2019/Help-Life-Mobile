import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/campanha.dart';
import 'package:helplifeandroid/entity/hemocentro.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/campanhaCadastro.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

List<Hemocentro> HemocentroListAtualiza =
    List<Hemocentro>(); //atualiza campanha
int HemocentroIDAtualiza = -1; //atualiza campanha
List<dynamic> hemocentroListAtualiza = null; //atualiza campanha
List<Hemocentro> listHemocentroAtualiza =
    List<Hemocentro>(); //atualiza campanha

const _request = "http://192.168.0.104:9006/api/v1/helplife/campanha";
List<dynamic> campanhas = new List<dynamic>();
List<Campanha> listaCampanha = List<Campanha>();

Future getListaCampanha() async {
  http.Response response = await http.get(_request);
  campanhas = (jsonDecode(response.body));
  listaCampanha = List<Campanha>();

  for (var camp in campanhas) {
    Campanha campanha = Campanha();
    campanha.id = camp["id"];
    campanha.nome = camp["nome"];
    campanha.status = camp["status"];
    campanha.descricao = camp["descricao"];
    campanha.dataInicio = camp["dataInicio"];
    campanha.dataFinal = camp["dataFinal"];
    campanha.hemocentro = Hemocentro.fromJson(camp["hemocentro"]);
    campanha.usuario = Usuario.fromJson(camp["usuario"]);
    List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
        camp["tipoSanguineoList"].map((data) => TipoSanguineo.fromJson(data)));
    campanha.tipoSanguineoList = tipoSanguineoList;
    if (campanha.status == "STATUS_ATIVA") {
      listaCampanha.add(campanha);
    }
  }
}

class CampanhaView extends StatefulWidget {
  final Usuario user;

  CampanhaView(this.user);

  @override
  State<StatefulWidget> createState() {
    return new _CampanhaViewState();
  }
}

class _CampanhaViewState extends State<CampanhaView> {
  Widget getItem(Campanha campanha) {
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
                campanha.nome,
              ),
              subtitle: Text(campanha.descricao),
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
                                CampanhaIdSimple(campanha.id)));
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Lista de Campanhas"),
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder(
          future: getListaCampanha(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: listaCampanha.length,
                        itemBuilder: (context, index) {
                          return getItem(listaCampanha[index]);
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
}

class CampanhaMenu extends StatefulWidget {
  final Usuario user;

  CampanhaMenu(this.user);

  @override
  _CampanhaMenuState createState() => _CampanhaMenuState();
}

class _CampanhaMenuState extends State<CampanhaMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campanha"),
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
                        "Listar Todas",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CampanhaView(widget.user)));
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
                        "Minhas Campanhas",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyCampanha(widget.user)));
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
                        "Criar Campanha",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CampanhaCadastro(widget.user)));
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

class MyCampanha extends StatefulWidget {
  final Usuario user;

  MyCampanha(this.user);

  @override
  _MyCampanhaState createState() => _MyCampanhaState();
}

List<Campanha> listaCampanhaUsuario = List<Campanha>();
List<dynamic> campanhaUsuario = List<dynamic>();

class _MyCampanhaState extends State<MyCampanha> {
  Future getListaCampanhaID() async {
    http.Response response = await http.get(_request);
    campanhaUsuario = (jsonDecode(response.body));
    if (listaCampanhaUsuario.length != 0) {
      listaCampanhaUsuario = List<Campanha>();
    }
    for (var camp in campanhaUsuario) {
      Campanha campanha = Campanha();
      campanha.id = camp["id"];
      campanha.nome = camp["nome"];
      campanha.status = camp["status"];
      campanha.descricao = camp["descricao"];
      campanha.dataInicio = camp["dataInicio"];
      campanha.dataFinal = camp["dataFinal"];
      campanha.hemocentro = Hemocentro.fromJson(camp["hemocentro"]);
      campanha.usuario = Usuario.fromJson(camp["usuario"]);
      List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
          camp["tipoSanguineoList"]
              .map((data) => TipoSanguineo.fromJson(data)));
      campanha.tipoSanguineoList = tipoSanguineoList;
      if (widget.user.tipo == 0 && campanha.usuario.id == widget.user.id) {
        listaCampanhaUsuario.add(campanha);
      } else if (widget.user.tipo == 1 &&
          campanha.usuario.id == widget.user.id) {
        listaCampanhaUsuario.add(campanha);
      }
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
            title: Text('Campanha ativada com sucesso!'),
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
          title: new Text("Não foi possível ativar a campanha!"),
        );
      },
    );
  }

  var ativaCampanha =
      "http://192.168.0.104:9006/api/v1/helplife/campanha/ativa/";
  var desativaCampanha =
      "http://192.168.0.104:9006/api/v1/helplife/campanha/inativa/";

  Future<void> ativarCampanha(int idCampanha) async {
    http.get(ativaCampanha + idCampanha.toString(), headers: <String, String>{
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

  Future<void> desativarCampanha(int idCampanha) async {
    http.get(desativaCampanha + idCampanha.toString(),
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

  void _showDialogSuccessTwo() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(
            title: Text('Campanha desativada com sucesso!'),
          );
        });
  }

  Widget getItem(Campanha campanha) {
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
                campanha.nome,
              ),
              subtitle: Text(campanha.descricao),
            ),
            ButtonBar(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton(
                      child: const Text(
                        'Visualizar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CampanhaIdSimple(campanha.id)));
                      },
                    ),
                    FlatButton(
                      child: const Text('Editar',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => atualizaCampanha(
                                    widget.user, campanha.id)));
                      },
                    ),
                    FlatButton(
                      child: const Text(
                        'Ativar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        ativarCampanha(campanha.id);
                      },
                    ),
                    FlatButton(
                      child: const Text(
                        'Desativar',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        desativarCampanha(campanha.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text("Lista de Campanhas"),
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder(
          future: getListaCampanhaID(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: listaCampanhaUsuario.length,
                        itemBuilder: (context, index) {
                          return getItem(listaCampanhaUsuario[index]);
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
}

Campanha campanha = Campanha();
dynamic campanhaUnique;

Future getCampanhaId(int campanhaId) async {
  http.Response response = await http.get(_requestTwo + campanhaId.toString());
  campanhaUnique = (jsonDecode(response.body));
  campanha.id = campanhaUnique["id"];
  campanha.nome = campanhaUnique["nome"];
  campanha.descricao = campanhaUnique["descricao"];
  campanha.dataInicio = campanhaUnique["dataInicio"];
  campanha.dataFinal = campanhaUnique["dataFinal"];
  campanha.hemocentro = Hemocentro.fromJson(campanhaUnique["hemocentro"]);
  campanha.usuario = Usuario.fromJson(campanhaUnique["usuario"]);
  List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
      campanhaUnique["tipoSanguineoList"]
          .map((data) => TipoSanguineo.fromJson(data)));
  campanha.tipoSanguineoList = tipoSanguineoList;
  List<TipoSanguineo> listTP = campanha.tipoSanguineoList;
  preencherDados();
  for (var tp in listTP) {
    preencheTipoSanguineo(tp);
  }
}

void preencherDados() {
  nomeController.text = campanha.nome;
  descricaoController.text = campanha.descricao;
  dataInicioController.text = campanha.dataInicio;
  dataFimController.text = campanha.dataFinal;
  usuarioNomeController.text = campanha.usuario.nome;
  hemocentroNomeController.text = campanha.hemocentro.nome;
  hemocentroEnderecoController.text = campanha.hemocentro.endereco;
}

class CampanhaIdSimple extends StatefulWidget {
  final int CampanhaID;

  CampanhaIdSimple(this.CampanhaID);

  @override
  _CampanhaIdSimpleState createState() => _CampanhaIdSimpleState();
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

TextEditingController nomeController = TextEditingController();
TextEditingController descricaoController = TextEditingController();
TextEditingController dataInicioController = TextEditingController();
TextEditingController dataFimController = TextEditingController();
TextEditingController usuarioNomeController = TextEditingController();
TextEditingController hemocentroNomeController = TextEditingController();
TextEditingController hemocentroEnderecoController = TextEditingController();

TipoSanguineo tp = TipoSanguineo();
bool _A1 = false;
bool _A2 = false;
bool _B1 = false;
bool _B2 = false;
bool _AB1 = false;
bool _AB2 = false;
bool _O1 = false;
bool _O2 = false;
var _requestTwo = "http://192.168.0.104:9006/api/v1/helplife/campanha/";

class _CampanhaIdSimpleState extends State<CampanhaIdSimple> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campanha"),
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
                  'Campanha de Doação de Sangue\n \n'
                  'Nome: ${campanha.nome}\n'
                  'Descrição: ${campanha.descricao}\n'
                  'Data de inicio: ${campanha.dataInicio}\n'
                  'Data final: ${campanha.dataFinal}\n'
                  'Criado por: ${campanha.usuario.nome}\n'
                  'Para ser doado no Hemocentro: ${campanha.hemocentro.nome}\n'
                  'No endereço: ${campanha.hemocentro.endereco}\n'
                  '\n'
                  'Ajude a Salvar Vidas !');
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getCampanhaId(widget.CampanhaID),
        builder: (BuildContext context, AsyncSnapshot snpashot) {
          if (snpashot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.contact_mail, size: 120.0, color: Colors.red),
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Nome:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: nomeController,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Descrição:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: descricaoController,
                      ),
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Data Inicio:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: dataInicioController,
                      ),
                      TextFormField(
                        enabled: false,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Data Fim:",
                            labelStyle: TextStyle(color: Colors.red)),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red, fontSize: 25.0),
                        controller: dataFimController,
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
                          "Tipo Sanguineo:",
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

bool __A1 = false;
bool __A2 = false;
bool __B1 = false;
bool __B2 = false;
bool __AB1 = false;
bool __AB2 = false;
bool __O1 = false;
bool __O2 = false;
const _requestThree = "http://192.168.0.104:9006/api/v1/helplife/usuario";

class atualizaCampanha extends StatefulWidget {
  final Usuario user;
  final int CampanhaID;

  atualizaCampanha(this.user, this.CampanhaID);

  @override
  _atualizaCampanhaState createState() => _atualizaCampanhaState();
}

void criaListaTipoSanguineoAtualiza(List<TipoSanguineo> listTipoSangue) {
  if (__A1 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 4;
    listTipoSangue.add(tp);
  }
  if (__A2 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 3;
    listTipoSangue.add(tp);
  }
  if (__B1 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 6;
    listTipoSangue.add(tp);
  }
  if (__B2 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 5;
    listTipoSangue.add(tp);
  }
  if (__AB1 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 8;
    listTipoSangue.add(tp);
  }
  if (__AB2 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 7;
    listTipoSangue.add(tp);
  }
  if (__O1 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O+";
    tp.id = 1;
    listTipoSangue.add(tp);
  }
  if (__O2 == true) {
    tp = TipoSanguineo();
    tp.tipoSangue = "O-";
    tp.id = 2;
    listTipoSangue.add(tp);
  }
}

class _atualizaCampanhaState extends State<atualizaCampanha> {
  Future getCampanhaIdAtualiza(int campanhaId) async {
    http.Response response =
        await http.get(_requestTwo + campanhaId.toString());
    campanhaUnique = (jsonDecode(response.body));
    campanha.id = campanhaUnique["id"];
    campanha.nome = campanhaUnique["nome"];
    campanha.descricao = campanhaUnique["descricao"];
    campanha.dataInicio = campanhaUnique["dataInicio"];
    campanha.dataFinal = campanhaUnique["dataFinal"];
    campanha.hemocentro = Hemocentro.fromJson(campanhaUnique["hemocentro"]);
    campanha.usuario = Usuario.fromJson(campanhaUnique["usuario"]);
    List<TipoSanguineo> tipoSanguineoList = List<TipoSanguineo>.from(
        campanhaUnique["tipoSanguineoList"]
            .map((data) => TipoSanguineo.fromJson(data)));
    campanha.tipoSanguineoList = tipoSanguineoList;
    List<TipoSanguineo> listTP = campanha.tipoSanguineoList;
    preencherDadosAtualiza();
    for (var tp in listTP) {
      preencheTipoSanguineoAtualiza(tp);
    }
    getListHemocentroAtualiza();
  }

  Future getListHemocentroAtualiza() async {
    http.Response response = await http.get(_requestThree);
    hemocentroListAtualiza = new List<dynamic>();
    if (listHemocentroAtualiza.length <= 0) {
      hemocentroListAtualiza = jsonDecode(response.body);
      for (var hemocentro in hemocentroListAtualiza) {
        hemo = Hemocentro();
        int tipoUsuario = hemocentro["tipo"];
        if (tipoUsuario == 1) {
          hemo = Hemocentro.fromJson(hemocentro);
          listHemocentroAtualiza.add(hemo);
        }
      }
    }
    if (HemocentroList.length <= listHemocentroAtualiza.length) {
      HemocentroListAtualiza = listHemocentroAtualiza;
    }
  }

  void preencherDadosAtualiza() {
    nomeController.text = campanha.nome;
    descricaoController.text = campanha.descricao;
    dataInicioController.text = campanha.dataInicio;
    dataFimController.text = campanha.dataFinal;
    usuarioNomeController.text = campanha.usuario.nome;
    hemocentroNomeController.text = campanha.hemocentro.nome;
    hemocentroEnderecoController.text = campanha.hemocentro.endereco;
  }

  void preencheTipoSanguineoAtualiza(TipoSanguineo tp) {
    if (tp.id == 1) {
      __O1 = true;
    }
    if (tp.id == 2) {
      __O2 = true;
    }
    if (tp.id == 3) {
      __A2 = true;
    }
    if (tp.id == 4) {
      __A1 = true;
    }
    if (tp.id == 5) {
      __B2 = true;
    }
    if (tp.id == 6) {
      __B1 = true;
    }
    if (tp.id == 7) {
      __AB2 = true;
    }
    if (tp.id == 8) {
      __AB1 = true;
    }
  }

  Campanha campanha = Campanha();
  dynamic campanhaUnique;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Editar Campanha"),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: FutureBuilder(
          future: getCampanhaIdAtualiza(widget.CampanhaID),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Update(widget.user, widget.CampanhaID);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}

class Update extends StatefulWidget {
  final Usuario user;
  final int CampanhaID;

  Update(this.user, this.CampanhaID);

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  void validaCheckAtualiza() {
    if (__A1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 4;
    } else if (__A2 == true) {
      tp.tipoSangue = "O+";
      tp.id = 3;
    } else if (__B1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 6;
    } else if (__B2 == true) {
      tp.tipoSangue = "O+";
      tp.id = 5;
    } else if (__AB1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 8;
    } else if (__AB2 == true) {
      tp.tipoSangue = "O+";
      tp.id = 7;
    } else if (__O1 == true) {
      tp.tipoSangue = "O+";
      tp.id = 1;
    } else if (__O2 == true) {
      tp.tipoSangue = "O-";
      tp.id = 2;
    }
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
          title: new Text("Não foi possível efetuar as alterações!"),
        );
      },
    );
  }

  void _showDialogSuccess() {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyCampanha(widget.user)));
          });
          return AlertDialog(
            title: Text('Edição efetuada com sucesso!'),
          );
        });
  }

  Future<void> AtualizarCampanha(int idCampanha, Campanha campanha) async {
    print('${_request}/${idCampanha}');
    var campanhaJson = jsonEncode(campanha);
    http
        .put(_request + '/' + idCampanha.toString(),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: campanhaJson)
        .then((http.Response response) {
      print(response.statusCode);
      if (response.statusCode == 202) {
        _showDialogSuccess();
        _resetFields();
      } else {
        _showDialogFailed();
      }
    });
  }
  void _resetFields() {
    setState(() {
      nomeController.text = "";
      descricaoController.text = "";
      dataInicioController.text = "";
      dataFimController.text = "";
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
  Hemocentro _selectedHemocentroAtualiza;

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
              Icon(Icons.contact_mail, size: 120.0, color: Colors.red),
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
                    labelText: "Data inicio:",
                    labelStyle: TextStyle(color: Colors.red)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 25.0),
                controller: dataInicioController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira a data de inicio!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    labelText: "Data final:",
                    labelStyle: TextStyle(color: Colors.red)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 25.0),
                controller: dataFimController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira a data final!";
                  }
                },
              ),
              DropdownButton(
                hint: Text(
                  'Escolha um Hemocentro:',
                  style: TextStyle(color: Colors.red, fontSize: 25.0),
                ),
                value: _selectedHemocentroAtualiza,
                onChanged: (newValue) {
                  setState(() {
                    _selectedHemocentroAtualiza = newValue;
                  });
                },
                items: HemocentroListAtualiza.map((hemocentro) {
                  return DropdownMenuItem(
                    onTap: () {
                      setState(() {
                        HemocentroIDAtualiza = hemocentro.id;
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
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
                                    __A1 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __A1,
                              )),
                          Text("A-",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
                          new Transform.scale(
                              scale: 1.5,
                              child: new Checkbox(
                                onChanged: (bool resp) {
                                  setState(() {
                                    __A2 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __A2,
                              )),
                          Text("B+",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
                          new Transform.scale(
                              scale: 1.5,
                              child: new Checkbox(
                                onChanged: (bool resp) {
                                  setState(() {
                                    __B1 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __B1,
                              )),
                          Text("B-",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
                          new Transform.scale(
                              scale: 1.5,
                              child: new Checkbox(
                                onChanged: (bool resp) {
                                  setState(() {
                                    __B2 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __B2,
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
                                    __AB1 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __AB1,
                              )),
                          Text("AB-",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
                          new Transform.scale(
                              scale: 1.5,
                              child: new Checkbox(
                                onChanged: (bool resp) {
                                  setState(() {
                                    __AB2 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __AB2,
                              )),
                          Text("O+",
                              style:
                                  TextStyle(fontSize: 25.0, color: Colors.red)),
                          new Transform.scale(
                              scale: 1.5,
                              child: new Checkbox(
                                onChanged: (bool resp) {
                                  setState(() {
                                    __O1 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __O1,
                              )),
                          Text("O-",
                              style:
                                  TextStyle(fontSize: 30.0, color: Colors.red)),
                          new Transform.scale(
                              scale: 1.5,
                              child: new Checkbox(
                                onChanged: (bool resp) {
                                  setState(() {
                                    __O2 = resp;
                                    validaCheckAtualiza();
                                  });
                                },
                                value: __O2,
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
                      Campanha campanha = Campanha();
                      campanha.nome = nomeController.text;
                      campanha.descricao = descricaoController.text;
                      campanha.dataInicio = dataInicioController.text;
                      campanha.dataFinal = dataFimController.text;
                      campanha.status = "STATUS_ATIVA";
                      Hemocentro hemocentroCampanha = Hemocentro();
                      hemocentroCampanha.id = HemocentroIDAtualiza;
                      if (widget.user.tipo == 1) {
                        campanha.usuario = widget.user;
                        campanha.hemocentro = hemocentroCampanha;
                      } else if (widget.user.tipo == 0) {
                        campanha.usuario = widget.user;
                        campanha.hemocentro = hemocentroCampanha;
                      }

                      List<TipoSanguineo> listTipoSangue =
                          List<TipoSanguineo>();
                      criaListaTipoSanguineoAtualiza(listTipoSangue);

                      campanha.tipoSanguineoList = listTipoSangue;

                      if (_formKey.currentState.validate() &&
                          HemocentroIDAtualiza != -1) {
                        AtualizarCampanha(widget.CampanhaID, campanha);
                        // _resetFields();
                      } else {
                        _showDialogFailed();
                      }
                    },
                    child: Text(
                      "Atualizar",
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
