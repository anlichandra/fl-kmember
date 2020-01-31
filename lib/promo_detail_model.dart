class PromoDetailModel{
  String artikel;
  String nama;
  String hargaRegular;
  String harga;
  String gambar;
  String sk;
  String periode;
  String tipe;
  String outlet;

  PromoDetailModel({this.artikel, this.nama, this.hargaRegular, this.harga, this.gambar, this.sk, this.periode, this.tipe, this.outlet});

  PromoDetailModel.fromJson(Map<String, dynamic> data){
    artikel = data['artikel'];
    nama = data['nama'];
    hargaRegular = data['harga_regular'];
    harga = data['harga'];
    gambar = data['gambar'];
    sk = data['SK'];
    periode = data['periode'];
    tipe = data['tipe'];
    outlet = data['outlet'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['artikel'] = this.artikel;
    data['nama'] = this.nama;
    data['harga_regular'] = this.hargaRegular;
    data['harga'] = this.harga;
    data['gambar'] = this.gambar;
    data['SK'] = this.sk;
    data['periode'] = this.periode;
    data['tipe'] = this.tipe;
    data['outlet'] = this.outlet;

    return data;
  }
}