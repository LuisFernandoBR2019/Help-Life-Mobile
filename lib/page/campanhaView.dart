import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/campanha.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:http/http.dart' as http;

const _request = "http://npdi.ddns.net:9006/api/v1/helplife/campanha";

class ListaCampanhaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new CampanhaView());
  }
}

class CampanhaView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CampanhaViewState();
  }
}

class _CampanhaViewState extends State<CampanhaView> {
  List<dynamic> campanhas = new List<dynamic>();
  List<Campanha> listaCampanha = List<Campanha>();

  //Inicia junto com a widget
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getListaCampanha();
    });
  }

  void getListaCampanha() async {
    http.Response response = await http.get(_request);
    campanhas = jsonDecode(response.body);

    //Esse for Funciona
    /*for (var campanha in campanhas) {
      listaCampanha.add(Campanha.fromJson(campanha));
    }*/
  }

  void adicionaCampanha(Campanha campanha) {
    setState(() {
      listaCampanha.add(campanha);
      getItem(campanha);
    });
  }

  Widget getItem(Campanha campanha) {
    if (campanha.status == "STATUS_ATIVA"){
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
                title: Text(campanha.nome,),
                subtitle: Text(campanha.descricao),
              ),
              ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Visualizar'),
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ()));*/
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    /*return new Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            campanha.nome,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),

        ],
      )
    ]);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Lista de Campanhas"),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () {
                setState(() {
                  getListaCampanha();
                });
              })
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: campanhas.length,
                itemBuilder: (context, index) {
                  return getItem(Campanha.fromJson(campanhas[index]));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
