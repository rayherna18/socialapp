import 'package:flutter/material.dart';
import 'package:socialapp/pages/chat_screen.dart';

class SearchUser extends SearchDelegate<String> {
  List<String> searchList;

  SearchUser(this.searchList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => {
          query = '',
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<String> searchResults = searchList
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: const CircleAvatar(),
        title: Text(
          searchResults[index],
          style: const TextStyle(fontSize: 20),
        ),
        onTap: () {
          // Navigate to dm_screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ChatPage(
                userName: searchResults[index],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestion = query.isEmpty
        ? []
        : searchList
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) => ListTile(
        leading: const CircleAvatar(
          radius: 10.0,
        ),
        title: Text(
          suggestion[index],
        ),
        onTap: () {
          query = suggestion[index];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => ChatPage(
                userName: suggestion[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
