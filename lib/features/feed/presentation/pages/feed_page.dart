import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Krishi Social'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Buy'),
              Tab(text: 'Sell'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Buy posts')),
            Center(child: Text('Sell posts')),
          ],
        ),
      ),
    );
  }
}
