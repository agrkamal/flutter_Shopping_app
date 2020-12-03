import 'package:flutter/material.dart';
import 'package:just_sell_it/const.dart';
import 'package:provider/provider.dart';

import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';
import '../const.dart';

class MainDrawer extends StatelessWidget {
  Widget listTile(
      BuildContext context, IconData icon, String title, Function fn) {
    return Container(
      // color: kBackgroundColor,
      decoration:
          BoxDecoration(border: Border.all(width: 0.4, color: Colors.grey)),
      child: ListTile(
        leading: Icon(
          icon,
          color: kAccentColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: kColor,
          ),
        ),
        onTap: fn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration:
      //     BoxDecoration(border: Border.all(width: 3, color: kAccentColor)),
      width: MediaQuery.of(context).size.width * 0.7,
      // color: kBackgroundColor,
      child: Drawer(
        elevation: 100,
        child: Container(
          decoration: BoxDecoration(color: kBackgroundColor),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                backgroundColor: kPrimaryColor,
                automaticallyImplyLeading: false,
                title: Text(
                  'Hi User!',
                  style: TextStyle(
                    // fontSize: 16,
                    color: kColor,
                  ),
                ),
              ),
              listTile(
                context,
                Icons.shopping_basket,
                'Shop',
                () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              listTile(
                context,
                Icons.payment,
                'Orders',
                () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(OrderScreen.routeName);
                },
              ),
              listTile(
                context,
                Icons.edit,
                'Manage Products',
                () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductScreen.routeName);
                },
              ),
              Spacer(),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.grey),
                title: Text(
                  'Logout',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<Auth>(context, listen: false).logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
