import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final double? hp;
  final double? wp;
  final ImageProvider<Object>? imgUrl;
  final BoxFit? fit;
  const CircleImage({
    Key? key,
    this.hp,
    this.wp,
    this.imgUrl,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hp,
      width: wp,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imgUrl!,
          fit: fit,
        ),
      ),
    );
  }
}
