import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features; // features object list
void main() async {
  _data = await getQuakes();

  _features = _data['features'];

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
    theme: ThemeData(primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quake Quake'),
        centerTitle: true,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (BuildContext context, int position) {
              final index = position ~/ 2;

              var format = new DateFormat.yMMMMd("en_US").add_jm();
              //var dateString = format.format(date);
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(
                  _features[index]['properties']['time'] * 1000,
                  isUtc: true));

              return Card(
                margin: EdgeInsets.only(bottom: 20),
                child: new ListTile(
                  title: new Text(
                    " $date",
                    //title: new Text("Date: $date",
                    style: new TextStyle(
                        fontSize: 15.5,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: new Text(
                    "${_features[index]['properties']['place']}",
                    style: new TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                  ),
                  leading: new CircleAvatar(
                    radius: 25.00,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: new Text(
                      "${_features[index]['properties']['mag']}",
                      style: new TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  onTap: () {
                    _showAlertMessage(
                        context, "${_features[index]['properties']['title']}");
                  },
                ),
              );
            }),
      ),
    );
  }

  void _showAlertMessage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Quakes'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: new Text('OK'))
      ],
    );
    showDialog(context: context, child: alert);
  }
}

Future<Map> getQuakes() async {
  String apiUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';

  http.Response response = await http.get(apiUrl);

  return jsonDecode(response.body);
}
