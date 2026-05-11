import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/quote_service.dart';
import '../models/task_model.dart';
import '../widgets/quote_card.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  final _quoteService = QuoteService();
  
  late TabController _tabController;
  String _quote = '';
  String _author = '';
  bool _quoteLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadQuote();
  }

  Future<void> _loadQuote() async {
    setState(() => _quoteLoading = true);
    final result = await _quoteService.fetchQuote();
    setState(() {
      _quote = result['content']!;
      _author = result['author']!;
      _quoteLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white60),
                      ),
                      Text(
                        user?.displayName ?? 'User',
                        style: GoogleFonts.sora(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF1E293B),
                      child: Text(
                        (user?.displayName != null && user!.displayName!.isNotEmpty
                                ? user.displayName![0]
                                : (user?.email ?? 'U')[0])
                            .toUpperCase(),
                        style: const TextStyle(color: Color(0xFF06B6D4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: QuoteCard(
                quote: _quote,
                author: _author,
                isLoading: _quoteLoading,
                onRefresh: _loadQuote,
              ),
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF06B6D4),
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white30,
              labelStyle: GoogleFonts.dmSans(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Pending'),
                Tab(text: 'Completed'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTaskList(null),
                  _buildTaskList('pending'),
                  _buildTaskList('completed'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
        ),
        backgroundColor: const Color(0xFF06B6D4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskList(String? statusFilter) {
    final user = _authService.getCurrentUser();
    if (user == null) return const SizedBox();

    return StreamBuilder<List<TaskModel>>(
      stream: _firestoreService.getTasks(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF06B6D4)));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
        }

        final tasks = snapshot.data ?? [];
        final filteredTasks = statusFilter == null
            ? tasks
            : tasks.where((t) => t.status == statusFilter).toList();

        if (filteredTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.task_alt, size: 64, color: Colors.white10),
                const SizedBox(height: 16),
                Text(
                  'No tasks here yet',
                  style: GoogleFonts.dmSans(color: Colors.white30),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return TaskCard(
              task: task,
              onEdit: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
              ),
              onDelete: () => _firestoreService.deleteTask(user.uid, task.id),
              onToggleComplete: (val) => _firestoreService.markComplete(user.uid, task.id, val),
            );
          },
        );
      },
    );
  }
}
