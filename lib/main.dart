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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
      body: FutureBuilder(
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
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: Colors.red,
                    onRefresh: () async {
                      setState(() {
                        _informationListFuture = ApiUtilities.getInformations();
                      });
                    },
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InformationDetail(
                                      informationDto: InformationDto(
                                          title: snapshot.data[index].title,
                                          body: snapshot.data[index].body),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          Colors.black.withOpacity(1),
                                          BlendMode.dstATop),
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          snapshot.data[index].imageUrl)),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 300,
                                width: 200,
                                child: Center(
                                  child: Text(
                                    snapshot.data[index].title,
                                    style: TextStyle(
                                        fontSize: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                ),
                              ),
                            )),
                          );
                        }),
                  );
                }
                break;
              default:
                return CircularProgressIndicatorControl();
            }
          }),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
