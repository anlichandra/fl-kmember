import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:kasimura_member2/trans_m_model.dart';
import 'package:kasimura_member2/trans_d_model.dart';
import 'package:kasimura_member2/Constants.dart';


class TransDetailPage extends StatefulWidget{
  TransDetailPage({Key key, this.kode, this.outlet});

  final String kode;
  final String outlet;
  @override
  _TransDetailPageState createState() => _TransDetailPageState();
}

class _TransDetailPageState extends State<TransDetailPage>{
  TransMModel transM = new TransMModel();
  List<TransDModel> lstTransD = new List<TransDModel>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTrans(widget.kode, widget.outlet));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff29166f),
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color:Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Transaksi Terakhir',
          style: TextStyle(
              fontFamily: 'Montserrat'
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: transM.kode == null ? Container() :
                  Text(transM.kode.trimRight() + ' - Rp. ' + transM.jumlah,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white
                    )
                  ),
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Positioned(
                top: 30.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45.0),
                      topRight: Radius.circular(45.0),
                    ),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height - 100,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children:
                      lstTransD.map((x) =>
                         Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(x.nama,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xff29166f)
                                )
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(x.kuantitas + ' x ' + x.harga,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat'
                                    )
                                  ),
                                  Text('Rp. ' + x.jumlah,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w900
                                    )
                                  )
                                ]
                              ),
                            ),
                            Divider(),
                          ]
                        )
                      ).toList()
                    )
                  ),
                ),
              ]
              )
            ],
          ),
      );
  }

  void _loadTrans(String kode, String outlet) async{
    Response response;

    try{
      response = await post(
        Constants.server + '/api/load_transaksi',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'kode': widget.kode, 'outlet': widget.outlet},
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
      transM = TransMModel.fromJson(data);
      lstTransD = List<TransDModel>.from(data['trans'].map((x) => TransDModel.fromJson(x)));

      setState(() {});
    }
    else{
      Navigator.pop(context);
    }

  }




}