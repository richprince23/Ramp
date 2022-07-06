import 'package:flutter/material.dart';

import '../styles/style.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController? controller;

  final double? height;

  const SearchBar({Key? key, this.controller, this.height}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
          enableSuggestions: true,
          controller: widget.controller,
          style: TextStyle(
              color: darkTheme.colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontFamily: "Raleway"),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            fillColor: Colors.transparent,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: darkTheme.colorScheme.surfaceVariant,
                  width: 1,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                  color: darkTheme.colorScheme.onBackground,
                  width: 2,
                )),
          )),
    );
  }
}
