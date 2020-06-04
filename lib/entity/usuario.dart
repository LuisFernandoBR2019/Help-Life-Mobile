class Usuario {
  int id;
  String nome;
  String endereco;
  String telefone;
  String email;
  String senha;
  String estado;
  String cidade;
  String cep;
  String status;
  TipoSanguineo tipoSanguineo;
  String sexo;
  String dataNascimento;

  Usuario(
      {this.id,
      this.nome,
      this.endereco,
      this.telefone,
      this.email,
      this.senha,
      this.estado,
      this.cidade,
      this.cep,
      this.status,
      this.tipoSanguineo,
      this.sexo,
      this.dataNascimento});

  Usuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    endereco = json['endereco'];
    telefone = json['telefone'];
    email = json['email'];
    senha = json['senha'];
    estado = json['estado'];
    cidade = json['cidade'];
    cep = json['cep'];
    status = json['status'];
    tipoSanguineo = json['tipoSanguineo'] != null
        ? new TipoSanguineo.fromJson(json['tipoSanguineo'])
        : null;
    sexo = json['sexo'];
    dataNascimento = json['dataNascimento'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['endereco'] = this.endereco;
    data['telefone'] = this.telefone;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['estado'] = this.estado;
    data['cidade'] = this.cidade;
    data['cep'] = this.cep;
    data['status'] = this.status;
    if (this.tipoSanguineo != null) {
      data['tipoSanguineo'] = this.tipoSanguineo.toJson();
    }
    data['sexo'] = this.sexo;
    data['dataNascimento'] = this.dataNascimento;
    return data;
  }

  @override
  String toString() {
    return '$id | $nome | $endereco | $telefone | $email | $senha | $estado | $cidade | $cep | $status | $cep | $tipoSanguineo | $sexo | $dataNascimento';
  }
}

class TipoSanguineo {
  int id;
  String tipoSangue;

  TipoSanguineo({this.id, this.tipoSangue});

  TipoSanguineo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoSangue = json['tipoSangue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipoSangue'] = this.tipoSangue;
    return data;
  }
}
