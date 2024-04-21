import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          const Text('Company', style: TextStyle(fontSize: 20)),
          ListTile(
            title: const Text('About us'),
            onTap: () =>
                launchUrl(Uri.parse('https://an-artist.store/about-us')),
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () =>
                launchUrl(Uri.parse('https://an-artist.store/contact')),
          ),
          ListTile(
            title: const Text('Press kit'),
            onTap: () =>
                launchUrl(Uri.parse('https://an-artist.store/press-kit')),
          ),
          const Text('Legal', style: TextStyle(fontSize: 20)),
          ListTile(
            title: const Text('Terms of use'),
            onTap: () =>
                launchUrl(Uri.parse('https://an-artist.store/terms-of-use')),
          ),
          ListTile(
            title: const Text('Privacy policy'),
            onTap: () =>
                launchUrl(Uri.parse('https://an-artist.store/privacy-policy')),
          ),
          ListTile(
            title: const Text('Cookie policy'),
            onTap: () =>
                launchUrl(Uri.parse('https://an-artist.store/cookie-policy')),
          ),
          const Text('Follow Us', style: TextStyle(fontSize: 20)),
          ListTile(
            title: const Text('Instagram'),
            onTap: () => launchUrl(Uri.parse('https://www.instagram.com')),
          ),
          ListTile(
            title: const Text('Flickr'),
            onTap: () => launchUrl(Uri.parse('https://www.flickr.com')),
          ),
        ],
      ),
    );
  }
}
