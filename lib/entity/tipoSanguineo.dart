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