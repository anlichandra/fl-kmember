import 'package:carousel_slider/carousel_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:screen/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

import 'package:kasimura_member2/location.dart';
import 'package:kasimura_member2/login.dart';
import 'package:kasimura_member2/promo_detail.dart';
import 'package:kasimura_member2/promo_buletin_detail.dart';
import 'package:kasimura_member2/promo_bank_detail.dart';
import 'package:kasimura_member2/promo_qr_detail.dart';
import 'package:kasimura_member2/info.dart';

import 'package:kasimura_member2/card_model.dart';
import 'package:kasimura_member2/slider_model.dart';
import 'package:kasimura_member2/promo_model.dart';
import 'package:kasimura_member2/promo_buletin_model.dart';
import 'package:kasimura_member2/promo_bank_model.dart';

import 'package:kasimura_member2/promo.dart';

import 'package:kasimura_member2/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title});

  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  SharedPreferences _pref;

  CardModel card = new CardModel();
  List<SliderModel> lstSlider = new List<SliderModel>();
  List<PromoModel> lstPromoGeger = new List<PromoModel>();
  List<PromoBuletinModel> lstPromoBuletin = new List<PromoBuletinModel>();
  List<PromoModel> lstPromoHypermurah = new List<PromoModel>();
  List<PromoBankModel> lstPromoBank = new List<PromoBankModel>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _current = 0;
  //String barcode;

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((__) => _loadMainFunction());
  }

  Future<void> _cekMember() async{
    _pref = await SharedPreferences.getInstance();
    String kode = _pref.getString('kode');

    Response response;

    try{
      response = await post(
        Constants.server + '/api/cek_member',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'kode': kode},
        encoding: Encoding.getByName('utf-8')
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

    if(data['success']==0){
      _pref.remove('kode');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()
        ),
      );
    }

  }

  Future<void> _loadCardInfo() async{
    _pref = await SharedPreferences.getInstance();
    String kode = _pref.getString('kode');

    Response response;

    card = new CardModel();

    try {
      response = await post(
        Constants.server + '/api/load_kartu',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'kode': kode},
        encoding: Encoding.getByName('utf-8'),

      ).timeout(new Duration(seconds: 10));
    }catch(TimeoutException){
      final snackBar = SnackBar(
          content: Text('Tidak ada respon dari Server!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1) {
      setState(() {
        card = new CardModel(front:data['front'], back:data['back'], barcode:data['barcode']);
      });
    }
  }

  Future<void> _loadSlider() async{
    Response response;
    lstSlider = new List<SliderModel>();

    try {
      response = await post(
        Constants.server + '/api/load_slider',
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
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1) {
      setState(() {
        lstSlider = List<SliderModel>.from(data['slider'].map((x) => SliderModel.fromJson(x)));
      });
    }
  }

  Future<void> _loadPromoGeger() async{
    Response response;
    lstPromoGeger = new List<PromoModel>();

    try {
      response = await post(
        Constants.server + '/api/load_promo/G',
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
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1) {
      setState(() {
        lstPromoGeger = List<PromoModel>.from(data['produk'].map((x) => PromoModel.fromJson(x)));
      });
    }
  }

  Future<void> _loadPromoBuletin() async{
    Response response;
    lstPromoBuletin = new List<PromoBuletinModel>();

    try {
      response = await post(
        Constants.server + '/api/load_promo_buletin',
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
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1) {
      setState(() {
        lstPromoBuletin = List<PromoBuletinModel>.from(data['promo'].map((x) => PromoBuletinModel.fromJson(x)));
      });
    }
  }

  Future<void> _loadPromoHypermurah() async{
    Response response;
    lstPromoHypermurah= new List<PromoModel>();

    try {
      response = await post(
        Constants.server + '/api/load_promo/H',
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
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1) {
      setState(() {
        lstPromoHypermurah = List<PromoModel>.from(data['produk'].map((x) => PromoModel.fromJson(x)));
      });
    }
  }

  Future<void> _loadPromoBank() async{
    Response response;
    lstPromoBank= new List<PromoBankModel>();

    try {
      response = await post(
        Constants.server + '/api/load_promo_bank',
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
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);

      return;
    }

    Map<String, dynamic> data = json.decode(response.body);

    if(data['success']==1) {
      setState(() {
        lstPromoBank = List<PromoBankModel>.from(data['promo'].map((x) => PromoBankModel.fromJson(x)));
      });
    }
  }

  //Widget w;

  Widget _loadCard(){
    return
      Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>
          [
            Container(
              height: 200.0,
              child: FlipCard(
                front: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image : NetworkImage(card.front),
                      fit: BoxFit.fill
                    )
                    //color: Colors.amber
                  ),
                ),
                back: Container(
                  height: 200.0,
                  child: GestureDetector(
                    onDoubleTap: (){showBarcode(context);},
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(card.back),
                      fit: BoxFit.fill
                    )
                  ),
                ),
              ),

            ),
            Text('Double tap bagian belakang untuk pop up barcode',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.red,
                fontSize: 8.0,
              ),
            )
          ]
        ),
      );
  }

  Widget _loadCarousel(){

    return Stack(
      alignment: AlignmentDirectional.topStart,
      fit:StackFit.loose,
      children: [
        CarouselSlider(
          height: 200.0,
          enlargeCenterPage: true,
          aspectRatio: 16/9,
          autoPlay: true,
          autoPlayInterval: Duration(seconds:5),
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          viewportFraction: 0.8,
          onPageChanged: (index){
            setState(() {
              _current = index;
            });
          },
          items: lstSlider.map((x) {
            return Builder(
              builder: (BuildContext context) {
                return InkWell(
                  onTap: () { _launchURL(x.link); },
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(x.gambar),
                          fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.amber,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: lstSlider.asMap().entries.map((MapEntry entry){
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: entry.key==null || entry.key==_current ? Colors.red : Colors.white
                ),
              );
            }).toList(),
              //for(int i=0; i<lstSlider.length; i++){
              //  Container(child: Text('hello world'))
              //}


          )

        )
      ]
    );
  }

  Widget _loadWPGeger(){
    List<PromoModel> lstPGeger = new List<PromoModel>();

    for(int i=0; i<(lstPromoGeger.length <= 5 ? lstPromoGeger.length : 5); i++){
      lstPGeger.insert(lstPGeger.length, lstPromoGeger[i]);
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Promo ',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xff29166f),
                    fontSize: 17.0
                  )
                ),
                Text('Geger',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Montserrat',
                    color: Color(0xff29166f),
                    fontSize: 17.0,
                  )
                )
              ]
            ),
            Row(
              children: <Widget>[
                InkWell(
                  onTap: (){ _openPromoGegerPage('G'); },
                  child: Text('Lihat Semua',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0
                    )
                  )
                ),
              ],
            )
          ]
        ),
        Row(
          children: <Widget>
            [
              Text(lstPGeger[0].keterangan,
                style: TextStyle(
                  color: Color(0xff29166f),
                  fontSize: 10.0,
                  fontFamily: 'Montserrat',
                )
              ),
            ]
          ),
        SizedBox(height:5.0),
        Container(
          height: 175,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: lstPGeger.map((x) =>
              InkWell(
                onTap: (){ _loadPromoDetail('G', x.kode); },
                child: Container(
                  width: 115.0,
                  margin: EdgeInsets.only(right: 5.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    /*boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        blurRadius: 20.0,
                        spreadRadius: 5.0,
                        offset: Offset(
                          10.0,
                          10.0
                        ),
                      )
                    ],*/
                    //image: DecorationImage(
                      //image: NetworkImage(x.gambar),
                      //fit: BoxFit.fill
                    //),
                  ),
                  child: Column(
                    children: <Widget> [
                      Container(
                        width: double.infinity,
                        height: 120.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft:Radius.circular(5.0), topRight:Radius.circular(5.0)),
                          image: DecorationImage(
                            image: NetworkImage(x.gambar),
                            fit: BoxFit.fill
                          )
                        ),
                      ),
                      Text(x.nama,
                        maxLines: 2,
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9.0,
                          fontFamily: 'Montserrat',
                          color: Color(0xff29166f),
                        ),
                      ),
                      Text('Rp. ' + x.hargaRegular,
                        style: TextStyle(
                          fontSize: 9.0,
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red
                        )
                      ),
                      Text('Rp. ' + x.harga,
                        style: TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          color: Color(0xff29166f)
                        )
                      ),
                    ]
                  )

                ),
              ),
            ).toList()
          )
        ),
        SizedBox(height:10.0)
      ],
    );
  }

  Widget _loadWPBuletin(){
    return Column(
      //shrinkWrap: true,
      //scrollDirection: Axis.vertical,
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Text('Promo ',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xff29166f),
                fontSize: 17.0,
              ),
            ),
            Text('Buletin',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: 'Montserrat',
                color: Color(0xff29166f),
                fontSize: 17.0
              ),
            ),
          ],
        ),
        Row(
          children: <Widget> [
            Text(lstPromoBuletin.elementAt(0).keterangan,
              //textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xff29166f),
                fontSize: 10.0,
              ),
            ),
          ],
        ),
        SizedBox(height:5.0),
        Container(
          height: 175,
          child:ListView(
            scrollDirection: Axis.horizontal,
            children: lstPromoBuletin.map((x) =>
              InkWell(
                onTap: (){ _loadPromoBuletinDetail(x.kode); },
                child: Container(
                  width: 115.0,
                  margin: EdgeInsets.only(right: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    image: DecorationImage(
                      image: NetworkImage(x.gambarThumb),
                      fit: BoxFit.fill
                    )
                  ),
                ),
              ),
            ).toList()
          ),
          //)
        ),
        SizedBox(height:10.0),
      ],
    );
  }

  Widget _loadWPHypermurah(){

    List<PromoModel> lstPHypermurah = new List<PromoModel>();

    for(int i=0; i<(lstPromoHypermurah.length <= 5 ? lstPromoHypermurah.length : 5); i++){
      lstPHypermurah.insert(lstPHypermurah.length, lstPromoHypermurah[i]);
    }

    return Column(
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  children: <Widget>[
                    Text('Promo ',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xff29166f),
                            fontSize: 17.0
                        )
                    ),
                    Text('Hypermurah',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Montserrat',
                          color: Color(0xff29166f),
                          fontSize: 17.0,
                        )
                    )
                  ]
              ),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: (){ _openPromoHypermurahPage('H'); },
                    child:Text('Lihat Semua',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0
                      )
                    )
                  )
                ],
              )
            ]
        ),
        Row(
            children: <Widget>
            [
              Text(lstPHypermurah[0].keterangan,
                  style: TextStyle(
                    color: Color(0xff29166f),
                    fontSize: 10.0,
                    fontFamily: 'Montserrat',
                  )
              ),
            ]
        ),
        SizedBox(height:5.0),
        Container(
          height: 175,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: lstPHypermurah.map((x) =>
              InkWell(
                onTap: (){ _loadPromoDetail('H', x.kode); },
                child: Container(
                    width: 115.0,
                    margin: EdgeInsets.only(right: 5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      /*boxShadow: [
                BoxShadow(
                  color: Colors.red,
                  blurRadius: 20.0,
                  spreadRadius: 5.0,
                  offset: Offset(
                    10.0,
                    10.0
                  ),
                )
              ],*/
                      //image: DecorationImage(
                      //image: NetworkImage(x.gambar),
                      //fit: BoxFit.fill
                      //),
                    ),
                    child: Column(
                      children: <Widget>
                      [
                        Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.all(3.0),
                          child: x.outlet == '' ?
                          Container() :
                          Wrap(
                            children: <Widget>
                              [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child: Text(x.outlet,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 10.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold
                                    )
                                  )
                                ),
                              ]
                          ),
                          width: double.infinity,
                          height: 120.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft:Radius.circular(5.0), topRight:Radius.circular(5.0)),
                              image: DecorationImage(
                                  image: NetworkImage(x.gambar),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Text(x.nama,
                          maxLines: 2,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 9.0,
                            fontFamily: 'Montserrat',
                            color: Color(0xff29166f),
                          ),
                        ),
                        Text('Rp. ' + x.hargaRegular,
                            style: TextStyle(
                                fontSize: 9.0,
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.red
                            )
                        ),
                        Text('Rp. ' + x.harga,
                            style: TextStyle(
                                fontSize: 10.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                color: Color(0xff29166f)
                            )
                        ),
                      ]
                    )

                ),
              ),
            ).toList()
          )
        ),
        SizedBox(height:10.0)
      ],
    );
  }

  Widget _loadWPBank(){
    return Column(
      //shrinkWrap: true,
      //scrollDirection: Axis.vertical,
      children: <Widget>[
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Text('Promo ',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xff29166f),
                fontSize: 17.0
              )
            ),
            Text('Bank',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xff29166f),
                fontSize: 17.0,
                fontWeight: FontWeight.w900
              )
            )
          ],
        ),
        SizedBox(height: 5.0),
        Row(
          children: <Widget> [
            Flexible(
              child:Column(
                children: lstPromoBank.map((x) =>
                  InkWell(
                    onTap: (){ _loadPromoBankDetail(x.kode); },
                    child: Container(
                      width: double.infinity,
                      height: 200.0,
                      margin: EdgeInsets.only(bottom: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          image: DecorationImage(
                            image: NetworkImage(x.gambar),
                            fit: BoxFit.fill
                          )
                      ),
                    )
                  )
                ).toList()
              ),
            ),
          ]
        )
      ],
    );
  }

  void _loadMainFunction() async{
    await _cekMember();

    await _loadCardInfo();
    await _loadSlider();
    await _loadPromoGeger();
    await _loadPromoBuletin();
    await _loadPromoHypermurah();
    await _loadPromoBank();
  }

  void _onRefresh(){
    _loadMainFunction();

    setState(() {});

    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context){
    // TODO: implement build

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff29166f),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 10.0),
                  Text('Kasimura',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 18.0
                    ),
                  ),
                  Text('Member',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 125.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.location_on, color: Colors.white),
                      onPressed: _openLocation,
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.menu, color: Colors.white),
                      color: Colors.white,
                      onSelected: menuAction,
                      itemBuilder: (BuildContext context){
                        return Constants.menu.map((String menu){
                          return PopupMenuItem<String>(
                            value: menu,
                            child: Text(menu),
                          );
                        }).toList();
                      },
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.0,),
          Container(
            padding: EdgeInsets.only(top:10.0),
            height: MediaQuery.of(context).size.height - 96.0 ,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)),
            ),
            child:
            SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onRefresh: _onRefresh,
              header: WaterDropHeader(),
              child: ListView(
                children: <Widget>[
                  card.front==null ? Container() : _loadCard(),
                  lstSlider.length==0 ? Container() : _loadCarousel(),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: lstPromoGeger.length==0 ? Container() : _loadWPGeger(),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: lstPromoBuletin.length==0 ? Container() : _loadWPBuletin(),
                    )
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: lstPromoHypermurah.length==0 ? Container() : _loadWPHypermurah(),
                    )
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: lstPromoBank.length==0 ? Container() : _loadWPBank(),
                    )
                  )
                ]
              ),
            ),
          ),
        ]
      ),
      //),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff29166f),
        onPressed: (){

          _openCamera(context);
        },
      ),
    );
  }

  void _openCamera(BuildContext context) async{
    try {
      String barcode = await BarcodeScanner.scan();

      if(barcode.length >= 11){
        Response response;
        print(barcode.substring(5, 11));

        try{
          response = await post(
            Constants.server + '/api/get_produk_by_artikel/' + barcode.substring(5, 11),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PromoDetailPage(value: data['kode'], type: data['tipe_promo'])
              )
          );
        }
        else{
          final snackBar = SnackBar(
              content: Text('Promo tidak tersedia!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                ),
              )
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      }
      else{
        Response response;

        try{
          response = await post(
            Constants.server + '/api/get_promo_by_qr/' + barcode,
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PromoQRDetailPage(value: barcode)
              )
          );
        }
        else{
          final snackBar = SnackBar(
              content: Text('Promo tidak tersedia!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                ),
              )
          );
          _scaffoldKey.currentState.showSnackBar(snackBar);
        }

      }


      //setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {

          final snackBar = SnackBar(
            content: Text('The user did not grant the camera permission!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserat'
              )
            )
          );

          _scaffoldKey.currentState.showSnackBar(snackBar);
        }
      else {

        final snackBar = SnackBar(
          content: Text('Unknown error : $e',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat'
            ),
          )
        );

        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    } on FormatException{

      final snackBar = SnackBar(
        content: Text('null (User returned using the "back"-button before scanning anything. Result)',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat'
          ),
        )
      );

      _scaffoldKey.currentState.showSnackBar(snackBar);

    } catch (e) {

      final snackBar = SnackBar(
        content: Text('Unknown error: $e',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat'
          ),
        )

      );

      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

    //print(barcodeScanRes);
  }

  void menuAction(String menu){
    //print(menu);
    if(menu=="Keluar"){
      confirmLogout(context);
    }
    else if(menu=="Poin dan Transaksi"){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfoPage()
        )
      );
    }
  }

  void _openLocation(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPage()
      ),
    );
  }

  void _openPromoGegerPage(String promo) async{
    await _loadPromoGeger();

    if(lstPromoGeger.length==0){
      final snackBar = SnackBar(
          content: Text('Promo tidak tersedia!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromoPage(value: promo)
        ),
      );
    }
  }

  void _openPromoHypermurahPage(String promo) async{
    await _loadPromoHypermurah();

    if(lstPromoHypermurah.length==0){
      final snackBar = SnackBar(
          content: Text('Promo tidak tersedia!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PromoPage(value: promo)
          )
      );
    }
  }

  void _loadPromoDetail(String type, String kode) async{
    Response response;

    try{
      response = await post(
        Constants.server + '/api/load_produk/' + kode,
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromoDetailPage(type: type, value: kode)
          )
      );
    }
    else{
      final snackBar = SnackBar(
          content: Text('Promo tidak tersedia!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void _loadPromoBuletinDetail(String kode) async{
    Response response;

    try{
      response = await post(
        Constants.server + '/api/load_promo_buletin_id/' + kode,
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromoBuletinDetailPage(value: kode)
          )
      );
    }
    else{
      final snackBar = SnackBar(
          content: Text('Promo tidak tersedia!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }

  }

  void _loadPromoBankDetail(String kode) async{
    Response response;

    try{
      response = await post(
        Constants.server + '/api/load_promo_bank_id/' + kode,
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
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PromoBankDetailPage(value: kode)
          )
      );
    }
    else{
      final snackBar = SnackBar(
          content: Text('Promo tidak tersedia!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Montserrat',
            ),
          )
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  void showBarcode(BuildContext context) async{
    AlertDialog alert = AlertDialog(
      content: Container(
        height: 85.0,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(card.barcode),
            fit: BoxFit.fill
          )
        ),
      )
    );

    double brightness = await Screen.brightness;

    showDialog(
      context: context,
      builder: (BuildContext context){
        Screen.setBrightness(1.0);
        return alert;
      },
    ).then((val){
      Screen.setBrightness(brightness);
    });
  }

  void confirmLogout(BuildContext context){
    Widget okButton = FlatButton(
      child: Text("Ok",
        style: TextStyle(
          fontFamily: 'Montserrat',
        )
        ,),
      onPressed: () async{
        final prefs = await SharedPreferences.getInstance();
        prefs.remove("kode");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage()
          ),
        );
      },
    );

    Widget batalButton = FlatButton(
      child: Text("Batal",
        style: TextStyle(
          fontFamily: 'Montserrat',
        )
      ),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Konfirmasi',
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: Color(0xff29166f)
        ),
      ),
      content: Text("Keluar dari Aplikasi?",
        style: TextStyle(
          color: Color(0xff29166f),
          fontFamily: 'Montserrat',
        )
      ),
      actions: <Widget>[
        okButton,
        batalButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      },
    );

  }

  void _launchURL(String url) async{
    if(url!='') {
      if (await canLaunch(url)) {
        await launch(url);
      }
      else {
        final snackBar = SnackBar(
            content: Text('Tidak dapat membuka Link!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
              ),
            )
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }
  }

}