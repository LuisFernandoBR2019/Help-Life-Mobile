import 'package:helplifeandroid/entity/hemocentro.dart';
import 'package:helplifeandroid/entity/tipoSanguineo.dart';
import 'package:helplifeandroid/entity/usuario.dart';

class Campanha {
  int id;
  String descricao;
  String nome;
  String dataInicio;
  String dataFinal;
  String status;
  Usuario usuario;
  Hemocentro hemocentro;
  List<TipoSanguineo> tipoSanguineoList;

  Campanha({
    this.id,
    this.descricao,
    this.nome,
    this.dataInicio,
    this.dataFinal,
    this.hemocentro,
    this.status,
    this.usuario,
    this.tipoSanguineoList,
  });

  Campanha.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    nome = json['nome'];
    dataInicio = json['dataInicio'];
    dataFinal = json['dataFinal'];
    status = json['status'];
    usuario = json['usuario'];
    hemocentro = json['hemocentro'];
    tipoSanguineoList = json['tipoSanguineoList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['nome'] = this.nome;
    data['dataInicio'] = this.dataInicio;
    data['dataFinal'] = this.dataFinal;
    data['status'] = this.status;
    data['usuario'] = this.usuario;
    data['hemocentro'] = this.hemocentro;
    data['tipoSanguineoList'] = this.tipoSanguineoList;

    return data;
  }
}
