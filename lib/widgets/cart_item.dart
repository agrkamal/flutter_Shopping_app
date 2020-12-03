import 'package:flutter/material.dart';
import 'package:just_sell_it/const.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  final String prodId;
  final double price;
  final int quantity;

  const CartItem({
    @required this.imageUrl,
    @required this.price,
    @required this.quantity,
    @required this.title,
    @required this.id,
    @required this.prodId,
  });
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          child: AlertDialog(
            backgroundColor: kBackgroundColor,
            title: Text('Are You Sure'),
            content: Text('Remove Product From The Cart'),
            actions: <Widget>[
              FlatButton(
                textColor: kAccentColor,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              FlatButton(
                textColor: kAccentColor,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Sure',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      background: Container(
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: kBackgroundColor,
          ),
          title: Text(title),
          subtitle: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Amount:  ₹$price'),
                Text('Quantity: ${quantity}x'),
              ],
            ),
          ),
          trailing: Text('Total:  ₹${price * quantity}'),
        ),
      ),
    );
  }
}
