class Solicitacao {
  int id;
  String descricao;
  String dataHora;
  int status;
  int usuarioId;
  int hemocentroId;

  Solicitacao({
    this.id,
    this.descricao,
    this.dataHora,
    this.status,
    this.usuarioId,
    this.hemocentroId,
  });

  Solicitacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    dataHora = json['dataHora'];
    status = json['status'];
    usuarioId = json['usuarioId'];
    hemocentroId = json['hemocentroId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['dataHora'] = this.dataHora;
    data['status'] = this.status;
    data['usuarioId'] = this.usuarioId;
    data['hemocentroId'] = this.hemocentroId;

    return data;
  }
}
