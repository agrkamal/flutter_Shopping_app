import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_sell_it/const.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem orderItem;
  final int index;
  OrderItem(this.orderItem, this.index);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.orderItem.products.length * 25.0 + 110, 200.0)
          : 85,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            leading: CircleAvatar(
              child: Text(
                '#${widget.index + 1}',
                style: TextStyle(color: kBackgroundColor),
              ),
              backgroundColor: kColor,
            ),
            title: Text('₹${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(!_expanded ? Icons.expand_more : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            curve: Curves.easeInOutQuad,
            duration: Duration(milliseconds: _expanded ? 700 : 200),
            // padding: EdgeInsets.only(right: 10),
            height: _expanded
                ? min(widget.orderItem.products.length * 15.0 + 30, 200.0)
                : 0,
            child: ListView(
              children: widget.orderItem.products
                  .map(
                    (prod) => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(width: 20),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 5),
                            Text(prod.title),
                            Text(
                                '₹${prod.price.toStringAsFixed(0)}  X ${prod.quantity}x  ='),
                          ],
                        ),
                        Spacer(),
                        Text('₹${prod.price * prod.quantity}')
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
