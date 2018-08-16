import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;

void main() async {
  _data = await getQuakes();
  _features = _data['features'];
  //print(_data['features'][0]['properties']);

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
  ));
}


class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(15.0),

            itemBuilder: (BuildContext context, int position) {
              //creating the rows for ListView

              if (position.isOdd) return new Divider();
              final index = position ~/
                  2; // dividing position by 2 and returning an integer result

              var format = new DateFormat("yMd").add_jm();

              var date = format.format(new DateTime.fromMillisecondsSinceEpoch(
                  _features[index]['properties']['time'],
                  isUtc: true));

              return new ListTile(
                title: new Text("Time: $date",
                  style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.blueGrey.shade700,
                    fontWeight: FontWeight.w800,
                  ),),
                subtitle: new Text(
                  "Location: ${_features[index]['properties']['place']}",
                  style: new TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontStyle: FontStyle.italic
                  ),),

                leading: new CircleAvatar(
                  backgroundColor: Colors.brown,
                  child: new Text("${_features[index]['properties']['mag']}",
                    style: new TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontStyle: FontStyle.normal
                    ),),
                ),

                onTap: () {
                  _showAlerMesaage(
                      context, "${_features[index]['properties']['title']}");
                },
              );
            }),
      ),
    );
  }

  void _showAlerMesaage(BuildContext context, String message) {
    var alert = new AlertDialog(
      title: new Text('Quakes'),
      content: new Text(message),
      actions: <Widget>[
        new FlatButton(onPressed: () {
          Navigator.pop(context);
        },
            child: new Text('Ok'))
      ],
    );
    showDialog(context: context, child: alert);
  }

}

Future<Map> getQuakes() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}