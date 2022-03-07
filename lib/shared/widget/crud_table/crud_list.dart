import 'dart:developer';

import 'package:barber_app/core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CrudListView extends StatefulWidget {
  final String title;
  final CollectionReference ref;
  final List<Map> itemFields;
  final List<Map> formFields;
  final double rowHeight;

  final String defaultOrderBy;
  final bool defaultOrderDescending;

  final bool disableAdd;
  final bool disableEdit;
  final bool disableDelete;

  final Function(dynamic item) onItemBuild;

  CrudListView({
    @required this.title,
    @required this.ref,
    @required this.itemFields,
    @required this.formFields,
    this.defaultOrderBy,
    this.defaultOrderDescending = false,
    this.rowHeight = 40.0,
    this.disableAdd = false,
    this.disableEdit = false,
    this.disableDelete = false,
    this.onItemBuild,
  });

  @override
  _CrudListViewState createState() => _CrudListViewState();
}

class _CrudListViewState extends State<CrudListView> {
  bool showForm = false;

  List<Widget> getHeaderUI() {
    List<Widget> widgets = [];
    var fields = widget.itemFields;
    for (var i = 0; i < fields.length; i++) {
      var field = fields[i];
      Widget w = Container(
        width: (field["width"] ?? 160.0) * 1.0,
        padding: EdgeInsets.all(10.0),
        child: Center(
            child: Text(
          field["header"] ?? "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        )),
      );
      if (field["expanded"] != null && field["expanded"] == true) {
        widgets.add(
          Expanded(
            child: w,
          ),
        );
      } else {
        widgets.add(w);
      }
    }

    return widgets;
  }

  List<Widget> getColumnUI(Map item) {
    List<Widget> widgets = [];

    print("getColumnUI:");
    print(item);

    var fields = widget.itemFields;
    for (var i = 0; i < fields.length; i++) {
      var field = fields[i];

      if (field["field_name"].toString().contains(".")) {
        var arr = field["field_name"].toString().split(".");
        item[field["field_name"]] = item[arr[0]][arr[1]];
      }

      if (field["type"] == "image") {
        Widget w = Container(
          width: (field["width"] ?? 140.0) * 1.0,
          height: widget.rowHeight,
          padding: EdgeInsets.all(10.0),
          child: item[field["field_name"]] == null
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                  height: (field["height"] ?? 140.0) * 1.0,
                  width: (field["width"] ?? 140.0) * 1.0,
                  child: Center(
                    child: Icon(
                      Icons.photo,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: field["height"] ?? 140.0,
                        width: (field["width"] ?? 140.0) * 1.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              item[field["field_name"]],
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );

        if (field["expanded"] != null && field["expanded"] == true) {
          widgets.add(
            Expanded(
              child: w,
            ),
          );
        } else {
          widgets.add(w);
        }
      } else if (field["type"] == "text") {
        var value = item[field["field_name"]];
        Widget w = Container(
          width: field["width"] ?? 200.0,
          height: widget.rowHeight,
          padding: EdgeInsets.all(10.0),
          child: Text("$value"),
        );
        if (field["expanded"] != null && field["expanded"] == true) {
          widgets.add(
            Expanded(
              child: w,
            ),
          );
        } else {
          widgets.add(w);
        }
      } else if (field["type"] == "date") {
        var value = item[field["field_name"]];
        value = DateFormat("d MMM y kk:mm").format(value.toDate());

        Widget w = Container(
          width: field["width"] ?? 200.0,
          height: widget.rowHeight,
          padding: EdgeInsets.all(10.0),
          child: Text("$value"),
        );
        if (field["expanded"] != null && field["expanded"] == true) {
          widgets.add(
            Expanded(
              child: w,
            ),
          );
        } else {
          widgets.add(w);
        }
      }

      log(widgets.length.toString());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    var ref = widget.ref.snapshots();
    if (widget.defaultOrderBy != null) {
      ref = widget.ref
          .orderBy(
            widget.defaultOrderBy,
            descending: widget.defaultOrderDescending,
          )
          .snapshots();
    }

    if (showForm) {
      return CrudForm(
        title: widget.title,
        ref: widget.ref,
        formFields: widget.formFields,
        afterSave: () {
          showForm = false;
          setState(() {});
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
        actions: [
          if (!widget.disableAdd)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExButton(
                color: theme.primary,
                label: "Add",
                height: 36.0,
                onPressed: () {
                  RouterState.item = {};
                  showForm = true;
                  setState(() {});
                },
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: FireStream(
                  stream: ref,
                  onItemBuild: (item, index) {
                    if (widget.onItemBuild != null) {
                      var res = widget.onItemBuild(item);
                      if (res != null) {
                        return res;
                      }
                    }
                    return Card(
                      elevation: 0.4,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: getColumnUI(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
