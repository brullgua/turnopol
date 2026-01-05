import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopol/providers/root_provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(
      builder: (context, rootProvider, child) {    
      return const Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.home), onPressed: null),
              IconButton(icon: Icon(Icons.settings), onPressed: null),
            ],
          )
        ),
        body: Center(
          child: Text('Root Page'),
        ),
      );
    });
  }
}