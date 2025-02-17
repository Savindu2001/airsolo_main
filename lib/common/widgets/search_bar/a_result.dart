import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  final String place;
  final DateTime? date;
  final int guests;

  SearchResultScreen({required this.place, required this.date, required this.guests});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Search Results")),
      body: Center(
        child: Text("Searching for $place on ${date?.toLocal().toString().split(' ')[0]} for $guests guests..."),
      ),
    );
  }
}
