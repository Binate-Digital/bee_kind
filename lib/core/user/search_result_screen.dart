import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Search Result",
      body: Center(child: Text("No Results Found")),
      appBarColor: Colors.white,
    );
  }
}
