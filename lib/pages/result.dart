import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forklardet/components/numbered_meaning.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class ResultPage extends StatefulWidget {
  static const id = 'result';
  final String query;

  const ResultPage({Key? key, required this.query}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String _word = '';
  String _origin = '';
  String _originText = '';
  List<String> _meanings = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _scrapeWord(widget.query);
  }

  Future<void> _scrapeWord(String query) async {
    final url = Uri.parse('https://ordnet.dk/ddo/ordbog?query=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final document = parse(response.body);

        // Extract word
        final wordElement = document.querySelector('.definitionBoxTop .match');
        if (wordElement == null) {
          setState(() {
            _errorMessage = 'No word found for: $query';
            _isLoading = false;
          });
          return;
        }

        // Extract origin
        final originElement = document.querySelector('#id-ety .stempel');
        final originTextElement =
            document.querySelector('#id-ety .tekstmedium.allow-glossing');

        // Extract meanings
        final meaningElements =
            document.querySelectorAll('#content-betydninger .definition');

        if (meaningElements.isEmpty) {
          setState(() {
            _errorMessage = 'No meanings found for the word: $query';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _word = wordElement.text.trim();
          _origin = originElement?.text.trim() ?? 'No origin';
          _originText = originTextElement?.text.trim() ?? 'No origin text';
          _meanings = meaningElements.map((e) => e.text.trim()).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to retrieve the page. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Search',
        middle: Text('Result'),
      ),
      child: Center(
        child: _isLoading
            ? const CupertinoActivityIndicator()
            : _errorMessage.isNotEmpty
                ? Text(_errorMessage)
                : ListView(
                    children: [
                      SizedBox(height: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _word.trim(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 40,
                                  color: CupertinoColors.black,
                                ),
                          ),
                          const SizedBox(height: 24),
                          if (_originText.isNotEmpty)
                            Text(
                              _origin,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    color: CupertinoColors.black,
                                  ),
                            ),
                          if (_originText.isNotEmpty)
                            Text(
                              _originText,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: CupertinoColors.black,
                                  ),
                            ),
                          const SizedBox(height: 40),
                          Text(
                            'Betydning',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: CupertinoColors.black,
                                ),
                          ),
                          for (int i = 0; i < _meanings.length; i++)
                            NumberedMeaning(
                              number: i + 1,
                              meaning: _meanings[i],
                            ),
                          SizedBox(height: 40),
                          CupertinoButton(
                            child: Text('Try a new word'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}
