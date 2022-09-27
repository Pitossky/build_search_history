import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:search_history_project/views/search_result_listview.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const searchHistoryLength = 5;
  final List<String> _searchHistoryList = [
    'Come',
    'Get',
    'Me',
    'Join',
    'Flutter',
  ];

  List<String>? filteredSearchHistoryList;

  String? selectedSearchTerm;

  List<String> filterSearchTerms({
    String? searchFilter,
  }) {
    if (searchFilter != null && searchFilter.isNotEmpty) {
      return _searchHistoryList.reversed
          .where((element) => element.startsWith(searchFilter))
          .toList();
    } else {
      return _searchHistoryList.reversed.toList();
    }
  }

  void addSearchTermToSearchHistoryList(String searchTerm) {
    if (_searchHistoryList.contains(searchTerm)) {
      putSearchTermFirst(searchTerm);
      return;
    }
    _searchHistoryList.add(searchTerm);
    if (_searchHistoryList.length > searchHistoryLength) {
      _searchHistoryList.removeRange(
          0, _searchHistoryList.length - searchHistoryLength);
    }

    filteredSearchHistoryList = filterSearchTerms(
      searchFilter: null,
    );
  }

  void deleteSearchTermFromSearchHistoryList(String searchTerm) {
    _searchHistoryList.removeWhere((e) => e == searchTerm);
    filteredSearchHistoryList = filterSearchTerms(
      searchFilter: null,
    );
  }

  void putSearchTermFirst(searchTerm) {
    deleteSearchTermFromSearchHistoryList(searchTerm);
    addSearchTermToSearchHistoryList(searchTerm);
  }

  late FloatingSearchBarController searchBarController;

  @override
  void initState() {
    super.initState();
    searchBarController = FloatingSearchBarController();
    filteredSearchHistoryList = filterSearchTerms(
      searchFilter: null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        controller: searchBarController,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListview(
            searchTerm: selectedSearchTerm!,
          ),
        ),
        builder: (_, anim) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistoryList!.isEmpty &&
                      searchBarController.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistoryList!.isEmpty) {
                    return ListTile(
                      title: Text(searchBarController.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTermToSearchHistoryList(
                              searchBarController.query);
                          selectedSearchTerm = searchBarController.query;
                        });
                        searchBarController.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistoryList!
                          .map((e) => ListTile(
                                title: Text(
                                  e,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  //style: Theme.of(context).textTheme.caption,
                                ),
                                leading: const Icon(Icons.history),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      deleteSearchTermFromSearchHistoryList(e);
                                    });
                                  },
                                 ),
                                onTap: () {
                                  setState(() {
                                    putSearchTermFirst(e);
                                    selectedSearchTerm = e;
                                  });
                                  searchBarController.close();
                                },
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
        transition: CircularFloatingSearchBarTransition(),
        physics: const BouncingScrollPhysics(),
        title: Text(
          selectedSearchTerm ?? 'Search App',
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search Now',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistoryList = filterSearchTerms(
              searchFilter: query,
            );
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTermToSearchHistoryList(query);
            selectedSearchTerm = query;
          });
          searchBarController.close();
        },
      ),
    );
  }
}
