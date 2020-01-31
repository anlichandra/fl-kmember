import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:kasimura_member2/promo_model.dart';
//import 'package:kasimura_member/promo_detail_model.dart';
import 'package:kasimura_member2/Constants.dart';
import 'package:kasimura_member2/promo_detail.dart';

class PromoPage extends StatefulWidget{
  PromoPage({Key key, this.value});// : super(key: key);

  final String value;

  @override
  _PromoPageState createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage>{
  String title, subtitle;
  MaterialAccentColor titleBGColor;//, titleFGColor;
  List<PromoModel> lstPromo = new List<PromoModel>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((__) => _loadPromo());
  }

  void _onRefresh(){
    _loadPromo();

    setState(() {});

    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context){
    if(widget.value=='G'){
      title = 'Promo Geger';
      titleBGColor = Colors.yellowAccent;
    }
    else if(widget.value=='H'){
      title = 'Promo Hypermurah';
      titleBGColor = Colors.redAccent;
    }

    if(lstPromo.length!=0)
      subtitle = lstPromo[0].keterangan;
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
          color: widget.value=='G' ? Color(0xff29166f) : Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: widget.value=='G' ? Color(0xff29166f) : Colors.white
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
                  style: TextStyle(color: widget.value=='G' ? Color(0xff29166f) : Colors.white
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
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: lstPromo.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: () { _loadPromoDetail(lstPromo[index].kode); } ,
                          child: Container(
                            width: 115.0,
                            margin: EdgeInsets.only(right: 5.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Column(
                              children: <Widget> [
                                Container(
                                  alignment: Alignment.topRight,
                                  padding: EdgeInsets.all(5.0),
                                  child: lstPromo[index].outlet=='' ?
                                  Container() :
                                  Wrap(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                                        ),
                                        child: Text(
                                          lstPromo[index].outlet,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 11.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                      )
                                    ],
                                  ),

                                  width: double.infinity,
                                  height: 165.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft:Radius.circular(5.0), topRight:Radius.circular(5.0)),
                                    image: DecorationImage(
                                      image: NetworkImage(lstPromo[index].gambar),
                                      fit: BoxFit.fill
                                    )
                                  ),
                                ),
                                Text(lstPromo[index].nama,
                                  maxLines: 2,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0,
                                    fontFamily: 'Montserrat',
                                    color: Color(0xff29166f),
                                  ),
                                ),
                                Text('Rp. ' + lstPromo[index].hargaRegular,
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: 'Montserrat',
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.red
                                  )
                                ),
                                Text('Rp. ' + lstPromo[index].harga,
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xff29166f)
                                  )
                                ),
                              ]
                            )
                          ),
                        );
                      },
                    ),
                  ),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _loadPromo() async{
    Response response;

    lstPromo= new List<PromoModel>();

    try {
      response = await post(
        Constants.server + '/api/load_promo/' + widget.value,
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
        lstPromo = List<PromoModel>.from(data['produk'].map((x) => PromoModel.fromJson(x)));
      });
    }
    else{
      Navigator.pop(context);
    }
  }

  void _loadPromoDetail(String kode) async{
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
          builder: (context) => PromoDetailPage(type: widget.value, value: kode)
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



}