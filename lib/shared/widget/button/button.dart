import 'package:flutter/material.dart';

class ExButton extends StatelessWidget {
  final String label;
  final Function onPressed;
  final Color color;
  final IconData icon;
  final double height;
  final double width;
  final double fontSize;
  final double iconSize;
  final BorderRadiusGeometry borderRadius;
  final List<BoxShadow> boxShadow;
  final bool enabled;

  ExButton({
    @required this.label,
    @required this.onPressed,
    this.enabled = true,
    this.color,
    this.icon,
    this.height,
    this.width,
    this.fontSize,
    this.iconSize,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 46.0,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize ?? 28,
              ),
              if (label.isNotEmpty)
                SizedBox(
                  width: 8.0,
                ),
            ],
            Text(
              "$label",
              style: TextStyle(
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
    // return InkWell(
    //   onTap: () => enabled ? onPressed() : {},
    //   child: Container(
    //     height: height ?? theme.smallHeight,
    //     decoration: BoxDecoration(
    //       // color: enabled ? (color ?? theme.primary) : theme.disabled,
    //       borderRadius: borderRadius ?? theme.smallRadius,
    //       boxShadow: boxShadow,
    //     ),
    //     child: Padding(
    //       padding: const EdgeInsets.only(
    //         top: 8.0,
    //         bottom: 8.0,
    //         left: 16.0,
    //         right: 16.0,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           if (icon != null)
    //             Icon(
    //               icon,
    //               color:
    //                   color == theme.disabled ? theme.textColor : Colors.white,
    //               size: iconSize ?? 28,
    //             ),
    //           if (icon != null)
    //             SizedBox(
    //               width: 6.0,
    //             ),
    //           Text(
    //             "$label",
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontSize: fontSize,
    //               color:
    //                   color == theme.disabled ? theme.textColor : Colors.white,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
