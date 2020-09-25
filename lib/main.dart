import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<LittleLink> createLink(String url) async {
  final http.Response response = await http.post(
    'http://10.0.2.2:8080/setSmall',
//    headers: <String, String>{
//      'Content-Type': 'application/x-www-form-urlencoded',
//    },
    body:{'link' : url},
  );

  if (response.statusCode == 200) {
    return LittleLink.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed!');
  }
}

class LittleLink {
  final String short;

  LittleLink({this.short});

  factory LittleLink.fromJson(Map<String, dynamic> json) {
    return LittleLink(
      short: json['short'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Link',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _textString = 'Enter your URL';
  final TextEditingController _controller = TextEditingController();
  Future<LittleLink> _futureLittleLink;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Link',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Little Link'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureLittleLink == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Enter URL'),
                    ),
                    RaisedButton(
                      child: Text('Get Short URL'),
                      onPressed: () {
                        setState(() {
                          _futureLittleLink = createLink(_controller.text);
                          _controller.clear();
                        });
                      },
                    ),
                  ],
                )
              : FutureBuilder<LittleLink>(
                  future: _futureLittleLink,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.short);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}
