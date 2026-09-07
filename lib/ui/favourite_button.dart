import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteButton extends StatefulWidget {
  const FavouriteButton({required this.productId, super.key});

  final String productId;

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    context.read<ProductsBloc>().add(ToggleFavouriteEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      buildWhen: (ProductsState previous, ProductsState current) {
        return previous.favouriteIds.contains(widget.productId) !=
            current.favouriteIds.contains(widget.productId);
      },
      builder: (BuildContext context, ProductsState state) {
        final bool isFavourite = state.favouriteIds.contains(widget.productId);
        return Hero(
          tag: 'favourite_hero_${widget.productId}',
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: IconButton(
              icon: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_border,
                color: isFavourite
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: _handleTap,
            ),
          ),
        );
      },
    );
  }
}
