import 'package:flutter/material.dart';

class SectionBody extends StatelessWidget {
  const SectionBody({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(text, style: theme.textTheme.bodyMedium),
    );
  }
}
