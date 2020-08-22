import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final Color color;
  final int value;
  Badge({this.child, this.color, this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color ?? Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minHeight: 16,
              maxHeight: 16,
            ),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
