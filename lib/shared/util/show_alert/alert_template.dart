import 'package:barber_app/core.dart';
import 'package:flutter/material.dart';



class AlertTemplate extends StatefulWidget {
  final AlertType alertType;
  final String message;

  AlertTemplate({
    @required this.alertType,
    @required this.message,
  });
  @override
  _AlertTemplateState createState() => _AlertTemplateState();
}

class _AlertTemplateState extends State<AlertTemplate> {
  String get getIconByAlertType {
    if (widget.alertType == AlertType.success) {
      return "assets/icon/success.gif";
    } else if (widget.alertType == AlertType.warning) {
      return "assets/icon/warning.gif";
    } else if (widget.alertType == AlertType.info) {
      return "assets/icon/info.gif";
    }
    return "assets/icon/success.gif";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 30.0,
                right: 30.0,
              ),
              child: Container(
                  padding: theme.largePadding,
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: theme.mediumRadius,
                  ),
                  child: Wrap(
                    children: [
                      Container(
                        width: Get.width,
                        child: Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: () => Get.back(),
                              child: Icon(
                                Icons.close,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: Image.asset(
                          getIconByAlertType,
                          width: Get.width / 4,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        width: Get.width,
                        child: Center(
                          child: Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
