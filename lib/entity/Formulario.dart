class Formulario {
  String email;
  String senha;
  String re_senha;
  String codigo;

  Formulario({
    this.email,
    this.senha,
    this.re_senha,
    this.codigo
  });

  Formulario.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    senha = json['senha'];
    re_senha = json['re_senha'];
    codigo = json['codigo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['re_senha'] = this.re_senha;
    data['codigo'] = this.codigo;

    return data;
  }
}