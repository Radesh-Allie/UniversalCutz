import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class SelectVendorDetailView extends StatelessWidget {
  final dynamic item;
  final Function(Map<String, dynamic> item) onSelect;
  SelectVendorDetailView({@required this.item, @required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectVendorDetailController>(
      init: SelectVendorDetailController(),
      builder: (controller) {
        controller.viewItem = item;
        if (controller.loading) return Container();
        if (!controller.visible) return Container();
        return Container(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          item["photo_url"],
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: theme.mediumRadius,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("${item["vendor_name"]}"),
                        Text(
                          "${item["address"]}",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: theme.textColor.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          "08:00 - 21:00",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: theme.primary,
                          ),
                        ),
                        Container(
                          height: 4.0,
                        ),
                        Text(
                          "${(item["distance"] / 1000).toStringAsFixed(1)}Km",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: theme.primary,
                          ),
                        ),
                        Container(
                          height: 10.0,
                        ),
                        Container(
                          child: RatingBar.builder(
                            initialRating: item["rate"] * 1.0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            unratedColor: theme.disabled,
                            itemSize: 12.0,
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  ExButton(
                    label: "View",
                    height: 30.0,
                    width: 80.0,
                    fontSize: 10.0,
                    onPressed: () async {
                      await Get.to(VendorDetailView(
                        item: item,
                        onSelect: onSelect,
                      ));
                    },
                  ),
                ],
              ),
              Divider(
                color: theme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
