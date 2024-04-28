import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translate('confirmationEmailSent')),
      content: Text(translate('checkInboxAndSpam')),
      actions: <Widget>[
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(translate('ok')),
        ),
      ],
    );
  }
}
