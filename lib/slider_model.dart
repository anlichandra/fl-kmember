class SliderModel{
  String gambar;
  String link;

  SliderModel({this.gambar, this.link});

  SliderModel.fromJson(Map<String, dynamic> json){
    gambar = json['gambar'];
    link = json['link'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['gambar'] = this.gambar;
    data['link'] = this.link;

    return data;
  }

}