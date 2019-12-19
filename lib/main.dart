import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RandomWords();
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _textStyle = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: () => _openFavourites(context),)
        ],
      ),
      body: Center(
        child: _buildSuggestions(),
      ),
    );
  }

  void _openFavourites(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FavouritesScreen(favourites: _saved.toList()),
      )
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair suggestion) {
    final saved = _saved.contains(suggestion);
    return ListTile(
      title: Text(
        suggestion.asPascalCase,
        style: _textStyle,
      ),
      trailing: IconButton(
        icon: Icon(
          saved ? Icons.favorite : Icons.favorite_border,
          color: saved ? Colors.red : null,
        ),
        onPressed: () {
          setState(() {
            if (saved) {
              _saved.remove(suggestion);
            } else {
              _saved.add(suggestion);
            }
          });
        },
      ),
    );
  }
}

class FavouritesScreen extends StatelessWidget {
  final List<WordPair> favourites;
  
  FavouritesScreen({ Key key, @required this.favourites}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Suggestions'),),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: () {
          final Iterable<ListTile> pairs = favourites.map((pair) => ListTile(
            title: Text(pair.asPascalCase),
          ));

          return ListTile.divideTiles(
            context: context,
            tiles: pairs
          ).toList();
        }()
      )
    );
  }
}