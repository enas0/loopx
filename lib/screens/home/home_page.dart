import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loopx/screens/courses/page/lesson_page.dart';

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

  final Map<String, List<Map<String, String>>> data = {
    'Technical': [
      {'title': 'HTML & CSS', 'desc': 'Layouts, responsive design'},
      {'title': 'Bootstrap', 'desc': 'UI components'},
      {'title': 'JavaScript', 'desc': 'Logic & async programming'},
      {'title': 'React', 'desc': 'Components & hooks'},
    ],
    'Soft Skills': [
      {'title': 'Communication', 'desc': 'Work with teams'},
      {'title': 'Problem Solving', 'desc': 'Think like an engineer'},
    ],
    'Tools': [
      {'title': 'Git & GitHub', 'desc': 'Version control'},
      {'title': 'VS Code', 'desc': 'Daily workflow'},
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

  // ================= CONTINUE LEARNING LOGIC =================

  Future<void> _continueLearning(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // مستخدم جديد – ما عنده progress
    if (!doc.exists || !doc.data()!.containsKey('progress')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LessonPage(courseId: 'html', lessonOrder: 1),
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
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 12)],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HERO =================
            FadeTransition(
              opacity: _heroAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(_heroAnimation),
                child: _heroCard(context),
              ),
            ),

            const SizedBox(height: 36),

            // ================= TABS =================
            _tabsRow(colors),

            const SizedBox(height: 24),

            // ================= COURSES =================
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey(currentTab),
                children: currentItems
                    .map((item) => _courseCard(context, item))
                    .toList(),
              ),
            ),

            const SizedBox(height: 40),

            // ================= GROW =================
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
            ),
            _bigActionCard(
              icon: Icons.business_center,
              title: 'Company trainings',
              desc: 'Explore internships and real opportunities.',
            ),
            _bigActionCard(
              icon: Icons.emoji_events,
              title: 'Hackathons',
              desc: 'Compete, build projects and win prizes.',
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                'Consistency beats motivation.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
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

  Widget _courseCard(BuildContext context, Map<String, String> item) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
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
                item['title']!,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(item['desc']!, style: textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bigActionCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: () {},
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
                      fontSize: 16,
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
