import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'theme.dart';
import 'widgets/cyber_card.dart';

class CyberpunkMain extends StatelessWidget {
  const CyberpunkMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: CyberTheme.themeData,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildStatsRow(),
                    const SizedBox(height: 24),
                    Text(
                      "TRAJECTORY // UPCOMING",
                      style: Theme.of(context).textTheme.titleLarge,
                    ).animate().fadeIn().moveX(begin: -10),
                    const SizedBox(height: 12),
                    _buildAnimeList(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NEON // TRACKER",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  letterSpacing: 2,
                  color: CyberTheme.neonCyan,
                ),
              ),
              Text("ROOSHI", style: Theme.of(context).textTheme.displayMedium),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: CyberTheme.neonPink),
              shape: BoxShape.circle,
            ),
            child: Icon(PhosphorIcons.userCircle()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard("WATCHING", "12", CyberTheme.neonPink)),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard("PLAN TO WATCH", "48", CyberTheme.neonCyan),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return CyberCard(
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimeList() {
    return Column(
      children: [
        _buildAnimeItem("Cyberpunk: Edgerunners", "EP 10 / 10", true),
        const SizedBox(height: 12),
        _buildAnimeItem("Akira", "MOVIE", false),
        const SizedBox(height: 12),
        _buildAnimeItem("Ghost in the Shell", "MOVIE", false),
      ].animate(interval: 100.ms).fadeIn().slideX(),
    );
  }

  Widget _buildAnimeItem(String title, String progress, bool isActive) {
    return CyberCard(
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            color: Colors.grey[900],
            child: const Icon(
              Icons.movie,
              color: Colors.white24,
            ), // Placeholder for image
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.monitorPlay(),
                      size: 14,
                      color: isActive ? CyberTheme.neonGreen : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      progress,
                      style: TextStyle(
                        color: isActive ? CyberTheme.neonGreen : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(PhosphorIcons.caretRight(), color: CyberTheme.neonPink),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: CyberTheme.cardBg,
        border: Border(top: BorderSide(color: CyberTheme.neonPink, width: 2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(PhosphorIcons.house(), color: CyberTheme.neonPink),
          Icon(PhosphorIcons.magnifyingGlass(), color: Colors.white54),
          Icon(PhosphorIcons.list(), color: Colors.white54),
        ],
      ),
    );
  }
}
