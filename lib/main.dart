import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://randomuser.me/api?results=15';
  List data;

  Future<String> makeRequest() async {
    http.Response response;
    response = await http.get(Uri.encodeFull(url),
      headers: {
        "Accept": "application/json"
      }
    );

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata['results'];      
    });

    print(data[0]['name']);
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Contact List')
      ),
      body: new ListView.builder(
        itemCount: data == null? 0 : data.length,
        itemBuilder: (BuildContext context, i) {
          return new ListTile(
            title: new Text(data[i]['name']['first']),
            subtitle: new Text(data[i]['phone']),
            leading: new CircleAvatar(
              backgroundImage: new NetworkImage(data[i]['picture']['thumbnail']),
            ),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                  builder: (BuildContext context) =>
                    new SecondPage(data[i])
                )
              );
            },
          );
        },
      )
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text(data['name']['first']),
    ),
    body: new Center(
      child: new Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          color: Colors.blueGrey,
          image: new DecorationImage(
            image: new NetworkImage(data['picture']['large']),
            fit: BoxFit.cover
          ),
          borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
          border: new Border.all(
            color: Colors.blueGrey,
            width: 4.0
          )
        ),
      ),
    ),
  );
}