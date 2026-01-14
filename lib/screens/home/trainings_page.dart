import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingsPage extends StatelessWidget {
  const TrainingsPage({super.key});

  static final List<Map<String, String>> trainings = [
    {
      'title': 'Frontend Internship',
      'company': 'Meta',
      'duration': '3 Months',
      'location': 'Remote',
      'image': 'https://images.unsplash.com/photo-1549924231-f129b911e442',
      'link': 'https://meta.com/careers',
    },
    {
      'title': 'Backend Developer Training',
      'company': 'Amazon',
      'duration': '6 Months',
      'location': 'On-site',
      'image': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c',
      'link': 'https://amazon.jobs',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Company Trainings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trainings.length,
        itemBuilder: (_, i) {
          final item = trainings[i];
          return _trainingCard(context, item, textTheme);
        },
      ),
    );
  }

  Widget _trainingCard(
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
                Text(item['company']!, style: textTheme.bodySmall),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 6),
                    Text(item['duration']!, style: textTheme.bodySmall),
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
                    child: const Text('Apply Now'),
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
