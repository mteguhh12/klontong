import 'package:flutter/material.dart';
import 'gradient_circular_progress_indicator.dart';

class PendingAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: GradientCircularProgressIndicator(),
        ),
        ModalBarrier(
          dismissible: false,
          color: Colors.black.withOpacity(0.2),
        ),
      ],
    );
  }
}
