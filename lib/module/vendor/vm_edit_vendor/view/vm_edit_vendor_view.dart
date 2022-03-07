import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class VmEditVendorView extends StatefulWidget {
  final Map<String, dynamic> item;

  VmEditVendorView({
    this.item,
  });

  @override
  _VmEditVendorViewState createState() => _VmEditVendorViewState();
}

class _VmEditVendorViewState extends State<VmEditVendorView>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(VmEditVendorController());
  TabController _tabController;

  Widget getMainView() {
    if (_tabController.index == 0) {
      return VmAboutView(
        item: widget.item,
      );
    } else if (_tabController.index == 1) {
      return VmProductView();
    } else if (_tabController.index == 2) {
      return VmStaffView();
    } else if (_tabController.index == 3) {
      return VmGaleryView();
    } else if (_tabController.index == 4) {
      return VmReviewView();
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

    return GetBuilder<VmEditVendorController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Your ${config.vendorString}"),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ExButton(
                  label: "Edit",
                  onPressed: () => Get.to(VmEditVendorFormView()),
                ),
              ),
            ],
          ),
          body: controller.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        if (widget.item["status"] == "Pending")
                          Card(
                            color: Colors.orange[100],
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "You need approval from Admin",
                                      style: TextStyle(
                                        color: Colors.red[900],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 10.0,
                        ),
                        VmHeader(
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
                                  '${config.vendorString}',
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
        );
      },
    );
  }
}
