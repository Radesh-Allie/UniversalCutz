import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class VmMainNavigationView extends StatefulWidget {
  @override
  _VmMainNavigationViewState createState() => _VmMainNavigationViewState();
}

class _VmMainNavigationViewState extends State<VmMainNavigationView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(VmMainNavigationController());
  TabController tabController;
  int _index;

  getPage() {
    switch (_index) {
      case 0:
        return VmOrderListView();
        break;
      case 1:
        return VmEditVendorView(
          item: AppSession.myVendor,
        );
        break;
      case 2:
        return VmProfileView();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    tabController = new TabController(
      length: 2,
      vsync: this,
    );
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VmMainNavigationController>(
      builder: (_) {
        return Scaffold(
          body: getPage(),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: _index,
            type: BottomNavigationBarType.fixed,
            onTap: (int _index) {
              setState(() {
                this._index = _index;
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
                  Icons.store_sharp,
                ),
                label: "Your Store's",
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
