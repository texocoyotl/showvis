import 'package:flutter/material.dart';

class ShowDetails extends StatelessWidget {
  const ShowDetails(this.id, {super.key});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          id.toString(),
        ),
      ),
    );
  }
}
