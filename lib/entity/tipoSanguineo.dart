class TipoSanguineo {
  int id;
  String tipoSangue;
  List<TipoSanguineo> tipoSanguineoList;
  TipoSanguineo({this.id, this.tipoSangue,this.tipoSanguineoList});


  TipoSanguineo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoSangue = json['tipoSangue'];
    tipoSanguineoList= json['tipoSanguineoList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipoSangue'] = this.tipoSangue;
    data['tipoSanguineoList'] = this.tipoSanguineoList;
    return data;
  }
}