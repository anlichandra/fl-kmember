import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:kasimura_member2/promo_detail_model.dart';
import 'package:kasimura_member2/Constants.dart';

class PromoDetailPage extends StatefulWidget{
  PromoDetailPage({Key key, this.value, this.type});// : super(key: key);

  final String value;
  final String type;

  @override
  _PromoDetailPageState createState() => _PromoDetailPageState();
}

class _PromoDetailPageState extends State<PromoDetailPage>{
  String title, subtitle;
  MaterialAccentColor titleBGColor;//, titleFGColor;

  PromoDetailModel promoDetail = new PromoDetailModel();

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
    if(promoDetail.tipe!=null){
      if(promoDetail.tipe=='Geger'){
        title = 'Promo Geger';
        titleBGColor = Colors.yellowAccent;
      }
      else if(promoDetail.tipe=='Hypermurah'){
        title = 'Promo Hypermurah';
        titleBGColor = Colors.redAccent;
      }
    }
    else{
      title = '';
      titleBGColor = Colors.yellowAccent;
    }


    if(promoDetail.nama!=null)
      subtitle = promoDetail.periode;
    else
      subtitle = '';

    return Scaffold(
      backgroundColor: titleBGColor,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: widget.type=='G' ? Color(0xff29166f) : Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: widget.type=='G' ? Color(0xff29166f) : Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Text(subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: widget.type=='G' ? Color(0xff29166f) : Colors.white
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
                    child: promoDetail.nama==null ?
                      Container() :
                      ListView(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 350.0,
                            padding: EdgeInsets.all(5.0),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              image: DecorationImage(
                                image: NetworkImage(promoDetail.gambar),
                                fit: BoxFit.fill
                              )
                            ),
                            child: Wrap(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.white,
                                  ),
                                  child: Text(promoDetail.outlet,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )
                                  ),
                                )
                              ],
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(promoDetail.nama,
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
                            padding: EdgeInsets.only(top:20.0, bottom:15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text('Rp. ' + promoDetail.hargaRegular,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat',
                                    fontSize: 15.0,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red
                                  ),
                                ),
                                Container(
                                  color: Colors.grey,
                                  height: 20,
                                  width: 2,
                                  margin: EdgeInsets.only(left:10, right:10),
                                ),
                                Text('Rp. ' + promoDetail.harga,
                                  style: TextStyle(
                                    color: Color(0xff29166f),
                                    fontFamily: 'Montserrat',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w900,
                                  )
                                ),
                              ],

                            )
                          ),
                          Padding(
                            padding:EdgeInsets.only(top:10.0),
                            child: Text('Artikel',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, left:20.0),
                            child: Text(promoDetail.artikel,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xff29166f),
                              ),
                            ),

                          ),
                          Padding(
                            padding:EdgeInsets.only(top:10.0),
                            child: Text('Keterangan',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0, left:20.0),
                            child: Text(promoDetail.sk,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xff29166f),
                              ),
                            ),

                          )
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

    promoDetail = new PromoDetailModel();
    //print(promoDetail.nama);

    try{
      response = await post(
        Constants.server + '/api/load_produk/' + widget.value,
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
      promoDetail = PromoDetailModel.fromJson(data['produk'][0]);
      setState(() {});
    }
    else{
      Navigator.pop(context);
    }

    //setState(() {});
  }

}