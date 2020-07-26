import 'package:helplifeandroid/entity/hemocentro.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';

class Solicitacao {
  int id;
  String descricao;
  String dataHora;
  String status;
  Usuario usuario;
  Hemocentro hemocentro;
  List<TipoSanguineo> tipoSanguineo;

  Solicitacao({
    this.id,
    this.descricao,
    this.dataHora,
    this.status,
    this.usuario,
    this.hemocentro,
    this.tipoSanguineo,
  });

  Solicitacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    dataHora = json['dataHora'];
    status = json['status'];
    usuario = json['usuarioComum'];
    hemocentro = json['hemocentro'];
    tipoSanguineo = json['tipoSanguineoList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['dataHora'] = this.dataHora;
    data['status'] = this.status;
    data['usuarioComum'] = this.usuario;
    data['hemocentro'] = this.hemocentro;
    data['tipoSanguineoList'] = this.tipoSanguineo;

    return data;
  }
}
