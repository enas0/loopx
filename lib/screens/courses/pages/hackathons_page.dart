import 'package:flutter/material.dart';

class HackathonsPage extends StatelessWidget {
  const HackathonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hackathons = [
      {'title': 'Flutter Hackathon', 'desc': 'Build a full app in 48 hours'},
      {'title': 'AI Challenge', 'desc': 'Solve real AI problems'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Hackathons')),
      body: ListView.builder(
        itemCount: hackathons.length,
        itemBuilder: (context, index) {
          final h = hackathons[index];

          return Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Theme.of(context).dividerColor,
                  child: const Icon(Icons.image, size: 48),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h['title']!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(h['desc']!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
