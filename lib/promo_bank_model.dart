class PromoBankModel{
  String kode;
  String gambar;
  String judul;
  String keterangan;

  PromoBankModel({this.kode, this.gambar, this.judul, this.keterangan});

  PromoBankModel.fromJson(Map<String, dynamic> data){
    kode = data['kode'];
    gambar = data['gambar'];
    judul = data['judul'];
    keterangan = data['keterangan'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();

    data['kode'] = this.kode;
    data['gambar'] = this.gambar;
    data['judul'] = this.judul;
    data['keterangan'] = this.keterangan;

    return data;
  }



}