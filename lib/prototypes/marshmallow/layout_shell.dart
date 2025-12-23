import 'package:flutter/material.dart';
import 'screens/social_feed_screen.dart';

class LayoutShell extends StatefulWidget {
  const LayoutShell({super.key});

  @override
  State<LayoutShell> createState() => _LayoutShellState();
}

class _LayoutShellState extends State<LayoutShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildPlaceholder(context, 'Cocoa Map', Icons.map),
          _buildPlaceholder(context, 'Ranked List', Icons.list_alt),
          const SocialFeedScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        elevation: 10,
        indicatorColor: Theme.of(
          context,
        ).colorScheme.primary.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'Rankings',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Social',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text('Rate'),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
