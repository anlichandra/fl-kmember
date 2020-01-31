class PromoQRModel{
  String kode;
  String gambar;
  String judul;
  String keterangan;

  PromoQRModel({this.kode, this.gambar, this.judul, this.keterangan});

  PromoQRModel.fromJson(Map<String, dynamic> data){
    this.kode = data['kode'];
    this.gambar = data['gambar'];
    this.judul = data['judul'];
    this.keterangan = data['keterangan'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['kode'] = kode;
    data['gambar'] = gambar;
    data['judul'] = judul;
    data['keterangan'] = keterangan;

    return data;
  }

}