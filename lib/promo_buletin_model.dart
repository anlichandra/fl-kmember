class PromoBuletinModel{
  String keterangan;
  String kode;
  String gambar;
  String gambarThumb;

  PromoBuletinModel({this.keterangan, this.kode, this.gambar, this.gambarThumb});

  PromoBuletinModel.fromJson(Map<String, dynamic> data){
    keterangan = data['keterangan'];
    kode = data['kode'];
    gambar = data['gambar'];
    gambarThumb = data['gambar_thumb'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['keterangan'] = this.keterangan;
    data['kode'] = this.kode;
    data['gambar'] = this.gambar;
    data['gambar_thumb'] = this.gambarThumb;

    return data;
  }
}