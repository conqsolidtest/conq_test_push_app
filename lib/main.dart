import 'dart:math';

import 'package:conq_test_push_app/usercontrol/CircularProgressIndicatorControl.dart';
import 'package:conq_test_push_app/utilities/ApiUtilities.dart';
import 'package:conq_test_push_app/utilities/information_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dto/information_dto.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Nature App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<List<InformationDto>> _informationListFuture;
  String _token;

  @override
  void initState() {
    _informationListFuture = ApiUtilities.getInformations();
    super.initState();
    _firebaseMessaging.getToken().then((token) => {
          setState(() {
            _token = token;
          })
        });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage4");
        setState(() {});
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch");
        setState(() {});
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume");
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _getTravelDestinations(_informationListFuture),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.orange.shade400,
              child: SizedBox(
                height: 75,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      print("Book Now pressed");
                    },
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          'Book now',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _getSingleInformationItem(
    InformationDto informationDto, BuildContext context) {
  return SizedBox(
    height: 200,
    width: 200,
    child: Container(
      color: Colors.amber,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Column(
            children: <Widget>[
              Image(
                image: AssetImage(
                  "assets/images/nature/${informationDto.imageUrl}",
                ),
                height: 200,
                width: 200,
                fit: BoxFit.fill,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformationDetail(
                        informationDto: InformationDto(
                            title: informationDto.title,
                            body: informationDto.body),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xffefefef)),
                  child: Center(
                    child: Text(
                      informationDto.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 175,
            right: 25,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 0, color: Colors.blueGrey)],
                  shape: BoxShape.circle,
                  color: Colors.white),
              child: Icon(
                Icons.bookmark_border,
                size: 25,
                color: Colors.orange.shade400,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _getTravelDestinations(
    Future<List<InformationDto>> _informationListFuture) {
  return FutureBuilder(
    future: _informationListFuture,
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        case ConnectionState.waiting:
          return CircularProgressIndicatorControl();
          break;
        case ConnectionState.done:
          if (snapshot.hasError) {
            return Text(snapshot.error);
          } else {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
                    child: _getSingleInformationItem(
                        snapshot.data[index], context),
                  );
                });
          }
          break;
        default:
          return CircularProgressIndicatorControl();
      }
    },
  );
}
