import 'package:flutter_translate/flutter_translate.dart';
import 'package:material_ui/material_ui.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(translate('retry')),
            ),
          ],
        ),
      ),
    );
  }
}
