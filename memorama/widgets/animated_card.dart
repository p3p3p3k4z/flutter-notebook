import 'dart:math';
import 'package:flutter/material.dart' hide Card;
import '../models/card_model.dart';

class AnimatedMemoryCard extends StatefulWidget {
  final Card card;
  final VoidCallback onTap;

  const AnimatedMemoryCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  State<AnimatedMemoryCard> createState() => _AnimatedMemoryCardState();
}

class _AnimatedMemoryCardState extends State<AnimatedMemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedMemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.isUp || widget.card.isMatched) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    // detener animacion
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _rotation,
        builder: (context, child) {
          final isFront = _rotation.value > (pi / 2);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(_rotation.value), //rotacion
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                isFront ? widget.card.imagePath : 'assets/images/back.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
