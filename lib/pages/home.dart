// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For handling key events
import 'package:forklardet/pages/result.dart';

class HomePage extends StatefulWidget {
  static const id = 'home';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_checkInput);
    _focusNode.addListener(_handleFocusChange);
  }

  void _checkInput() {
    setState(() {
      _isButtonEnabled = _controller.text.isNotEmpty;
    });
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      RawKeyboard.instance.addListener(_handleKeyEvent);
    } else {
      RawKeyboard.instance.removeListener(_handleKeyEvent);
    }
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter && _isButtonEnabled) {
        _performSearch();
      }
    }
  }

  void _performSearch() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return ResultPage(query: _controller.text);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_checkInput);
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Just a modern dictionary'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Search a word',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                    color: CupertinoColors.black,
                  ),
            ),
            SizedBox(height: 24),
            Container(
              constraints: BoxConstraints(
                  maxWidth: 400, minWidth: 240, maxHeight: 40, minHeight: 24),
              child: CupertinoTextField(
                controller: _controller,
                focusNode: _focusNode,
                placeholder: 'Write the word here...',
                placeholderStyle:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: CupertinoColors.systemGrey,
                        ),
                keyboardType: TextInputType.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CupertinoColors.activeBlue,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 24),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 400, minWidth: 240),
              child: CupertinoButton.filled(
                child: Text(
                  'Search',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: CupertinoColors.white,
                      ),
                ),
                onPressed: _isButtonEnabled ? _performSearch : null,
                disabledColor: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
