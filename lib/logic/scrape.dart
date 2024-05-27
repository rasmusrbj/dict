// ignore_for_file: prefer_const_declarations, avoid_print

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<void> scrapeWord(String query) async {
  final url = Uri.parse('https://ordnet.dk/ddo/ordbog?query=$query');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final document = parse(response.body);

    final wordElement = document.querySelector('h1.match');
    if (wordElement == null) {
      print('No word found for: $query');
      return;
    }

    final meaningElements = document.querySelectorAll('div.definition');
    if (meaningElements.isEmpty) {
      print('No meanings found for the word: $query');
      return;
    }

    print('Word: ${wordElement.text.trim()}');
    print('Meanings:');
    for (var meaning in meaningElements) {
      print('- ${meaning.text.trim()}');
    }
  } else {
    print('Failed to retrieve the page. Status code: ${response.statusCode}');
  }
}
