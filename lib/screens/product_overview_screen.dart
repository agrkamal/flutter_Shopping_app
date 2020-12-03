import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import './cart_screen.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../const.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFav = false;
  var isLoading = false;
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void showFav() {
    setState(() {
      _showFav = !_showFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(
              'Sell It  ',
              style: TextStyle(color: kColor, fontWeight: FontWeight.w700),
            ),
            Icon(
              Icons.check,
              color: kColor,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
               Icons.turned_in,
              color: _showFav ? Colors.red.shade300 : kColor,
            ),
            onPressed: showFav,
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) => Badge(
              child: ch,
              value: cart.quantity.toString(),
              color: kBackgroundColor,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: kColor,
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFav),
    );
  }
}
