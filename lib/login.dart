import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:kasimura_member2/home.dart';
import 'package:kasimura_member2/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:package_info/package_info.dart' as prefix0;

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title});

  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  String version;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _idMemberController = TextEditingController();
  final _kataSandiController = TextEditingController();

  bool isInvisiblePassword = true;
  bool isLoad = false;
  bool isProcess = false;

  @override
  void initState(){
    super.initState();

    //getVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) => getVersion());
  }

  @override
  Widget build(BuildContext context){
    Widget loadingIndicator  = isProcess ? new Container(
      width: 70.0,
      height: 70.0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : new Container();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff29166f),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),*/
            Image(
              image : AssetImage('assets/logo.png'),
              fit: BoxFit.cover,
              width: 250,
            ),
            Text("$version",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 30),
            Text('Hubungkan dengan Kartu Member Anda',
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(height:30),
            Padding(
              padding: EdgeInsets.only(left:25, top:0, right:25, bottom:0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _idMemberController,
                    decoration: new InputDecoration(
                      labelText: 'ID Member',
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      errorText: validateIDMember(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                          color: Colors.white,
                          width: 5.0,
                        ),
                      ),
                    ),
                    style: new TextStyle(
                      fontFamily: 'montserrat',
                      color: Color(0xff29166f),
                    ),
                  ),
                  Text('6(enam) digit terakhir nomor member',
                    textAlign: TextAlign.left,
                    style : TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                    ),
                  ),
                  SizedBox(height:20, width: 20),
                  TextFormField(
                    controller: _kataSandiController,
                    obscureText: isInvisiblePassword,
                    decoration: new InputDecoration(
                      labelText: 'Kata Sandi',
                      filled: true,
                      fillColor: Colors.white,
                      errorText: validateKataSandi(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: new BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(isInvisiblePassword ? Icons.visibility : Icons.visibility_off),
                        color: Theme.of(context).primaryColorDark,
                        onPressed: (){
                          setState(() {
                            isInvisiblePassword = !isInvisiblePassword;
                          });
                        },
                      ),
                    ),
                    style: new TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xff29166f),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Text('Kata sandi default tgl. lahir Anda (ddmmyyyyy)',
                    textAlign: TextAlign.left,
                    style : TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height:20.0),
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
                        child: Text("Masuk",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: 'Montserrat',
                            ),
                        ),
                      ),
                    ),
                    onTap: (){ doLogin(context); },
                  ),
                  loadingIndicator,
                ],
              )
            )
          ],
        ),

      ),
    );
  }

  void getVersion(){
    setState(() {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        version = 'v' + packageInfo.version + '.' + packageInfo.buildNumber;
      });
    });
  }

  String validateIDMember(){
    if(_idMemberController.text == ''){
      return null;
    }
    else if(_idMemberController.text.length != 6){
      return 'ID Member minimal 6 karakter!';
    }
  }

  String validateKataSandi(){
    return null;
  }

  Future doLogin(BuildContext context) async{
    if(!isProcess){
      String kode = _idMemberController.text;
      String kataSandi = _kataSandiController.text;

      Response response;

      setState(() {
        isProcess = true;
      });

      try {
        response = await post(
          Constants.server + '/api/masuk',
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'kode': kode, 'kata_sandi': kataSandi},
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
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("kode", data['kode']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          ),
        );
      }
    }

    //print('hello ' + response.statusCode.toString());
  }

}