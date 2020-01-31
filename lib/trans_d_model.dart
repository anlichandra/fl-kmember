class TransDModel{
  String nama;
  String kuantitas;
  String harga;
  String jumlah;

  TransDModel({ this.nama, this.kuantitas, this.harga, this.jumlah });

  TransDModel.fromJson(Map<String, dynamic> json){
    nama = json['nama'];
    kuantitas = json['kuantitas'];
    harga = json['harga'];
    jumlah = json['jumlah'];
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data;

    data['nama'] = nama;
    data['kuantitas'] = kuantitas;
    data['harga'] = harga;
    data['jumlah'] = jumlah;

    return data;
  }


}