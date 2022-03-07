import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';

class SelectCreditCardView extends StatefulWidget {
  final String id;
  SelectCreditCardView({
    @required this.id,
  });

  @override
  _SelectCreditCardViewState createState() => _SelectCreditCardViewState();
}

class _SelectCreditCardViewState extends State<SelectCreditCardView> {
  @override
  void initState() {
    super.initState();
    Input.set(widget.id, null);
    Input.set("${widget.id}_item", null);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Credit Card"),
        actions: [
          InkWell(
            onTap: () async {
              Get.to(AddCreditCard());
            },
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FireStream(
          stream: userCollection.collection("payment_account").snapshots(),
          onItemBuild: (item, index) {
            return InkWell(
              onTap: () {
                Input.set(widget.id, item["id"]);
                Input.set("${widget.id}_item", item);
                Get.back();
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item["account_title"]),
                          Spacer(),
                          Container(
                            height: 30.0,
                            child: ElevatedButton(
                              onPressed: () {
                                userCollection
                                    .collection("payment_account")
                                    .doc(item["id"])
                                    .delete();
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(item["account_number"]
                              .toString()
                              .toCreditCardFormat() ??
                          "-"),
                      SizedBox(
                        height: 6.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
