


import 'package:flutter/material.dart';

/// Empty State Widget
class BrowsePackagesEmptyStateWidget extends StatelessWidget {
  const BrowsePackagesEmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No packages found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Try adjusting your filters'),
          ],
        ),
      ),
    );
  }
}
