import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // border: Border.all(width: 1),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              );
            },
            color: Theme.of(context).accentColor,
            tooltip: 'Edit Product',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Product Deleted',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              } catch (error) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Some Thing Went Wrong',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
            color: Colors.red.shade300,
          ),
        ],
      ),
    );
  }
}
