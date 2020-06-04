class Campanha {
  int id;
  String descricao;
  String nome;
  String dataInicio;
  String dataFim;
  int status;
  int usuarioId;
  int hemocentroId;

  Campanha({
    this.id,
    this.descricao,
    this.nome,
    this.dataInicio,
    this.dataFim,
    this.status,
    this.usuarioId,
    this.hemocentroId,
  });

  Campanha.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    nome = json['nome'];
    dataInicio = json['dataInicio'];
    dataFim = json['dataFim'];
    status = json['status'];
    usuarioId = json['usuarioId'];
    hemocentroId = json['hemocentroId'];
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
    data['hemocentroId'] = this.hemocentroId;

    return data;
  }
}
