import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HackathonsPage extends StatelessWidget {
  const HackathonsPage({super.key});

  static final List<Map<String, String>> hackathons = [
    {
      'title': 'Google Dev Hackathon',
      'organizer': 'Google Developers',
      'date': 'March 20 – 22, 2026',
      'location': 'Online',
      'image': 'https://images.unsplash.com/photo-1551836022-d5d88e9218df',
      'link': 'https://developers.google.com',
    },
    {
      'title': 'AI Innovation Hack',
      'organizer': 'Open Tech',
      'date': 'April 10 – 12, 2026',
      'location': 'Amman, Jordan',
      'image': 'https://images.unsplash.com/photo-1531482615713-2afd69097998',
      'link': 'https://example.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Hackathons')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hackathons.length,
        itemBuilder: (_, i) {
          final item = hackathons[i];
          return _hackathonCard(context, item, textTheme);
        },
      ),
    );
  }

  Widget _hackathonCard(
    BuildContext context,
    Map<String, String> item,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              item['image']!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title']!,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(item['organizer']!, style: textTheme.bodySmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text(item['date']!, style: textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 6),
                    Text(item['location']!, style: textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final uri = Uri.parse(item['link']!);
                      if (await canLaunchUrl(uri)) {
                        launchUrl(uri);
                      }
                    },
                    child: const Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
