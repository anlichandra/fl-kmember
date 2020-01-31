class InfoModel{
  String kode;
  String nama;
  String poin;
  String alamat;
  String kelurahan;
  String kecamatan;
  String kota;
  String noTelepon;
  String noHp;
  String tglSinkron;

  InfoModel({this.kode, this.nama, this.poin, this.alamat, this.kelurahan, this.kecamatan, this.kota, this.noTelepon, this.noHp, this.tglSinkron});

  InfoModel.fromJson(Map<String, dynamic> json){
    kode = json['kode'];
    nama = json['nama'];
    poin = json['poin'];
    alamat = json['alamat'];
    kelurahan = json['kelurahan'];
    kecamatan = json['kecamatan'];
    kota = json['kota'];
    noTelepon = json['no_telepon'];
    noHp = json['no_hp'];
    tglSinkron = json['tgl_sinkron'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data;

    data['kode'] = kode;
    data['nama'] = nama;
    data['poin'] = poin;
    data['alamat'] = alamat;
    data['kelurahan'] = kelurahan;
    data['kecamatan'] = kecamatan;
    data['kota'] = kota;
    data['no_telepon'] = noTelepon;
    data['no_hp'] = noHp;
    data['tgl_sinkron'] = tglSinkron;

    return data;
  }

}