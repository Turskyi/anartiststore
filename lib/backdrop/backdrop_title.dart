import 'package:flutter/material.dart';

class BackdropTitle extends AnimatedWidget {
  const BackdropTitle({
    super.key,
    required Animation<double> super.listenable,
    required this.onMenuPressed,
    required this.frontTitle,
    required this.backTitle,
  }) : _listenable = listenable;
  final void Function() onMenuPressed;
  final Widget frontTitle;
  final Widget backTitle;

  final Animation<double> _listenable;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = _listenable;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.titleLarge!,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 72.0,
            child: IconButton(
              padding: const EdgeInsets.only(right: 8.0),
              onPressed: onMenuPressed,
              icon: Stack(
                children: <Widget>[
                  Opacity(
                    opacity: animation.value,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 12.0, left: 8),
                      child: Icon(
                        Icons.menu,
                        semanticLabel: 'menu',
                        size: 36,
                      ),
                    ),
                  ),
                  FractionalTranslation(
                    translation: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).evaluate(animation),
                    child: const ImageIcon(
                      AssetImage('assets/images/logo_without_bg.png'),
                      size: 60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Here, we do a custom cross fade between backTitle and frontTitle.
          // This makes a smooth animation between the two texts.
          Stack(
            children: <Widget>[
              Opacity(
                opacity: CurvedAnimation(
                  parent: ReverseAnimation(animation),
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0.5, 0.0),
                  ).evaluate(animation),
                  child: Semantics(
                    label: 'hide categories menu',
                    child: ExcludeSemantics(child: backTitle),
                  ),
                ),
              ),
              Opacity(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0),
                ).value,
                child: FractionalTranslation(
                  translation: Tween<Offset>(
                    begin: const Offset(-0.25, 0.0),
                    end: Offset.zero,
                  ).evaluate(animation),
                  child: Semantics(
                    label: 'show categories menu',
                    child: ExcludeSemantics(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60.0),
                        child: frontTitle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
