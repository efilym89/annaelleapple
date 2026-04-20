import 'package:flutter/material.dart';

import '../../domain/entities/learning_models.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.item,
    required this.icon,
  });

  final HomeFeedItem item;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  item.dateLabel,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
