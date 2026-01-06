import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnopol/providers/root_provider.dart';
import 'package:turnopol/core/theme.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RootProvider>(
      builder: (context, rootProvider, child) {    
      return Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: ThemeColors.surface,
              borderRadius: BorderRadiusGeometry.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(icon: Icon(Icons.home), onPressed: null),
                IconButton(icon: Icon(Icons.settings), onPressed: null),
            ],
          )
        ),
        ),
        body: Center(
          child: Text('Root Page', style: TextStyle(color: ThemeColors.blanco)))
      );
    });
  }
}