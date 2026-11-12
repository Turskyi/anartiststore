import 'dart:io';

import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, this.error, this.stackTrace});

  final Object? error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translate('error')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(translate('errorOccurred')),
          const SizedBox(height: 8),
          Text('$error'),
          if (stackTrace != null) ...<Widget>[
            const SizedBox(height: 16),
            Text(translate('stacktrace')),
            const SizedBox(height: 8),
            Text('$stackTrace'),
          ],
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(translate('ok')),
        ),
        TextButton(
          child: Text(translate('provideFeedback')),
          onPressed: () async {
            final PackageInfo packageInfo = await PackageInfo.fromPlatform();
            if (context.mounted) {
              BetterFeedback.of(context).show((UserFeedback feedback) {
                return _sendFeedback(
                  feedback: feedback,
                  packageInfo: packageInfo,
                );
              });
            }
          },
        ),
      ],
    );
  }

  Future<void> _sendFeedback({
    required UserFeedback feedback,
    required PackageInfo packageInfo,
  }) async {
    final String screenshotFilePath = await _writeImageToStorage(
      feedback.screenshot,
    );
    await FlutterEmailSender.send(
      Email(
        body:
            '${feedback.text}\n\n${packageInfo.packageName}\n'
            '${packageInfo.version}\n'
            '${packageInfo.buildNumber}',
        subject:
            '${translate('appFeedback')}: '
            '${packageInfo.appName}',
        recipients: <String>[constants.techSupportEmail],
        attachmentPaths: <String>[screenshotFilePath],
      ),
    );
  }

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
