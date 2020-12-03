import 'package:flutter/material.dart';
import 'package:just_sell_it/const.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    final product =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: kBackgroundColor,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                Consumer<Cart>(
                  builder: (ctx, cart, ch) => Badge(
                    color: kPrimaryColor,
                    child: ch,
                    value: cart.quantity.toString(),
                  ),
                  child: IconButton(
                    color: kAccentColor,
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                    iconSize: 26,
                  ),
                ),
              ],
              brightness: Brightness.light,
              pinned: true,
              expandedHeight: 350,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Card(
                    margin: EdgeInsets.all(10),
                    elevation: 10,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text(
                            product.title,
                            style: TextStyle(
                              color: kColor,
                              fontSize: 24,
                              fontFamily: 'Anton',
                            ),
                          ),
                          Spacer(),
                          Text(
                            '₹${product.price}',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 24,
                              fontFamily: 'Anton',
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 1000),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kColor,
        splashColor: kColor,
        hoverColor: kColor,
        focusColor: kColor,
        elevation: 60,
        focusElevation: 5,
        highlightElevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        label: Text(
          'Add To Cart',
          style: TextStyle(
            fontFamily: 'Anton',
            fontSize: 18,
            letterSpacing: 1.5,
          ),
        ),
        icon: Icon(
          Icons.shopping_cart,
          size: 32,
        ),
        onPressed: () {
          cart.addItem(
            product.title,
            product.price,
            product.id,
            product.imageUrl,
          );
          // Scaffold.of(context).hideCurrentSnackBar();
          // Scaffold.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Product Added'),
          //     duration: Duration(seconds: 1),
          //     action: SnackBarAction(
          //       label: 'UNDO',
          //       onPressed: () {
          //         cart.removeSingleItem(product.id);
          //       },
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
