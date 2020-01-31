class PromoModel{
  String kode;
  String nama;
  String gambar;
  String harga;
  String hargaRegular;
  String outlet;
  String keterangan;

  PromoModel({this.kode, this.nama, this.gambar, this.harga, this.hargaRegular, this.outlet, this.keterangan});

  PromoModel.fromJson(Map<String, dynamic> data){
    kode = data['kode'];
    nama = data['nama'];
    gambar = data['gambar'];
    harga = data['harga'];
    hargaRegular = data['harga_regular'];
    outlet = data['outlet'];
    keterangan = data['keterangan'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['kode'] = this.kode;
    data['nama'] = this.nama;
    data['gambar'] = this.gambar;
    data['harga'] = this.harga;
    data['harga_regular'] = this.hargaRegular;
    data['outlet'] = this.outlet;
    data['keterangan'] = this.keterangan;

    return data;
  }


}