import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
//import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:photo_view/photo_view.dart';

import 'package:kasimura_member2/promo_buletin_model.dart';
import 'package:kasimura_member2/Constants.dart';

class PromoBuletinDetailPage extends StatefulWidget{
  PromoBuletinDetailPage({Key key, this.value});// : super(key: key);

  final String value;

  @override
  _PromoBuletinDetailPageState createState() => _PromoBuletinDetailPageState();
}

class _PromoBuletinDetailPageState extends State<PromoBuletinDetailPage>{
  String title, subtitle;
  MaterialAccentColor titleBGColor;//, titleFGColor;

  PromoBuletinModel promoDetail = new PromoBuletinModel();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((__) => _loadPromoDetail());
  }

  /*void _onRefresh() async{
    await _loadPromoDetail();

    setState(() {});

    _refreshController.refreshCompleted();
  }*/

  //RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context){

    if(promoDetail.keterangan!=null)
      subtitle = promoDetail.keterangan;
    else
      subtitle = '';

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
        title: Text('Promo Buletin',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: promoDetail.gambar != null ? PhotoView(backgroundDecoration: BoxDecoration(color: Colors.transparent),
        imageProvider: NetworkImage(promoDetail.gambar)) : Container()

    );
  }

  void _loadPromoDetail() async{
    Response response;

    promoDetail = new PromoBuletinModel();

    try{
      response = await post(
        Constants.server + '/api/load_promo_buletin_id/' + widget.value,
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
      promoDetail = PromoBuletinModel.fromJson(data);
      setState(() {});
    }
    else{
      Navigator.pop(context);
    }

    //setState(() {});
  }



}