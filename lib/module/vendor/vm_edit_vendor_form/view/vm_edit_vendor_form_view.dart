import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class VmEditVendorFormView extends StatelessWidget {
  final controller = Get.put(VmEditVendorFormController());

  @override
  Widget build(BuildContext context) {
    controller.view = this;

    return GetBuilder<VmEditVendorFormController>(
      builder: (_) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Edit ${config.vendorString}"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExButton(
                    label: "Save",
                    onPressed: () => controller.save(),
                  ),
                ),
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Text(
                      "General",
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "${config.productString}",
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "${config.staffString}",
                      style: TextStyle(
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TabBarView(
                children: [
                  VmGeneralForm(),
                  VmProductForm(),
                  VmGalleryForm(),
                  VmStaffForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
