// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberedMeaning extends StatelessWidget {
  final int number;
  final String meaning;

  const NumberedMeaning({
    Key? key,
    required this.number,
    required this.meaning,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      constraints: const BoxConstraints(
        maxWidth: 400,
        minWidth: 240,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: CupertinoColors.white,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            meaning,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: CupertinoColors.black,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
