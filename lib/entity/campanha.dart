import 'package:helplifeandroid/entity/tipoSanguineo.dart';

class Campanha {
  int id;
  String descricao;
  String nome;
  String dataInicio;
  String dataFim;
  String status;
  int usuarioId;
  TipoSanguineo tipoSanguineo;

  Campanha({
    this.id,
    this.descricao,
    this.nome,
    this.dataInicio,
    this.dataFim,
    this.status,
    this.usuarioId,
    this.tipoSanguineo,
  });

  Campanha.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    nome = json['nome'];
    dataInicio = json['dataInicio'];
    dataFim = json['dataFim'];
    status = json['status'];
    usuarioId = json['usuarioId'];
    tipoSanguineo = json['tipoSanguineo'] != null
        ? new TipoSanguineo.fromJson(json['tipoSanguineo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['nome'] = this.nome;
    data['dataInicio'] = this.dataInicio;
    data['dataFim'] = this.dataFim;
    data['status'] = this.status;
    data['usuarioId'] = this.usuarioId;
    if (this.tipoSanguineo != null) {
      data['tipoSanguineo'] = this.tipoSanguineo.toJson();
    }

    return data;
  }
}
