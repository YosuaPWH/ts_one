import 'package:flutter/material.dart';

import '../theme.dart';

class SearchComponent extends StatefulWidget {
  const SearchComponent({super.key});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      cursorColor: TsOneColor.primary,
      decoration: InputDecoration(
        fillColor: TsOneColor.onPrimary,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: TsOneColor.primary),
        ),
        hintText: 'Search...',
        hintStyle: const TextStyle(
          color: TsOneColor.onSecondary,
        ),
        prefixIcon: Container(
          padding: const EdgeInsets.all(10),
          width: 32,
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
