import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';

import 'package:kasimura_member2/Constants.dart';
import 'package:kasimura_member2/info_model.dart';
import 'package:kasimura_member2/trans_m_model.dart';
import 'package:kasimura_member2/trans_detail.dart';
import 'package:kasimura_member2/ubah_data.dart';

class InfoPage extends StatefulWidget{
  InfoPage({Key key, this.title});

  final String title;
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage>{
  InfoModel info = new InfoModel();
  List<TransMModel> lstTransM = new List<TransMModel>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInfo());
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      /*appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),*/
      body:
        SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _onRefresh,
          header: WaterDropHeader(),
          child: ListView(
            children: <Widget>
            [
              info.nama==null ?
              Container() :
              Stack(
                children: <Widget>[
                  ClipPath(
                      clipper: CustomShapeClipper(),
                      child: Container(
                        height: 350,
                        decoration: BoxDecoration(color: Color(0xff29166f)),
                      )
                  ),
                  Column(
                      children: <Widget>[
                        SizedBox(height: 18.0),
                        Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: (){ Navigator.pop(context); },
                              ),
                            ]
                        ),
                        Text(info.nama,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900
                            )
                        ),
                        Text(info.kode,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        InkWell(
                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) =>  UbahDataPage()));},


                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children : <Widget>[
                                Text(
                                    'Permintaan perubahan data ',
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.0,
                                    )
                                ),
                                Icon(Icons.navigate_next,
                                  color: Colors.lightBlue,
                                ),
                              ]
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:30.0, right:35.0, left:35.0),
                          child:Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0.0, 3.0),
                                      blurRadius: 15.0
                                  )
                                ]
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(info.poin,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff29166f),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30.0
                                      )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left:20.0),
                                    child: Text('Poin',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xff29166f),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0
                                      ),
                                    ),
                                  )
                                ]
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 25.0, left: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text('Alamat : ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text(info.alamat,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color(0xff29166f),
                                          fontFamily: 'Montserrat'
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text('Kelurahan : ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text(info.kelurahan,
                                      style: TextStyle(
                                          color: Color(0xff29166f),
                                          fontFamily: 'Montserrat'
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text('Kecamatan : ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text(info.kecamatan,
                                      style: TextStyle(
                                          color: Color(0xff29166f),
                                          fontFamily: 'Montserrat'
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text('Kota : ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text(info.kota,
                                      style: TextStyle(
                                          color: Color(0xff29166f),
                                          fontFamily: 'Montserrat'
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text('No. Telepon : ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text(info.noTelepon,
                                      style: TextStyle(
                                          color: Color(0xff29166f),
                                          fontFamily: 'Montserrat'
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text('No. HP : ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16.0
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                            child: Row(
                                children: <Widget>[
                                  Text(info.noHp,
                                      style: TextStyle(
                                          color: Color(0xff29166f),
                                          fontFamily: 'Montserrat'
                                      )
                                  )
                                ]
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Transaksi ',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Color(0xff29166f),
                                      fontFamily: 'Montserrat'
                                  )
                              ),
                              Text('Terakhir',
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      color: Color(0xff29166f),
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Montserrat'
                                  )
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left:10.0, right: 10.0),
                            child: Column(
                              children:
                              lstTransM.map((x) =>
                                  InkWell(
                                    onTap: (){ _loadTrans(x.kode, x.outlet); },
                                    child:
                                      Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(x.namaOutlet,
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        color: Color(0xff29166f)
                                                    )
                                                ),
                                                Text('Rp. ' + x.jumlah,
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color(0xff29166f),
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                )
                                              ],
                                            ),
                                            subtitle: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(x.kode.trimRight(),
                                                      style: TextStyle(
                                                          fontFamily: 'Montserrat'
                                                      )
                                                  ),
                                                  Text(' - '),
                                                  Text(x.tanggal.trimRight(),
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat'
                                                    ),
                                                  ),
                                                ]
                                            ),
                                            trailing: Icon(Icons.navigate_next,
                                              color: Colors.grey,
                                              size: 30.0,
                                            ),
                                          ),
                                          Divider(),
                                        ]
                                      )
                                  )
                              ).toList(),
                            )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 15.0),
                          child: Row(
                              children: <Widget>[
                                Text('Sinkronisasi Terakhir : ' + info.tglSinkron,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic
                                    )
                                )
                              ]
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.warning,
                                            color: Colors.white,
                                          ),
                                          Text(' Perhatian',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w900
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text('Poin dan Transaksi Terakhir mungkin bukan merupakan data terbaru, memerlukan beberapa saat untuk sinkronisasi data.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontSize: 10.0
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            )
                        )
                      ]
                  ),
                ],
              ),
            ],
        ),
      ),
    );
  }

  void _onRefresh(){
    _loadInfo();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _loadInfo() async{
    Response response;

    info = new InfoModel();
    lstTransM = new List<TransMModel>();

    //print(promoDetail.nama);

    SharedPreferences _pref = await SharedPreferences.getInstance();
    String kode = _pref.getString('kode');
    try{
      response = await post(
        Constants.server + '/api/load_info',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'kode_member': kode},
        encoding: Encoding.getByName('utf-8'),
      ).timeout(new Duration(seconds: 10));
    }catch(TimeoutException){
      final snackBar = SnackBar(
          content: Text('Tidak ada respon dari Server!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
              )
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1){
      info = InfoModel.fromJson(data);

      if(data['trans']!=null)
        lstTransM = List<TransMModel>.from(data['trans'].map((x) => TransMModel.fromJson(x)));

      setState(() {});
    }
    else{
      Navigator.pop(context);
    }

    //setState(() {});
  }

  void _loadTrans(String kode, String outlet) async{
    Response response;

    try{
      response = await post(
        Constants.server + '/api/load_transaksi',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'kode': kode, 'outlet': outlet},
        encoding: Encoding.getByName('utf-8'),
      ).timeout(new Duration(seconds: 10));
    }catch(TimeoutException){
      final snackBar = SnackBar(
          content: Text('Tidak ada respon dari Server!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
              )
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransDetailPage(kode: kode, outlet: outlet)
          )
      );

      //info = InfoModel.fromJson(data);
      //lstTransM = List<TransMModel>.from(data['trans'].map((x) => TransMModel.fromJson(x)));

      //setState(() {});
    }
    else{
      final snackBar = SnackBar(
          content: Text('Transaksi tidak tersedia!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
              )
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

  }


}

class CustomShapeClipper extends CustomClipper<Path>{
  
  @override
  Path getClip(Size size){
    var path = Path();

    path.lineTo(0.0, 390.0 - 200);
    path.quadraticBezierTo(size.width / 2 , 280, size.width, 390.0 - 200);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}