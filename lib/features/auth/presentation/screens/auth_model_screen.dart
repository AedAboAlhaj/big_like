import 'package:flutter/material.dart';
import '../../../../common_widgets/custom_app_bar.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({
    super.key,
    required this.screenTitle,
    required this.bodyWidget,
    this.showBackBtn = true,
    this.backFunction,
  });
  final String screenTitle;
  final Widget bodyWidget;
  final bool showBackBtn;
  final VoidCallback? backFunction;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: screenTitle,
          backFunction: backFunction,
          showBackBtn: showBackBtn),
      body: bodyWidget,
    );
  }
}
