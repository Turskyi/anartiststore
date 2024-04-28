import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/group/group_text.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:flutter/material.dart';

class GroupMenuPage extends StatelessWidget {
  const GroupMenuPage({
    super.key,
    required this.currentCategory,
    required this.onCategoryTap,
  });

  final Group currentCategory;
  final ValueChanged<Group> onCategoryTap;
  final List<Group> _categories = Group.values;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 40.0),
        color: kAnArtistStoreBlue100,
        child: ListView(
          children: _categories
              .map(
                (Group category) => GroupText(
                  category: category,
                  currentCategory: currentCategory,
                  onCategoryTap: onCategoryTap,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
