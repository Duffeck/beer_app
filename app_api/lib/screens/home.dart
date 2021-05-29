import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/beer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Beer> _beers = <Beer>[];

  @override
  void initState() {
    super.initState();
    listenForBeers();
  }

  void listenForBeers() async {
    final Stream<Beer> stream = await getBeers();
    stream.listen((Beer beer) => setState(() => _beers.add(beer)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Top Beers'),
        ),
        body: ListView.builder(
          itemCount: _beers.length,
          itemBuilder: (context, index) => Text(_beers[index].name),
        ),
      );
}

Future<Stream<Beer>> getBeers() async {
  final String url = 'https://api.punkapi.com/v2/beers';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((data) => (data as List))
      .map((data) => Beer.fromJSON(data));
}
