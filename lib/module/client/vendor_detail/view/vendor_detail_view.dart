import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class VendorDetailView extends StatefulWidget {
  final Map<String, dynamic> item;
  final Function(Map<String, dynamic> item) onSelect;

  VendorDetailView({
    this.item,
    this.onSelect,
  });

  @override
  _VendorDetailViewState createState() => _VendorDetailViewState();
}

class _VendorDetailViewState extends State<VendorDetailView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(VendorDetailController());
  TabController _tabController;

  Widget getMainView() {
    if (_tabController.index == 0) {
      return AboutView(
        item: widget.item,
      );
    } else if (_tabController.index == 1) {
      return ProductView(
        vendorId: widget.item["id"],
      );
    } else if (_tabController.index == 2) {
      return StaffView(
        vendorId: widget.item["id"],
      );
    } else if (_tabController.index == 3) {
      return GaleryView(
        vendorId: widget.item["id"],
      );
    } else if (_tabController.index == 4) {
      return ReviewView(
        vendorId: widget.item["id"],
      );
    }

    return Container(
      color: Colors.red,
      height: 400.0,
    );
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 5,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.view = widget;

    return GetBuilder<VendorDetailController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Vendor Detail"),
            actions: [],
          ),
          body: controller.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        Header(
                          item: widget.item,
                        ),
                        IconsMenu(
                          item: widget.item,
                        ),
                        TabBar(
                          isScrollable: true,
                          onTap: (index) {
                            print("$index");
                            setState(() {});
                          },
                          tabs: [
                            Tab(
                              text: 'About',
                            ),
                            Tab(
                              text:
                                  '${config.productString}',
                            ),
                            Tab(
                              text:
                                  '${config.staffString}',
                            ),
                            Tab(
                              text: 'Gallery',
                            ),
                            Tab(
                              text: 'Review',
                            ),
                          ],
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                        ),
                        getMainView(),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: Container(
            padding: theme.mediumPadding,
            child: ExButton(
              label: AdminSettingApi?.appSetting["multi_vendor"] == false
                  ? "Book"
                  : "Select",
              onPressed: () async {
                if (AppSession.currentUser == null) {
                  Get.snackbar("You Need to Login",
                      "To access this page you need to login");
                  return;
                }
                
                var item = widget.item;
                showLoading();

                item["products"] = await VendorApi.getProducts(item["id"]);

                hideLoading();

                print("onSelect: ${widget.onSelect}");
                if (widget.onSelect != null) widget.onSelect(item);

                Get.to(
                  BookVendorSelectedView(),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
