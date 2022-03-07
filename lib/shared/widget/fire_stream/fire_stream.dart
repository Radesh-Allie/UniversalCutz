import 'package:barber_app/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FireStream extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  final Widget onLoading;
  final Widget onError;
  final Function(Map item, int index) onItemBuild;
  final Function(QuerySnapshot snapshot) onSnapshot;
  final bool shrinkWrap;

  FireStream({
    this.stream,
    this.onLoading,
    this.onError,
    this.onItemBuild,
    this.onSnapshot,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          if (onLoading == null)
            return const Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          // if (onError == null) {}

          if (stream.error.toString().contains("failed-precondition")) {
            var link = stream.error.toString().split("it here:")[1];

            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("The query require an Index"),
                  Text("Please create it here:"),
                  ExMemoField(
                    id: "link",
                    label: "",
                    value: "$link",
                  ),
                  Row(
                    children: [
                      ExButton(
                        label: "Copy Link",
                        height: 36.0,
                        onPressed: () async {},
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ExButton(
                        label: "Open Link",
                        height: 36.0,
                        onPressed: () async {
                          await canLaunch(link)
                              ? await launch(link)
                              : throw 'Could not launch $link';
                        },
                      ),
                    ],
                  )
                ],
              ),
            ));
          }
          return Center(
              child: Column(
            children: [
              Text(stream.error.toString()),
            ],
          ));
        }

        QuerySnapshot querySnapshot = stream.data;
        if (onSnapshot != null) {
          return onSnapshot(querySnapshot);
        }

        return Scrollbar(
          isAlwaysShown: true,
          child: ListView.builder(
            shrinkWrap: shrinkWrap,
            physics: shrinkWrap ? NeverScrollableScrollPhysics() : null,
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              var item = querySnapshot.docs[index].data();
              var docId = querySnapshot.docs[index].id;
              item["id"] = docId;

              if (onItemBuild != null) {
                return onItemBuild(item, index);
              }

              return Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ExNetworkImage(
                      src: item['photo'] ??
                          "https://i.ibb.co/59BxMdr/image-not-available.png",
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("John Doe",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            Text(
                              "description...",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
