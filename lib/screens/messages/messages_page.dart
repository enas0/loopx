import 'package:flutter/material.dart';

import '../../widgets/app_bottom_nav.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final conversations = [
      {
        'name': 'Study Group - Flutter',
        'message': 'Let’s review widgets today',
        'time': '2:30 PM',
      },
      {
        'name': 'Ahmed Hassan',
        'message': 'Did you finish the assignment?',
        'time': '1:10 PM',
      },
      {
        'name': 'eva ',
        'message': 'New update is coming soon 🚀',
        'time': 'Yesterday',
      },
      {
        'name': 'group 2',
        'message': 'New update is coming soon 🚀',
        'time': 'Yesterday',
      },
      {
        'name': 'LOOPX Team',
        'message': 'New update is coming soon 🚀',
        'time': 'Yesterday',
      },
      {
        'name': 'LOOPX Team',
        'message': 'New update is coming soon 🚀',
        'time': 'Yesterday',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),

      body: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: colors.outlineVariant),
        itemBuilder: (context, index) {
          final chat = conversations[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              child: Icon(Icons.person, color: colors.onPrimaryContainer),
            ),
            title: Text(
              chat['name']!,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              chat['message']!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            trailing: Text(
              chat['time']!,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            onTap: () {},
          );
        },
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }
}
