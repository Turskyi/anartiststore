import 'package:anartiststore/settings/widgets/section_body.dart';
import 'package:anartiststore/settings/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate('privacy_policy'))),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: <Widget>[
          SectionHeader(title: translate('privacy_intro_title')),
          SectionBody(text: translate('privacy_intro_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_platform_title')),
          SectionBody(text: translate('privacy_platform_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_collection_title')),
          SectionBody(text: translate('privacy_collection_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_usage_title')),
          SectionBody(text: translate('privacy_usage_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_sharing_title')),
          SectionBody(text: translate('privacy_sharing_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_rights_title')),
          SectionBody(text: translate('privacy_rights_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_cookies_title')),
          SectionBody(text: translate('privacy_cookies_text')),
          const SizedBox(height: 24),
          SectionHeader(title: translate('privacy_contact_title')),
          SectionBody(text: translate('privacy_contact_text')),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
