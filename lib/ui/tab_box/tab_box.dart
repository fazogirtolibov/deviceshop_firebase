import 'package:default_project/data/models/user_model.dart';
import 'package:default_project/ui/tab_box/profile/profile_page.dart';
import 'package:default_project/view_models/profile_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/tab_view_model.dart';
import 'card/card_page.dart';
import 'hom_page/home_page.dart';

class TabBox extends StatefulWidget {
  const TabBox({Key? key}) : super(key: key);

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  List<Widget> screens = [];

  @override
  void initState() {
    screens.add(const HomePage());
    screens.add(const CardPage());
    screens.add(const ProfilePage());
    _printFCMToken();
    super.initState();
  }

  _printFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (!mounted) return;
    UserModel? userModel =
        Provider.of<ProfileViewModel>(context, listen: false).userModel;
    if (userModel != null) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .updateFCMToken(token ?? "", userModel.userId);
    }

    print("FCM TOKEN:$token");
  }

  @override
  Widget build(BuildContext context) {
    var index = context.watch<TabViewModel>().activePageIndex;
    print(DateTime.now().toString());
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => Provider.of<TabViewModel>(context, listen: false)
            .changePageIndex(value),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: index == 0
                    ? const Color(0xff2A2A2A)
                    : Colors.black.withOpacity(0.3),
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: index == 1
                    ? const Color(0xff2A2A2A)
                    : Colors.black.withOpacity(0.3),
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: index == 2
                    ? const Color(0xff2A2A2A)
                    : Colors.black.withOpacity(0.3),
              ),
              label: ""),
        ],
      ),
    );
  }
}
