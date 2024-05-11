import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
            title: Text(translate('contact')),
            onTap: () => launchUrl(Uri.parse(constants.contactUsUrl)),
          ),
          ListTile(
            title: Text(translate('press_kit')),
            onTap: () => launchUrl(Uri.parse(constants.pressKitUrl)),
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
}
