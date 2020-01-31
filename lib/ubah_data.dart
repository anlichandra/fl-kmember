import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kasimura_member2/info_model.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasimura_member2/Constants.dart';


class UbahDataPage extends StatefulWidget{
  UbahDataPage({Key key, this.title});

  String title;
  @override
  _UbahDataPageState createState() => _UbahDataPageState();
}

class _UbahDataPageState extends State<UbahDataPage>{
  InfoModel info = new InfoModel();

  final _alamatController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kotaController = TextEditingController();
  final _noTeleponController = TextEditingController();
  final _noHpController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isProcess = false;

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInfo());
  }

  @override
  Widget build(BuildContext context){
    Widget loadingIndicator = isProcess
        ? Container(
          width: 70.0,
          height: 70.0,
          child: Center(
            child: CircularProgressIndicator()
          )
        )
        : Container();

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
        title: Text('Permintaan Perubahan Data',
          style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          TextFormField(
            controller: _alamatController,
            decoration: new InputDecoration(
              labelText: 'Alamat',
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              //errorText: validateIDMember(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: new BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            style: new TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xff29166f),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _kelurahanController,
            decoration: new InputDecoration(
              labelText: 'Kelurahan',
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              //errorText: validateIDMember(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: new BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            style: new TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xff29166f),
            ),
          ),
          SizedBox(height:10.0),
          TextFormField(
            controller: _kecamatanController,
            decoration: new InputDecoration(
              labelText: 'Kecamatan',
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              //errorText: validateIDMember(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: new BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            style: new TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xff29166f),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _kotaController,
            decoration: new InputDecoration(
              labelText: 'Kota',
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              //errorText: validateIDMember(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: new BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            style: new TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xff29166f),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _noTeleponController,
            decoration: new InputDecoration(
              labelText: 'Telepon',
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              //errorText: validateIDMember(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: new BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            style: new TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xff29166f),
            ),
          ),
          SizedBox(height: 10.0),
          TextFormField(
            controller: _noHpController,
            decoration: new InputDecoration(
              labelText: 'HP',
              filled: true,
              fillColor: Colors.white,
              focusColor: Colors.white,
              //errorText: validateIDMember(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: new BorderSide(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
            ),
            style: new TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xff29166f),
            ),
          ),
          SizedBox(height: 10.0),
          InkWell(
            child: Container(
              height:50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: !isProcess ? Color(0xFFD9231B) : Colors.grey,
                  border:Border.all(
                      color: Color(0xFFD9231B),
                      style: BorderStyle.solid,
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(20.0)
              ),
              child: Center(
                child: Text("Kirim Permintaan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            onTap: (){ doSend(context); },
          ),
          SizedBox(height: 10.0),
          loadingIndicator,
        ]
      ),
    );
  }

  void _loadInfo() async{
    Response response;

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

      _alamatController.text = info.alamat;
      _kelurahanController.text = info.kelurahan;
      _kecamatanController.text = info.kecamatan;
      _kotaController.text = info.kota;
      _noTeleponController.text = info.noTelepon;
      _noHpController.text = info.noHp;

      setState(() {});
    }
    else{
      Navigator.pop(context);
    }

  }

  Future doSend(BuildContext context) async{
    if(!isProcess){
      String alamat = _alamatController.text;
      String kelurahan = _kelurahanController.text;
      String kecamatan = _kecamatanController.text;
      String kota = _kotaController.text;
      String noTelepon = _noTeleponController.text;
      String noHp = _noHpController.text;

      SharedPreferences _pref = await SharedPreferences.getInstance();
      String kode = _pref.getString('kode');

      String body ='';

      body += 'Kode : $kode  </br>';
      body += 'Alamat : $alamat </br>';
      body += 'Kelurahan : $kelurahan </br>';
      body += 'Kecamatan : $kecamatan </br>';
      body += 'Kota : $kota </br>';
      body += 'No. Telepon : $noTelepon </br>';
      body += 'No. HP : $noHp';


      Response response;

      setState(() {
        isProcess = true;
      });

      try {
        response = await post(
          Constants.server + '/api/send_mail',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'body': body},
          encoding: Encoding.getByName('utf-8'),

        ).timeout(new Duration(seconds: 10));
      }catch(TimeoutException) {
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
      }finally{
        setState(() {
          isProcess = false;
        });
      }

      Map<String, dynamic> data = json.decode(response.body);

      if(data['success']==0){
        final snackBar = SnackBar(
            backgroundColor: Colors.red[400],
            content: Text(data['message'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            )
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);

      }
      else{
        Widget okButton = FlatButton(
          child: Text("Ok",
            style: TextStyle(
              fontFamily: 'Montserrat',
            )
            ,),
          onPressed: () async{
            Navigator.pop(context);
          },
        );

        AlertDialog alert = AlertDialog(
          title: Text('Informasi',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xff29166f)
            ),
          ),
          content: Text(data['message'],
              style: TextStyle(
                color: Color(0xff29166f),
                fontFamily: 'Montserrat',
              )
          ),
          actions: <Widget>[
            okButton,
          ],
        );

        showDialog(
          context: context,
          builder: (BuildContext context){
            return alert;
          },
        );
      }
    }

    //print('hello ' + response.statusCode.toString());
  }

}