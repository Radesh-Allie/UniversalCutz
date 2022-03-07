import 'package:flutter/material.dart';

class XCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final List<Widget> actions;
  final bool enableScroll;

  XCard({
    this.title,
    this.children = const [],
    this.actions = const [],
    this.enableScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70.0,
            padding: const EdgeInsets.only(
              right: 20.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$title",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Spacer(),
                ...actions,
              ],
            ),
          ),
          Container(
            height: 1.0,
            color: Color(0xffD8DBE0),
          ),
          SizedBox(
            height: 20.0,
          ),
          if (!enableScroll)
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: Column(
                  children: [
                    ...children,
                  ],
                ),
              ),
            ),
          if (enableScroll)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    children: [
                      ...children,
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
