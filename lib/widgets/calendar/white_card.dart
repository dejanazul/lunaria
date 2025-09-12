import 'package:flutter/material.dart';
import 'package:lunaria/helpers/responsive_helper.dart';

class WhiteCard extends StatelessWidget {
  final Widget child;

  const WhiteCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 16 : 20),
        child: child,
      ),
    );
  }
}
