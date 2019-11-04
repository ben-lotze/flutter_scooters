import 'package:flutter/material.dart';

import 'drawer_category_header_text.dart';
import 'left_drawer_list_tile.dart';
import 'left_drawer_top_header.dart';

class LibrarySideDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            children: [

              // header
              LeftDrawerTopHeader(),

              // items
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    // Daily stuff
                    DrawerCategoryHeaderText.create("Manage rides"),
                    DrawerListTile.create("Ride history", Icon(Icons.history), "Would open the ride history."),
                    DrawerListTile.create("Credit / Vouchers", Icon(Icons.account_balance_wallet), "Would open a screen with current credit (wallet) where the user can also enter voucher codes."),
                    DrawerListTile.create("Circ Shop", Icon(Icons.shopping_cart), "Would open the Circ shop."),

                    SizedBox(height: 24),

                    // profile
                    DrawerCategoryHeaderText.create("Profile"),
                    DrawerListTile.create("Personal information", Icon(Icons.person), "Would open a screen for personal information (name, adress, phone, ...)"),
                    DrawerListTile.create("Payment", Icon(Icons.monetization_on), "Would open screen to add/manage payment methods."),
                    SizedBox(height: 24),

                    // system
                    DrawerCategoryHeaderText.create("More"),
                    DrawerListTile.create("General terms and conditions", Icon(Icons.sms_failed), "Would open a screen with the general terms of service etc."),
                    DrawerListTile.create("Help", Icon(Icons.help), "Help, I need somebody, Help..."),
                    DrawerListTile.create("Settings", Icon(Icons.settings), "Would open the app settings"),
                    DrawerListTile.create("Logout", Icon(Icons.close), "Bye, bye"),
                  ],
                ),
              ),

            ]
        )
    );
  }
  
}



