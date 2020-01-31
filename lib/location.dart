import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationPage extends StatefulWidget{
  LocationPage({Key key, this.title});

  final String title;
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>{
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
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
        title: Text('Outlet',
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
                //alignment: Alignment.topCenter,
                //child: Text('hello world'),
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
                    children: <Widget>[
                      _createLocation('Kasimura Krakatau', 'Jl. G. Krakatau No.103 / 184, Telp: (061) 6631655', 3.621260, 98.681209),
                      Divider(height: 15.0, color: Colors.grey),
                      _createLocation('Kasimura Wahidin', 'JL. Dr. Wahidin 34 / 204, Telp: (061) 4554723', 3.588097, 98.698975),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _createLocation(String nama, String alamat, double lat, double long){
    return ListTile(
      /*leading: Icon(Icons.location_on,
        color: Colors.red,
        size: 30,
      ),*/
      onTap:  (){ _openLocation(nama, lat, long); },
      title: Text(nama,
        style: TextStyle(
          color: Color(0xff29166f),
          fontFamily: 'montserrat',
        ),
      ),
      subtitle: Text(alamat,
        style: TextStyle(
          fontFamily: 'Montserrat',
        )
      ),
      trailing: Icon(
        Icons.navigate_next,
        color: Colors.grey,
        size: 30.0,
      ),

    );
  }

  void _openLocation(String nama, double lat, double long) async{
    //final url = 'https://'
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(coords: Coords(lat, long), title: nama, description: '');
  }

}