import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/auth.dart';
import '../const.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final auth = Provider.of<Auth>(context, listen: false);
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Stack(
          // fit: StackFit.loose,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Container(
                width: constraints.minWidth * 1.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(blurRadius: 2, color: kAccentColor),
                  ],
                ),
              ),
            ),

            // IconButton(icon: null, onPressed: null),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                    arguments: product.id);
              },
              child: Container(
                padding: EdgeInsets.only(top: 13, bottom: 55),
                alignment: Alignment.centerRight,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Hero(
                    tag: product.id,
                    child: FadeInImage(
                      fit: BoxFit.fill,
                      fadeOutCurve: Curves.easeInSine,
                      alignment: Alignment.bottomCenter,
                      placeholder: AssetImage(''),
                      image: NetworkImage(product.imageUrl),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 8,
              // bottom: MediaQuery.of(context).size.height * 0.29,
              top: MediaQuery.of(context).size.height * 0.02,
              // top: 20,
              child: Consumer<Product>(
                builder: (ctx, product, ch) => GestureDetector(
                  onTap: () {
                    product.toggleFavoriteStatus(auth.token, auth.userId);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: kColor,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      child: Icon(
                        product.isFav ? Icons.turned_in : Icons.turned_in_not,
                        color: product.isFav
                            ? Colors.red.shade300
                            : Theme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              height: constraints.maxHeight * 0.2,
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                // height: 100,
                decoration: BoxDecoration(
                  color: kAccentColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kBackgroundColor,
                      ),
                    ),
                    Text(
                      '₹${product.price}',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Anton',
                        color: kColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
