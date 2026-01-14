import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loopx/screens/courses/page/lesson_page.dart';
import 'package:loopx/screens/home/hackathons_page.dart';
import 'package:loopx/screens/home/notifications_page.dart';
import 'package:loopx/screens/home/trainings_page.dart';
import 'package:loopx/screens/schedule/schedule_page.dart';

import '../menu/menu_page.dart';
import '../../widgets/app_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedTab = 0;
  final String track = 'frontend';

  late final AnimationController _heroController;
  late final Animation<double> _heroAnimation;

  final tabs = ['Technical', 'Soft Skills', 'Tools'];

  /// ===== LOCAL COURSES DATA (NO FIREBASE) =====
  final Map<String, List<Map<String, dynamic>>> data = {
    'Technical': [
      {
        'title': 'HTML & CSS',
        'desc': 'Layouts, responsive design',
        'courseId': 'html',
        'lessonOrder': 1,
      },
      {
        'title': 'JavaScript',
        'desc': 'Logic & async programming',
        'courseId': 'javascript',
        'lessonOrder': 1,
      },
      {
        'title': 'React',
        'desc': 'Components & hooks',
        'courseId': 'react',
        'lessonOrder': 1,
      },
    ],
    'Soft Skills': [
      {
        'title': 'Communication',
        'desc': 'Team collaboration & clarity',
        'courseId': 'communication',
        'lessonOrder': 1,
      },
      {
        'title': 'Problem Solving',
        'desc': 'Think like an engineer',
        'courseId': 'problem-solving',
        'lessonOrder': 1,
      },
    ],
    'Tools': [
      {
        'title': 'Git & GitHub',
        'desc': 'Version control',
        'courseId': 'git',
        'lessonOrder': 1,
      },
      {
        'title': 'VS Code',
        'desc': 'Daily workflow',
        'courseId': 'vscode',
        'lessonOrder': 1,
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _heroAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOut,
    );
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  // ================= CONTINUE LEARNING  =================
  Future<void> _continueLearning(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists || !doc.data()!.containsKey('progress')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LessonPage(courseId: 'Html', lessonOrder: 1),
        ),
      );
      return;
    }

    final progress = doc['progress'] as Map<String, dynamic>;
    final String courseId = progress['courseId'];
    final int lessonOrder = progress['lessonOrder'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            LessonPage(courseId: courseId, lessonOrder: lessonOrder),
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final currentTab = tabs[selectedTab];
    final currentItems = data[currentTab]!;

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationsPage()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeTransition(opacity: _heroAnimation, child: _heroCard(context)),
            const SizedBox(height: 36),
            _tabsRow(colors),
            const SizedBox(height: 24),

            /// ===== COURSES  =====
            Column(
              children: currentItems
                  .map((item) => _courseCard(context, item))
                  .toList(),
            ),

            const SizedBox(height: 40),
            Text(
              'Grow beyond courses',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            _bigActionCard(
              icon: Icons.task_alt,
              title: 'Plan your tasks',
              desc: 'Organize your study goals and track progress.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SchedulePage()),
                );
              },
            ),
            _bigActionCard(
              icon: Icons.business_center,
              title: 'Company trainings',
              desc: 'Explore internships and real opportunities.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TrainingsPage()),
                );
              },
            ),
            _bigActionCard(
              icon: Icons.emoji_events,
              title: 'Hackathons',
              desc: 'Compete, build projects and win prizes.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HackathonsPage()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  // ================= COMPONENTS =================

  Widget _heroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurpleAccent],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Build your career, not just skills',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            track == 'frontend'
                ? 'Frontend Engineer Path'
                : 'Backend Engineer Path',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _continueLearning(context),
              child: const Text('Continue Learning'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabsRow(ColorScheme colors) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final selected = selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => selectedTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: selected ? Colors.deepPurple : colors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  color: selected ? Colors.white : colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _courseCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonPage(
              courseId: item['courseId'],
              lessonOrder: item['lessonOrder'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            const Icon(Icons.school, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(item['desc']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigActionCard({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.withOpacity(0.85),
              Colors.deepPurpleAccent.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 36),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(desc, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
