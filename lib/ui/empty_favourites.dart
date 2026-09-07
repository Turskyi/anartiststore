import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

class EmptyFavourites extends StatelessWidget {
  const EmptyFavourites({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite_outline,
              size: 100,
              color: theme.colorScheme.secondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              translate('favourites_empty_title'),
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              translate('favourites_empty_message'),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<ProductsBloc>().add(
                  const ShowGroupEvent(Group.all),
                );
              },
              child: Text(translate('go_to_catalog')),
            ),
          ],
        ),
      ),
    );
  }
}
