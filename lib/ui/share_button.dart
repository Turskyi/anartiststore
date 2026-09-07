import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({required this.product, super.key});

  final Product product;

  void _onShare(BuildContext context) {
    final String url =
        '${constants.webAddress}/${constants.productsPath}/${product.id}';
    final String text = translate(
      'shareProductText',
      args: <String, String>{
        constants.nameKey: product.name,
        constants.urlKey: url,
      },
    );
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: translate('share'),
      onPressed: () => _onShare(context),
    );
  }
}
