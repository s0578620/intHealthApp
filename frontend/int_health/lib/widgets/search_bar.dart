import 'package:flutter/material.dart';


class SearchBar extends StatefulWidget {
  final Function(String) updateSearchTerm;

  const SearchBar({Key? key, required this.updateSearchTerm}) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Wohin geht's?",
        ),
        onChanged: (value) {
          widget.updateSearchTerm(value);
        },
      ),
    );
  }
}
