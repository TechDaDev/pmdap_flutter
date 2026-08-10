import 'package:flutter/material.dart';

/// Horizontal scrolling FilterChip row (min touch target enforced).
class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  /// (label, value) pairs.
  final List<(String, String)> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (label, value) = items[i];
          return FilterChip(
            label: Text(label),
            selected: selected == value,
            onSelected: (_) => onSelected(value),
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}
