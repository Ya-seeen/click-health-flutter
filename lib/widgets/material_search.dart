import 'package:flutter/material.dart';

class MaterialSearch extends StatefulWidget {
  final String searchHint;
  final ValueChanged<String> onQueryChanged;

  MaterialSearch({this.searchHint, @required this.onQueryChanged});

  @override
  State<StatefulWidget> createState() => MaterialSearchState();
}

class MaterialSearchState extends State<MaterialSearch> {
  TextEditingController _searchController;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _searchController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
          hintText: widget.searchHint,
          prefixIcon: Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? InkWell(
                  child: Icon(Icons.clear),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onQueryChanged("");

                    setState(() {
                      searchQuery = "";
                      _searchController.clear();
                    });
                  },
                )
              : null,
        ),
        onChanged: (query) {
          widget.onQueryChanged(query);

          setState(() {
            searchQuery = query;
          });
        },
      ),
    );
  }
}
