import 'dart:developer';

import 'package:barber_app/core.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class IndexGenerator extends StatelessWidget {
  final List<String> urls;
  IndexGenerator({
    @required this.urls,
  });

  @override
  Widget build(BuildContext context) {
    String instruction =
        "Please open all the links below in a browser and create the index. (Login to your firebase is required)";

    log("############################");
    log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    log(" ACTION REQUIRED ");
    log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    log("$instruction");
    log("~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    log("############################");

    return Scaffold(
      appBar: AppBar(
        title: Text("Index Generator"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.deleteAll();
                Get.off(LoginView());
              },
              child: Text("Relog"),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              color: Colors.yellow[200],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "$instruction",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: urls.length,
                itemBuilder: (context, index) {
                  var url = urls[index];

                  log("# !~~~~~~~~~~~~~~~~~~~ #");
                  log("URL: $url");
                  log("# ~~~~~~~~~~~~~~~~~~~! #");

                  return Card(
                    child: ListTile(
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("URL #${index + 1}"),
                          Divider(),
                          Text(
                            "$url",
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(),
                          ElevatedButton(
                            onPressed: () async {
                              await FlutterClipboard.copy(url);
                              Get.snackbar(
                                "URL COPIED!",
                                instruction,
                              );
                            },
                            child: Text("Copy"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
