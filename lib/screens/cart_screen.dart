import 'package:flutter/material.dart';
import 'package:just_sell_it/const.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';
// import '../providers/products.dart';
import '../widgets/product_grid.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context).favProd;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        actions: <Widget>[
          if (cart.itemCount > 0)
            FlatButton.icon(
              textColor: kColor,
              label: Text(
                'Clear',
                style: TextStyle(fontSize: 18),
              ),
              icon: Icon(
                Icons.clear_all,
                // color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                cart.clear();
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (ctx, cts) => cart.itemCount <= 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 120,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Empty Cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: kColor,
                      ),
                    ),
                    SizedBox(height: 20),
                    FlatButton.icon(
                      color: kPrimaryColor,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (ctx) => DraggableScrollableSheet(
                              maxChildSize: 1.0,
                              initialChildSize: 1.0,
                              minChildSize: 1.0,
                              expand: true,
                              builder: (ctx, scrollController) => SafeArea(
                                bottom: true,
                                top: false,
                                child: Scaffold(
                                  appBar: AppBar(),
                                  body: ProductGrid(true),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.turned_in,
                        color: kAccentColor,
                      ),
                      label: Text(
                        'Take A Look At Favorite Products',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: cts.maxHeight * 0.15,
                    child: Card(
                      color: kAccentColor,
                      margin: EdgeInsets.all(10),
                      // elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Cart Total Amount =',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Anton',
                                letterSpacing: 1,
                              ),
                            ),
                            Spacer(),
                            Chip(
                              label: Text(
                                '₹${cart.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: 'Anton',
                                    letterSpacing: 1.5,
                                    color: kColor),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: kBackgroundColor,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 0,
                    ),
                    height: cts.maxHeight * 0.7,
                    child: ListView.builder(
                      itemCount: cart.itemCount,
                      itemBuilder: (ctx, i) => Column(
                        children: <Widget>[
                          CartItem(
                            title: cart.items.values.toList()[i].title,
                            imageUrl: cart.items.values.toList()[i].imageUrl,
                            price: cart.items.values.toList()[i].price,
                            quantity: cart.items.values.toList()[i].quantity,
                            id: cart.items.values.toList()[i].id,
                            prodId: cart.items.keys.toList()[i],
                          ),
                          if (cart.itemCount >= 2)
                            Divider(
                              height: 0,
                              indent: 30,
                              endIndent: 30,
                              color: Colors.grey,
                            ),
                        ],
                      ),
                    ),
                  ),
                  OrderButton(
                    cart: cart,
                    cts: cts,
                  ),
                ],
              ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.cts,
  }) : super(key: key);

  final Cart cart;
  final BoxConstraints cts;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: kPrimaryColor,
            ),
          )
        : Container(
            height: widget.cts.maxHeight * 0.13,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                // side: BorderSide(width: 1,style: BorderStyle.none),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.all(20),
              // colorBrightness: Brightness.light,
              elevation: 10,
              color: kColor,
              onPressed: () async {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Orders>(context, listen: false).addorder(
                    widget.cart.totalAmount,
                    widget.cart.items.values.toList(),
                  );
                  widget.cart.clear();
                  setState(() {
                    _isLoading = false;
                  });
                } catch (error) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Some Thing Went Wrong'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.system_update_alt,
                color: kPrimaryColor,
              ),
              label: Text(
                'Place Order',
                style: TextStyle(
                  fontSize: 22,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
  }
}
