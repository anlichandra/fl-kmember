import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:kasimura_member2/promo_bank_model.dart';
import 'package:kasimura_member2/Constants.dart';

class PromoBankDetailPage extends StatefulWidget{
  PromoBankDetailPage({Key key, this.value});// : super(key: key);

  final String value;

  @override
  _PromoBankDetailPageState createState() => _PromoBankDetailPageState();
}

class _PromoBankDetailPageState extends State<PromoBankDetailPage>{
  String title, subtitle;
  MaterialAccentColor titleBGColor;//, titleFGColor;

  PromoBankModel promoDetail = new PromoBankModel();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((__) => _loadPromoDetail());
  }

  void _onRefresh() async{
    await _loadPromoDetail();

    setState(() {});

    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xff29166f),
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Promo Bank',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Stack(
              children: <Widget>[
                Container(
                  child: Text(' ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white
                      )
                  ),
                  //alignment: Alignment.topCenter,
                  //child: Text('hello world'),
                  height: MediaQuery.of(context).size.height - 82.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                ),
                Positioned(
                  top: 30.0,
                  child: Container(
                      padding: EdgeInsets.only(left:10, right:10, bottom:10, top: 20),
                      //margin: EdgeInsets.only(left:10, right:10, bottom:10, top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height - 100,
                      width: MediaQuery.of(context).size.width,
                      child: SmartRefresher(
                          controller: _refreshController,
                          enablePullDown: true,
                          onRefresh: _onRefresh,
                          header: WaterDropHeader(),
                          child: promoDetail.judul==null ?
                          Container() :
                          ListView(
                            children: <Widget>[
                              Container(
                                  width: double.infinity,
                                  height: 200.0,
                                  padding: EdgeInsets.all(5.0),
                                  alignment: Alignment.topRight,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      image: DecorationImage(
                                          image: NetworkImage(promoDetail.gambar),
                                          fit: BoxFit.fill
                                      )
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(promoDetail.judul,
                                          textAlign: TextAlign.left,
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20.0,
                                            fontFamily: 'Montserrat',
                                            color: Color(0xff29166f),
                                          )
                                      )
                                    ),
                                  ]
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Text(promoDetail.keterangan,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xff29166f),
                                  ),
                                ),
                              ),
                            ]
                          )
                      )
                  ),
                )
              ]
          ),
        ],
      ),
    );
  }

  void _loadPromoDetail() async{
    Response response;

    promoDetail = new PromoBankModel();
    //print(promoDetail.nama);

    try{
      response = await post(
        Constants.server + '/api/load_promo_bank_id/' + widget.value,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {},
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
      promoDetail = PromoBankModel.fromJson(data);
      setState(() {});
    }
    else{
      Navigator.pop(context);
    }

    //setState(() {});
  }

}