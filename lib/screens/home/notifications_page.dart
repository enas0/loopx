import 'package:flutter/material.dart';

import '../../models/notification_model.dart';
import '../../services/firebase_notification_service.dart';
import '../../widgets/app_bottom_nav.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final FirebaseNotificationService _service =
      FirebaseNotificationService.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),

      body: StreamBuilder<List<AppNotification>>(
        stream: _service.watchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (_, index) {
              final n = notifications[index];

              return GestureDetector(
                onTap: () async {
                  if (!n.read) {
                    await _service.markAsRead(n.id);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: n.read
                        ? colors.surface
                        : colors.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notifications,
                        color: n.read
                            ? colors.onSurfaceVariant
                            : colors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              n.body,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatDate(n.dateTime),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _service.delete(n.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }

  static String _formatDate(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day}/${dt.month}/${dt.year}  $h:$m $period';
  }
}
