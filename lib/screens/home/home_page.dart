import 'package:flutter/material.dart';
import '../menu/menu_page.dart';
import '../../widgets/app_bottom_nav.dart';
import '../courses/luctures_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _courses = [
    {
      'title': 'Web Development',
      'subtitle': 'HTML, CSS, JavaScript, React',
      'icon': Icons.code,
    },
    {
      'title': 'Mobile Development',
      'subtitle': 'Flutter, Android, iOS',
      'icon': Icons.smartphone,
    },
    {
      'title': 'Backend & APIs',
      'subtitle': 'Node.js, ASP.NET, Databases',
      'icon': Icons.storage,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final filteredCourses = _courses.where((course) {
      final q = _searchQuery.toLowerCase();
      return course['title'].toLowerCase().contains(q) ||
          course['subtitle'].toLowerCase().contains(q);
    }).toList();

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///  LEARNING PATH
            _learningPathCard(context),

            const SizedBox(height: 32),

            ///  SEARCH
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
              ),
            ),

            const SizedBox(height: 32),

            ///  CONTINUE LEARNING
            Text(
              'Continue Learning',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _continueLearningCard(
              context,
              image:
                  'https://images.unsplash.com/photo-1587620962725-abab7fe55159',
              title: 'JavaScript Advanced',
              subtitle: 'Closures • Async • Performance',
              progress: 0.6,
            ),

            _continueLearningCard(
              context,
              image:
                  'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
              title: 'React Fundamentals',
              subtitle: 'Hooks • Components • State',
              progress: 0.35,
            ),

            const SizedBox(height: 32),

            ///  EXPLORE
            Text(
              'Explore Tech Courses',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...filteredCourses.map(
              (course) => _exploreCard(
                context,
                icon: course['icon'],
                title: course['title'],
                subtitle: course['subtitle'],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  //  COMPONENTS

  Widget _learningPathCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Learning Path',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Frontend Developer',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onPrimaryContainer.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: 0.45,
            minHeight: 8,
            backgroundColor: colors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(colors.primary),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Continue Learning'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LucturesPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _continueLearningCard(
    BuildContext context, {
    required String image,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LucturesPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                image,
                height: 160,
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
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: colors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation(colors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exploreCard(
    BuildContext context, {
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
        borderRadius: BorderRadius.circular(14),
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
