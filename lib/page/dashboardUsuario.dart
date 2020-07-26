import 'package:flutter/material.dart';
import 'package:helplifeandroid/entity/usuario.dart';
import 'package:helplifeandroid/page/campanhaView.dart';
import 'package:helplifeandroid/page/perfilUsuario.dart';
import 'package:helplifeandroid/page/solicitacaoView.dart';

class DashboardUsuario extends StatefulWidget {
  final Usuario user;

  DashboardUsuario(this.user);

  @override
  _DashboardUsuarioState createState() => _DashboardUsuarioState();
}

class _DashboardUsuarioState extends State<DashboardUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
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
                        "Perfil",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PerfilUsuario(widget.user)));
                      },
                    ))
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
                        "Campanha",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CampanhaMenu(widget.user)));
                      },
                    ))
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
                        "Solicitação",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SolicitacaoMenu(widget.user)));
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
