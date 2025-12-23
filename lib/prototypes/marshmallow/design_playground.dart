import 'package:flutter_design_playground/prototypes/marshmallow/screens/social_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignPlayground extends StatefulWidget {
  const DesignPlayground({super.key});

  @override
  State<DesignPlayground> createState() => _DesignPlaygroundState();
}

class _DesignPlaygroundState extends State<DesignPlayground> {
  int _currentThemeIndex = 0;

  late final List<String> _themeNames = [
    'Peppermint Paper',
    'Kraft & Cocoa',
    'Winter Stationer',
  ];

  late final List<CardTheme> _cardThemes = [
    // Peppermint Paper: Soft shadow, very rounded
    CardTheme(
      elevation: 4,
      shadowColor: const Color(
        0xFFE11D48,
      ).withValues(alpha: 0.2), // Red tinted shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFFFFFFFF),
    ),
    // Kraft & Cocoa: Sharp, flat, textured feel
    CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFF5D4037),
          width: 2,
        ), // Brown border
      ),
      color: const Color(0xFFEFEBE9), // Light Paper
    ),
    // Winter Stationer: Elegant, high elevation
    CardTheme(
      elevation: 10,
      shadowColor: const Color(0xFF000000).withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFFAFAFA),
    ),
  ];

  ThemeData _buildPeppermintPaper() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFE11D48), // Bright Red
      scaffoldBackgroundColor: const Color(0xFFFFF1F2), // Very pale pink
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFE11D48),
        secondary: Color(0xFFFFFFFF), // White for stripes/marshmallows
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF881337), // Dark Red Text
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.grandstander(
          fontSize: 42,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.patrickHand(
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.patrickHand(fontSize: 18),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildKraftCocoa() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF5D4037), // Brown
      scaffoldBackgroundColor: const Color(0xFFD7CCC8), // Kraft Paper Color
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5D4037),
        secondary: Color(0xFFFFFFFF), // Marshmallow White
        surface: Color(0xFFEFEBE9),
        onSurface: Color(0xFF3E2723), // Dark Brown Text
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.caveatBrush(fontSize: 48),
        titleLarge: GoogleFonts.kalam(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.kalam(fontSize: 16),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildWinterStationer() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFB91C1C), // Deep Red
      scaffoldBackgroundColor: const Color(0xFFF5F5F5), // White Paper
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFB91C1C),
        secondary: Color(0xFF0C4A6E), // Ink Blue
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF171717), // Ink Black
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.amaticSc(
          fontSize: 56,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.josefinSlab(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.josefinSlab(fontSize: 18),
      ),
      useMaterial3: true,
    );
  }

  late final List<ThemeData> _themes = [
    _buildPeppermintPaper(),
    _buildKraftCocoa(),
    _buildWinterStationer(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _themes[_currentThemeIndex],
      home: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              // Left Panel: Showcase
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Marshmallow',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'The cozy cocoa rater.',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                        const SizedBox(height: 32),

                        // Example Card 1: Review
                        Card(
                          elevation: _cardThemes[_currentThemeIndex].elevation,
                          color: _cardThemes[_currentThemeIndex].color,
                          shape: _cardThemes[_currentThemeIndex].shape,
                          shadowColor:
                              _cardThemes[_currentThemeIndex].shadowColor,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Custom "Marshmallow" Avatar
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          16,
                                        ), // Puffy square
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.star_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Grandma\'s Kitchen',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                          ),
                                          Text(
                                            '12 mins away',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Marshmallow Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ), // Marshmallow shape
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.8),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.3),
                                            offset: const Offset(0, 4),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        '10/10',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Tastes like a warm hug on a snowy day. The homemade marshmallow was the size of a fist!',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    _buildMarshmallowChip(context, 'Homemade'),
                                    _buildMarshmallowChip(
                                      context,
                                      'Huge Portion',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Striped Button Container (Simulating Candy Cane)
                        Container(
                          width: double.infinity,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.3),
                                offset: const Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Stack(
                            children: [
                              // Optional: Add subtle stripes overlay
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: StripePainter(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    spacing: 20,
                                    strokeWidth: 5,
                                  ),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.add_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'RATE A NEW SPOT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(onTap: () {}),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right Panel: Controls
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    left: BorderSide(
                      color: Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose Paper:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(_themes.length, (index) {
                      final isSelected = _currentThemeIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 24.0,
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _currentThemeIndex = index;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.05)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey.withValues(alpha: 0.2),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _themes[index].primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _themeNames[index],
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontFamily: _themes[index]
                                          .textTheme
                                          .bodyLarge
                                          ?.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                    Divider(color: Colors.black.withValues(alpha: 0.05)),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SocialFeedScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.people),
                      label: const Text('Open Social Feed'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarshmallowChip(BuildContext context, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Marshmallow shape
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class StripePainter extends CustomPainter {
  final Color color;
  final double spacing;
  final double strokeWidth;

  StripePainter({
    required this.color,
    required this.spacing,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double totalWidth = size.width + size.height;

    for (double i = -size.height; i < totalWidth; i += spacing) {
      canvas.drawLine(
        Offset(i, size.height),
        Offset(i + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
