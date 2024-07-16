import 'dart:collection';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'GachaSim',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  final AudioPlayer player = AudioPlayer();
  final String _audioPath = "audio/gacha_sfx.mp3";
  String _defaultImgPath = 'assets/images/crystal.png';
  static const _bonus = 65;
  int _guaranteeCount = 0;
  int _pityBonus = 0;
  int _visiblePity = 0;
  double _defaultOpacity = 0;
  final Queue <String> _imageArrayPath = Queue<String>();

  void _pullGacha(int amount) {
    setState(() {
      _defaultOpacity = 1;
      for(int _pullCount = 0; _pullCount < amount; _pullCount++){
        totalPity++;
        _pityBonus = getPityBonus();
        _guaranteeCount++;
        var _result = 0;
        _result = Random().nextInt(1000)+1;
        //then try for aponia
        //print("chance is "+((15+(_pityBonus*_bonus))/10).toString()+"%");
        if(_result<=15+(_pityBonus*_bonus)){
          getAponia();
        }
        else if(_guaranteeCount==10){
          //get guarantee
          int _temp = Random().nextInt(9)+1;
          if(_temp<=3){
            getRaven();
          }
          else if(_temp<=5){
            getHua();
          }
          else if (_temp<=7){
            getRita();
          }
          else {
            getDudu();
          }
        }
        else {
          //normal roll
          int _temp = Random().nextInt(985)+1;
          if(_temp<=45){
            getRaven();
          }
          else if(_temp<=75){
            getHua();
          }
          else if(_temp<=105){
            getRita();
          }
          else if(_temp<=135){
            getDudu();
          }
          else {
            getMaterials();
          }
        }
      }

    });
  }

  void getAponia(){
    print("Aponia get at "+totalPity.toString());
    totalPity = 0;
    _guaranteeCount = 0;
    _imageArrayPath.add('assets/images/valk.png');
    _imageArrayPath.add('assets/images/aponia_result.png');
  }
  void getRaven(){
    _guaranteeCount = 0;
    _imageArrayPath.add('assets/images/valk.png');
    _imageArrayPath.add('assets/images/raven_result.png');
  }
  void getHua(){
    _guaranteeCount = 0;
    _imageArrayPath.add('assets/images/valk.png');
    _imageArrayPath.add('assets/images/hua_result.png');
  }
  void getRita(){
    _guaranteeCount = 0;
    _imageArrayPath.add('assets/images/valk.png');
    _imageArrayPath.add('assets/images/rita_result.png');
  }
  void getDudu(){
    _guaranteeCount = 0;
    _imageArrayPath.add('assets/images/valk.png');
    _imageArrayPath.add('assets/images/dudu_result.png');
  }
  void getMaterials(){
    _imageArrayPath.add('assets/images/material.png');
    _imageArrayPath.add('assets/images/material_result.png');
  }
  int getPityBonus(){
    if(totalPity>=75){
      return totalPity-75;
    }
    else {
      return 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  playSfx() async {
    await player.play(AssetSource(_audioPath));
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/aponia_bg.png"),fit: BoxFit.cover)
        ),
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: screenWidth,
                  minHeight: screenHeight - 250,
                  maxWidth: screenWidth,
                  maxHeight: screenHeight - 250,
                ),
                child: InkWell(
                  child: Opacity(
                    opacity: _defaultOpacity,
                    child: Image.asset(_defaultImgPath, scale: 0.5),
                  ),
                  onTap: (){
                    if(_imageArrayPath.isNotEmpty){
                      setState(() {
                        if(_defaultImgPath!=_imageArrayPath.first){
                          _defaultImgPath = _imageArrayPath.first;
                          _imageArrayPath.removeFirst();
                        }
                        else {
                          _imageArrayPath.removeFirst();
                          _defaultImgPath = "assets/images/crystal.png";
                        }
                        if(_defaultImgPath!='assets/images/material.png' &&
                            _defaultImgPath!='assets/images/valk.png'){
                          playSfx();
                          if(_defaultImgPath!='assets/images/aponia_result.png'){
                            setState(() {
                              _visiblePity++;
                            });
                          }
                          else{
                            setState(() {
                              _visiblePity = 0;
                            });
                          }
                        }
                      });
                    }
                    else {
                      setState(() {
                        _defaultOpacity = 0;
                      });
                    }

                },
                ),
              ),
              ConstrainedBox(constraints: BoxConstraints(
                maxHeight: screenHeight/35,
                minHeight: screenHeight/35
              )),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 80,
                    child: TextButton(
                      child: Column(
                        children: [Row(
                          children: [Text("1x Supply", style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1), letterSpacing: -0.5),)],
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                        ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFdfbb38),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/crystal.png', scale: 2.5,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Text("x280", style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.bold, foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..color = Colors.black.withOpacity(0.2)
                                      ..strokeWidth = 2,
                                        letterSpacing: -0.5), textAlign: TextAlign.center, ),
                                    const Text("x280", style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white,
                                        letterSpacing: -0.5), textAlign: TextAlign.center, )
                                  ],
                                )],
                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                            ),
                          )],
                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(const Color(0xFFfee14a))
                      ),
                      onPressed: (){
                        if(_imageArrayPath.isEmpty){
                          _pullGacha(1);
                          _defaultImgPath = _imageArrayPath.first;
                          _imageArrayPath.removeFirst();
                        }
                      },
                    ),
                  ),
                  const Spacer(flex: 1,),
                  SizedBox(
                    width: 150,
                    height: 80,
                    child: TextButton(
                      child: Column(
                        children: [Row(
                          children: [Text("10x Supply", style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(1), letterSpacing: -0.5),)],
                          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                        ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFdfbb38),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/images/crystal.png', scale: 2.5,),
                                const SizedBox(
                                  width: 10,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Text("x2800", style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.bold, foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..color = Colors.black.withOpacity(0.2)
                                      ..strokeWidth = 2,
                                        letterSpacing: -0.5), textAlign: TextAlign.center, ),
                                    const Text("x2800", style: TextStyle(
                                        fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white,
                                        letterSpacing: -0.5), textAlign: TextAlign.center, )
                                  ],
                                )],
                              mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                            ),
                          )],
                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                      ),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(const Color(0xFFfee14a))
                      ),
                      onPressed: (){
                        if(_imageArrayPath.isEmpty){
                          _pullGacha(10);
                          _defaultImgPath = _imageArrayPath.first;
                          _imageArrayPath.removeFirst();
                        }
                      },
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
              Stack(
                children: <Widget>[
                  Text("Current Pity:", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..color = Colors.white.withOpacity(1)
                    ..strokeWidth = 3,
                      letterSpacing: -0.5),
                  ),
                const Text("Current Pity:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5)
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Text(_visiblePity.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..color = Colors.white.withOpacity(1)
                    ..strokeWidth = 3,
                      letterSpacing: -0.5),
                  ),
                  Text(_visiblePity.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: -0.5)
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
