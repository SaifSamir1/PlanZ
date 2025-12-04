


import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

/// Filter Bar Widget
class FilterBarWidget extends StatelessWidget {
  final String sortBy;
  final Function(String?) onSortChanged;
  final VoidCallback onShowFilterDialog;

  const FilterBarWidget({
    required this.sortBy,
    required this.onSortChanged,
    required this.onShowFilterDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.cardBackground,
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: sortBy,
              isExpanded: true,
              isDense: true,
              items: const [
                DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                DropdownMenuItem(value: 'rating', child: Text('Highest Rating')),
                DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
              ],
              onChanged: onSortChanged,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.filter_list, size: 20),
            onPressed: onShowFilterDialog,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

