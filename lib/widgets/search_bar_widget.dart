import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: colors.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 10),
          Text(
            'Search paths, skills, or topics',
            style: TextStyle(color: colors.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
