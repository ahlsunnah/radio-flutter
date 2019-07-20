import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_radio/flutter_radio.dart';

import 'Station.dart';
import 'api_call.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var stations = List<Station>();
  bool isPlaying;

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
    playingStatus();
  }

  /* Build Stations List Widget */
  Widget _buildStations() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: stations.length,
        itemBuilder: (context, i) {
          /* Return custom row for each stations */
          return _buildRow(stations[i]);
        });
  }

  /* Build custom row for ListView */
  Widget _buildRow(Station station) {
    return Card(
        child: ListTile(
      leading: new CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.network(URL + station.img),
      ),
      onTap: () {
        FlutterRadio.playOrPause(url: station.url);
        playingStatus();
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

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Ahl-Sunnah Radio'),
        ),
        body: _buildStations(),
      ),
    );
  }

  /* Set Play status */
  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      isPlaying = isP;
    });
  }
}
