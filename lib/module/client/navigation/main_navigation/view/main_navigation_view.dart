import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class MainNavigationView extends StatefulWidget {
  final int selectedIndex;
  MainNavigationView({
    @required this.selectedIndex,
  });
  @override
  _MainNavigationViewState createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(MainNavigationController());
  TabController tabController;
  int index;

  getPage() {
    if (index != 1) {
      //cancel current book
      if (Get.isRegistered<BookController>()) {
        BookController bookController = Get.find();
        bookController.selectedVendor = null;
        bookController.update();
      }
    }
    switch (index) {
      case 0:
        return OrderView();
        break;
      case 1:
        return BookView();
        break;
      case 2:
        return ProfileView();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(
      length: 3,
      vsync: this,
    );
    index = widget.selectedIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainNavigationController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: getPage(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                this.index = index;
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                ),
                label: "Your Order",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.book_online,
                ),
                label: config.orderButtonText,
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
