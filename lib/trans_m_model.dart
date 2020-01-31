class TransMModel{
  String kode;
  String tanggal;
  String outlet;
  String namaOutlet;
  String jumlah;

  TransMModel({ this.kode, this.tanggal, this.outlet, this.namaOutlet, this.jumlah });

  TransMModel.fromJson(Map<String, dynamic> json){
    kode = json['kode'];
    tanggal = json['tanggal'];
    outlet = json['outlet'];
    namaOutlet = json['nama_outlet'];
    jumlah = json['jumlah'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data;

    data['kode'] = kode;
    data['tanggal'] = tanggal;
    data['outlet']  = outlet;
    data['nama_outlet'] = namaOutlet;
    data['jumlah'] = jumlah;

    return data;
  }
}