import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:flutter/material.dart';

class GroupText extends StatelessWidget {
  const GroupText({
    super.key,
    required this.category,
    required this.currentCategory,
    required this.onCategoryTap,
  });

  final Group category;
  final Group currentCategory;
  final ValueChanged<Group> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final String categoryString = category
        .toString()
        .replaceAll(
          'Group.',
          '',
        )
        .toUpperCase();
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => onCategoryTap(category),
      child: category == currentCategory
          ? Column(
              children: <Widget>[
                const SizedBox(height: 16.0),
                Text(
                  categoryString,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14.0),
                Container(
                  width: 70.0,
                  height: 2.0,
                  color: kAnArtistStorePink400,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                categoryString,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: kAnArtistStoreBrown900.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
