import 'dart:convert';

import 'package:ahlsunnah_radio_app_flutter/control_button.dart';
import 'package:ahlsunnah_radio_app_flutter/station.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'Station.dart';
import 'api_call.dart';
import 'control_button.dart';
import 'flutter_radio.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bottomSheetState = new GlobalKey<ScaffoldState>();
  final ValueNotifier<bool> onPlay = ValueNotifier<bool>(false);
  var stations = List<Station>();
  bool isPlaying = false;
  int index = -1;

  /* Get Stations from API and insert it to stations (List<Stations>) */
  getStations() {
    fetchStations().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        stations = list.map((model) => Station.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getStations();
    audioStart();
    playingStatus(-1);
  }

  /* Build Stations List Widget */
  Widget _buildStations() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: stations.length,
        itemBuilder: (context, i) {
          /* Return custom row for each stations */
          return _buildRow(stations[i], i);
        });
  }

  /* Build custom row for ListView */
  Widget _buildRow(Station station, int index) {
    if (this.index == index && this.index != -1) {
      return Card(
          child: ListTile(
        leading: new CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(URL + station.img),
        ),
        onTap: () {
          FlutterRadio.playOrPause(url: station.url).whenComplete(() {
            playingStatus(index);
            showBottomSheet(index);
          });
        },
        trailing: Icon(
          Icons.pause_circle_filled,
          size: 30,
        ),
        subtitle: Text(
          station.url,
          style: TextStyle(fontSize: 12.0),
        ),
        title: Text(
          station.name,
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    } else {
      return Card(
          child: ListTile(
        leading: new CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(URL + station.img),
        ),
        onTap: () {
          FlutterRadio.playOrPause(url: station.url).whenComplete(() {
            playingStatus(index);
            showBottomSheet(index);
          });
        },
        subtitle: Text(
          station.url,
          style: TextStyle(fontSize: 12.0),
        ),
        title: Text(
          station.name,
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        key: bottomSheetState,
        appBar: new AppBar(
          title: const Text('راديو الإسلام'),
        ),
        body: _buildStations(),
      ),
    );
  }

  /* Set Play status */
  Future playingStatus(int index) async {
    await FlutterRadio.isPlaying().whenComplete(() {
      setState(() {
        isPlaying = !isPlaying;
        //onPlay.value = !onPlay.value;
        this.index = index;
      });
    });
//    setState(() {
//      isPlaying = isP;
//      this.index = index;
//    });
  }

  void showBottomSheet(int index) {
    final player = GlobalKey();
    bottomSheetState.currentState.showBottomSheet((context) {
      return new Container(
          padding: new EdgeInsets.all(20.0),
          margin: new EdgeInsets.only(top: 50),
          child: new Column(children: [
            new Column(
              children: <Widget>[
                new Image.network(
                  URL + stations[index].img,
                  height: 70,
                  width: 70,
                ),
                new Text(
                  stations[index].name,
                  style: Theme.of(context).textTheme.headline,
                ),
                new Text(
                  stations[index].name,
                  style: Theme.of(context).textTheme.caption,
                ),
                new Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                )
              ],
            ),
            new Center(
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new IconButton(
                      icon: Icon(Icons.skip_previous),
                      onPressed: () {
                        FlutterRadio.playOrPause(url: stations[index - 1].url);
                      },
                    ),
                    /*
                key: player,
                    icon: Icon(onPlay.value ? Icons.pause : Icons.play_arrow),
                    onPressed: () {
                      FlutterRadio.playOrPause(url: stations[index].url)
                      .whenComplete((){
                        onPlay.value = !onPlay.value;
                        reassemble();
                        print("refresh");
                      });
                 */
                    new IconButton(
                        icon:
                            Icon(onPlay.value ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          FlutterRadio.playOrPause(url: stations[index].url)
                              .whenComplete(() {
                            onPlay.value = !onPlay.value;
                            reassemble();
                            print("refresh");
                          });
                        }),
                    new IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: () {
                        FlutterRadio.playOrPause(url: stations[index + 1].url);
                      },
                    ),
                  ]),
            ),

            new Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
            ),
//            new Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                new IconButton(
//                    icon: isMuted
//                        ? new Icon(
//                      Icons.headset,
//                      color: Theme.of(context).unselectedWidgetColor,
//                    )
//                        : new Icon(Icons.headset_off,
//                        color: Theme.of(context).unselectedWidgetColor),
//                    color: Theme.of(context).primaryColor,
//                    onPressed: () {
//                      mute(!isMuted);
//                    }),
//                // new IconButton(
//                //     onPressed: () => mute(true),
//                //     icon: new Icon(Icons.headset_off),
//                //     color: Colors.cyan),
//                // new IconButton(
//                //     onPressed: () => mute(false),
//                //     icon: new Icon(Icons.headset),
//                //     color: Colors.cyan),
//              ],
//            ),
          ]));
    },
        elevation: 5,
        backgroundColor: Color.alphaBlend(Colors.white, Colors.blue));
  }
}
