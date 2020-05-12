import 'package:flutter/material.dart';
import 'package:fluttersqflite/model/employee.dart';
import 'dart:ui' as ui;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class EmployeeDetails extends StatelessWidget {

  // Declare a field that holds the Todo.
  final Employee employee;

  // In the constructor, require a Todo.
  EmployeeDetails({Key key, @required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final String imgUrl = 'https://pixel.nymag.com/imgs/daily/selectall/2017/12/26/26-eric-schmidt.w700.h700.jpg';

    return new Stack(children: <Widget>[
      new Container(color: Colors.green,),
      //new Image.asset('assets/profile.jpg', fit: BoxFit.fill,),
      new BackdropFilter(
          filter: new ui.ImageFilter.blur(
            sigmaX: 6.0,
            sigmaY: 6.0,
          ),
          child: new Container(
            decoration: BoxDecoration(
              color:  Colors.green.withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),)),
      new Scaffold(
          appBar: new AppBar(
            title: new Text("Details"),
            centerTitle: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          drawer: new Drawer(child: new Container(),),
          backgroundColor: Colors.transparent,
          body: new Center(
            child: new Column(
              children: <Widget>[
                new SizedBox(height: _height/12,),
                new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: AssetImage('assets/profile.jpg'),),
                new SizedBox(height: _height/25.0,),
                new Text(employee.firstName + " " + employee.lastName, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),
                new Padding(padding: new EdgeInsets.only(top: _height/30, left: _width/8, right: _width/8),
                  child:new Text("Tel: " + employee.mobileNo + "\n E-mail: " + employee.email,
                    style: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
                new Divider(height: _height/30,color: Colors.white,),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new IconButton(icon: Icon(Icons.phone, color: Colors.white),
                      onPressed: () => _makePhoneCall('tel:' + employee.mobileNo)
                    ),
                    new IconButton(icon: Icon(Icons.sms, color: Colors.white),
                        onPressed: () => _launchWhatsApp('tel:+9' + employee.mobileNo, "")
                    ),
                    new IconButton(icon: Icon(Icons.mail, color: Colors.white),
                        onPressed: () => _launchEmail(employee.email)
                    ),
                  ],),
                new Divider(height: _height/30,color: Colors.white),
                new Padding(padding: new EdgeInsets.only(left: _width/8, right: _width/8), child: new FlatButton(onPressed: (){},
                  child: new Container(child: new Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    new Icon(Icons.person),
                    new SizedBox(width: _width/30,),
                    new Text('Edit')
                  ],)),color: Colors.blue[50],),),
              ],
            ),
          )
      )
    ],);
  }

  Widget rowCell(int count, String type) => new Expanded(child: new Column(children: <Widget>[
    new Text('$count',style: new TextStyle(color: Colors.white),),
    new Text(type,style: new TextStyle(color: Colors.white, fontWeight: FontWeight.normal))
  ],));

  _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsApp(String phoneNumber, String message) async {

    var url = "whatsapp://send?phone=$phoneNumber&text=$message";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _launchEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }
}