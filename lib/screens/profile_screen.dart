import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/task_model.dart';
import 'developer_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();
    final user = authService.getCurrentUser();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Profile', style: GoogleFonts.sora(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: firestoreService.getTasks(user?.uid ?? ''),
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];
          final completed = tasks.where((t) => t.status == 'completed').length;
          final pending = tasks.where((t) => t.status == 'pending').length;

          return Column(
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF1E293B),
                      child: Text(
                        (user?.displayName != null && user!.displayName!.isNotEmpty
                                ? user.displayName![0]
                                : (user?.email ?? 'U')[0])
                            .toUpperCase(),
                        style: GoogleFonts.sora(
                          fontSize: 40,
                          color: const Color(0xFF06B6D4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _capitalize(user?.displayName ?? 'User'),
                      style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user?.email ?? '',
                      style: GoogleFonts.dmSans(color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    _buildStatCard('Total', tasks.length.toString(), const Color(0xFF6366F1)),
                    const SizedBox(width: 16),
                    _buildStatCard('Completed', completed.toString(), Colors.greenAccent),
                    const SizedBox(width: 16),
                    _buildStatCard('Pending', pending.toString(), Colors.orangeAccent),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildMenuItem(
                icon: Icons.person_outline,
                title: 'About Developer',
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => const DeveloperScreen()),
                ),
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                isDestructive: true,
                onTap: () async {
                  await authService.logout();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1e1b38),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2a3a55)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDestructive ? Colors.redAccent : Colors.white70),
      title: Text(
        title,
        style: GoogleFonts.dmSans(
          color: isDestructive ? Colors.redAccent : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
