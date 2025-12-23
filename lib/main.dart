import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'prototypes/anime_cyberpunk/main_screen.dart';
import 'prototypes/expressive_anime/expressive_home.dart';
// ignore: unused_import
import 'prototypes/marshmallow/main.dart';

void main() {
  runApp(const DesignPlaygroundApp());
}

class DesignPlaygroundApp extends StatelessWidget {
  const DesignPlaygroundApp({super.key});

  /// --------------------------------------------------------------------------
  /// 🛠️ DEV MODE: DIRECT BOOT
  /// Assign a widget here to skip the menu and boot directly into a prototype.
  /// --------------------------------------------------------------------------

  // static Widget? activePrototype = const MarshmallowPrototypeApp();
  static Widget? activePrototype = const ExpressiveApp();
  // static Widget? activePrototype = null; // Boot to Menu

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      // If activePrototype is set, boot it. Otherwise show the Menu.
      home: activePrototype ?? const PlaygroundMenu(),
    );
  }
}

class PlaygroundMenu extends StatelessWidget {
  const PlaygroundMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design Playground'), elevation: 2),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Prototypes'),
          // TODO: Add list items here as we create them
          ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text('Expressive Anime'),
            subtitle: const Text('Fun, bouncy, and vibrant'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExpressiveApp()),
            ),
          ),
          const Divider(),
          _buildSectionHeader(context, "Older Prototypes"),
          const Card(
            child: ListTile(
              leading: Icon(Icons.hub),
              title: Text('No prototypes yet'),
              subtitle: Text('Create a new folder in lib/prototypes/'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
