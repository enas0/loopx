import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../menu/menu_page.dart';

import '../../widgets/search_bar_widget.dart';
import '../../widgets/app_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedTrack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final uid = user.uid;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MenuPage()),
            );
          },
        ),
        title: const Text(
          'LOOPX',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 12)],
      ),

      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final String? track = data['track'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔁 Dynamic section
                if (track == null) ...[
                  _chooseTrackCard(),
                  const SizedBox(height: 24),
                ] else ...[
                  _trackContainer(track),
                  const SizedBox(height: 24),
                ],

                const SearchBarWidget(),
                const SizedBox(height: 24),

                Text(
                  'Explore Tech Courses',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Boost your skills in modern technology fields',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                _courseCard(
                  icon: Icons.code,
                  title: 'Web Development',
                  subtitle: 'HTML, CSS, JavaScript, React',
                ),
                _courseCard(
                  icon: Icons.smartphone,
                  title: 'Mobile Development',
                  subtitle: 'Flutter, Android, iOS',
                ),
                _courseCard(
                  icon: Icons.storage,
                  title: 'Backend & APIs',
                  subtitle: 'Node.js, ASP.NET, Databases',
                ),
                _courseCard(
                  icon: Icons.security,
                  title: 'Cyber Security',
                  subtitle: 'Networks, Security Basics',
                ),
              ],
            ),
          );
        },
      ),

      /// BottomNav Widget (Home = index 0)
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // Choose Track Card

  Widget _chooseTrackCard() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your learning path',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),

          RadioGroup<String>(
            groupValue: _selectedTrack,
            onChanged: (value) {
              setState(() {
                _selectedTrack = value;
              });
            },
            child: const Column(
              children: [
                RadioListTile(
                  title: Text('Frontend Developer'),
                  value: 'frontend',
                ),
                RadioListTile(
                  title: Text('Backend Developer'),
                  value: 'backend',
                ),
                RadioListTile(title: Text('Mobile Developer'), value: 'mobile'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedTrack == null
                  ? null
                  : () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .update({'track': _selectedTrack});

                      setState(() {
                        _selectedTrack = null;
                      });
                    },
              child: const Text('Start'),
            ),
          ),
        ],
      ),
    );
  }

  // Track Container

  Widget _trackContainer(String track) {
    switch (track) {
      case 'frontend':
        return _trackCard(
          icon: Icons.code,
          title: 'Frontend Roadmap',
          subtitle: 'HTML → CSS → JavaScript → React',
        );
      case 'backend':
        return _trackCard(
          icon: Icons.storage,
          title: 'Backend Roadmap',
          subtitle: 'APIs → Databases → Authentication',
        );
      case 'mobile':
        return _trackCard(
          icon: Icons.smartphone,
          title: 'Mobile Roadmap',
          subtitle: 'Flutter → Android → iOS',
        );
      default:
        return const SizedBox();
    }
  }

  Widget _trackCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: colors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Course Card

  Widget _courseCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: colors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
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
