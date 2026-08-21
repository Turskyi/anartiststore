import 'package:anartiststore/enums/currency.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

class CurrencySelectorSheet extends StatelessWidget {
  const CurrencySelectorSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppStateModel model = ScopedModel.of<AppStateModel>(context);
    final Currency currentCurrency = model.selectedCurrency;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              translate('currency'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Currency.values.length,
              itemBuilder: (BuildContext context, int index) {
                final Currency currency = Currency.values[index];
                final bool isSelected = currency == currentCurrency;

                return ListTile(
                  leading: Text(
                    currency.symbol,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    '${currency.name} (${currency.code})',
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check, color: theme.colorScheme.primary)
                      : null,
                  onTap: () {
                    model.setCurrency(currency);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
