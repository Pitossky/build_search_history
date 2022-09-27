import 'package:flutter/material.dart';

class SearchResultsListview extends StatelessWidget {
  final String? searchTerm;

  const SearchResultsListview({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchTerm == null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.search,
                  size: 64,
                ),
                Text(
                  'Start searching',
                  style: Theme.of(context).textTheme.headline5,
                )
              ],
            ),
          )
        : ListView(
            children: List.generate(
              50,
              (index) => ListTile(
                title: Text('$searchTerm search result'),
                subtitle: Text(index.toString()),
              ),
            ),
          );
  }
}
