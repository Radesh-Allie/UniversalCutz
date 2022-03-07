import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class AlternativeMainNavigationView extends StatefulWidget {
  @override
  _AlternativeMainNavigationViewState createState() =>
      _AlternativeMainNavigationViewState();
}

class _AlternativeMainNavigationViewState
    extends State<AlternativeMainNavigationView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(AlternativeMainNavigationController());
  TabController tabController;
  int index;

  getPage() {
    switch (index) {
      case 0:
        return Container(
          child: Center(
            child: Text("To access this page you need to login"),
          ),
        );
        break;
      case 1:
        return BookView();
        break;
      case 2:
        return Container(
          child: Center(
            child: Text("To access this page you need to login"),
          ),
        );
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
    index = 1;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlternativeMainNavigationController>(
      builder: (_) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                getPage(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 4.0,
                  ),
                  child: Card(
                    elevation: 4.0,
                    color: theme.primary,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            "Login to make an Order",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          ExButton(
                            height: 30.0,
                            fontSize: 12.0,
                            label: "Login",
                            onPressed: () => Get.to(LoginView()),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
