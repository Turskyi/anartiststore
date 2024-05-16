import 'dart:io';
import 'dart:typed_data';

import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('info')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(translate('company'), style: const TextStyle(fontSize: 20)),
          ListTile(
            title: Text(translate('about')),
            onTap: () => launchUrl(Uri.parse(constants.aboutUsUrl)),
          ),
          ListTile(
            title: Text(translate('press_kit')),
            onTap: () => launchUrl(Uri.parse(constants.pressKitUrl)),
          ),
          ListTile(
            title: Text(translate('contact')),
            onTap: () => launchUrl(Uri.parse(constants.contactUsUrl)),
          ),
          ListTile(
            title: Text(translate('report_problem')),
            onTap: () => _onReportPressed(context),
          ),
          Text(translate('legal'), style: const TextStyle(fontSize: 20)),
          ListTile(
            title: Text(translate('terms_of_use')),
            onTap: () => launchUrl(Uri.parse(constants.termsOfUseUrl)),
          ),
          ListTile(
            title: Text(translate('privacy_policy')),
            onTap: () => launchUrl(Uri.parse(constants.privacyPolicyUrl)),
          ),
          Text(translate('follow_us'), style: const TextStyle(fontSize: 20)),
          ListTile(
            title: const Text('Instagram'),
            onTap: () => launchUrl(Uri.parse(constants.instagramUrl)),
          ),
          ListTile(
            title: const Text('Flickr'),
            onTap: () => launchUrl(Uri.parse(constants.flickrUrl)),
          ),
          Text(
            translate('official_website'),
            style: const TextStyle(fontSize: 20),
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Image.asset(
                  constants.logoWithoutBgPath,
                  width: 168.0,
                ),
                const SizedBox(width: 8.0),
                const Text(constants.appName),
              ],
            ),
            onTap: () => launchUrl(Uri.parse(constants.webAddress)),
          ),
        ],
      ),
    );
  }

  Future<void> _onReportPressed(BuildContext context) =>
      PackageInfo.fromPlatform().then(
        (PackageInfo packageInfo) => BetterFeedback.of(context).show(
          (UserFeedback feedback) => _sendFeedback(
            feedback: feedback,
            packageInfo: packageInfo,
          ),
        ),
      );

  Future<void> _sendFeedback({
    required UserFeedback feedback,
    required PackageInfo packageInfo,
  }) =>
      _writeImageToStorage(feedback.screenshot)
          .then((String screenshotFilePath) {
        return FlutterEmailSender.send(
          Email(
            body: '${feedback.text}\n\nApp id: ${packageInfo.packageName}\n'
                'App version: ${packageInfo.version}\n'
                'Build number: ${packageInfo.buildNumber}',
            subject: '${translate('app_feedback')}: '
                '${packageInfo.appName}',
            recipients: <String>[constants.techSupportEmail],
            attachmentPaths: <String>[screenshotFilePath],
          ),
        );
      });

  Future<String> _writeImageToStorage(Uint8List feedbackScreenshot) async {
    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/feedback.png';
    final File screenshotFile = File(screenshotFilePath);
    await screenshotFile.writeAsBytes(feedbackScreenshot);
    return screenshotFilePath;
  }
}
