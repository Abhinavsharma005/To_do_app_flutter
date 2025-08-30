import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tasks_page.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  static String routeName = 'completed';

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  User get _user => FirebaseAuth.instance.currentUser!;

  Stream<QuerySnapshot<Map<String, dynamic>>> _completedTasksStream() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('user',
        isEqualTo: FirebaseFirestore.instance.doc('users/${_user.uid}'))
        .where('completed', isEqualTo: true)
        .orderBy('created', descending: true)
        .snapshots();
  }

  Future<void> _toggleTaskCompleted(String taskId, bool value) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'completed': value});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF0FE),
      appBar: AppBar(
        title: Text(
          "Completed",
          style: GoogleFonts.interTight(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _completedTasksStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;
          if (tasks.isEmpty) {
            return Center(
              child: Text(
                "No completed tasks yet",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final task = tasks[i];
              final title = task['title'] ?? '';

              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleTaskCompleted(task.id, false),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const TasksPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all_outlined),
            label: 'Completed',
          ),
        ],
      ),
    );
  }
}

