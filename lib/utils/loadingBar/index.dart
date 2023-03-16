import "package:flutter/material.dart";

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic size = MediaQuery.of(context).size;
    return Stack(
      children: [
        const Opacity(
            opacity: 0.5,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.grey,
            )),
        Center(
          child: Container(
              width: size.width * 0.3,
              height: size.height * 0.15,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.height * 0.01),
                color: Colors.white,
              ),
              child: const Center(child: CircularProgressIndicator())),
        )
      ],
    );
  }
}
