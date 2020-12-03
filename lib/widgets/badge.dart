import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final String value;
  final Color color;
  final Widget child;
  const Badge({
    @required this.child,
    @required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        child,
        if (int.parse(value) >= 1)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                color: color == null ? Theme.of(context).accentColor : color,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minHeight: 18,
                minWidth: 18,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
