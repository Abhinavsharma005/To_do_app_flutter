import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_task_bottomsheet.dart';
import 'completed_page.dart';
import 'onboarding_page.dart';
import 'task_detail_page.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  static String routeName = 'tasks';

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  User get _user => FirebaseAuth.instance.currentUser!;

  Stream<QuerySnapshot<Map<String, dynamic>>> _taskStream() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('user',
        isEqualTo: FirebaseFirestore.instance.doc('users/${_user.uid}'))
        .where('completed', isEqualTo: false)
        .orderBy('created', descending: true)
        .snapshots();
  }

  Future<void> _toggleTaskCompleted(String taskId, bool value) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({'completed': value});
  }

  Future<void> _deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }

  void _openAddTaskSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => AddTaskBottomSheet(
        onTaskAdded: () {
          Navigator.pop(context);
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF0FE),
      appBar: AppBar(
        title: Text(
          "Tasks",
          style: GoogleFonts.interTight(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingPage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _taskStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No tasks yet",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final tasks = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final task = tasks[i];
              final title = task['title'] ?? '';
              final done = task['completed'] ?? false;

              return Dismissible(
                key: ValueKey(task.id),
                background: Container(
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.done, color: Colors.white),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    // ✅ swipe right → mark completed
                    await _toggleTaskCompleted(task.id, true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task marked completed"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            _toggleTaskCompleted(task.id, false);
                          },
                        ),
                      ),
                    );
                  } else if (direction == DismissDirection.endToStart) {
                    // ❌ swipe left → delete
                    final deletedTask = task.data();
                    await _deleteTask(task.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Task deleted"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () async {
                            // restore deleted task
                            await FirebaseFirestore.instance
                                .collection('tasks')
                                .doc(task.id)
                                .set(deletedTask);
                          },
                        ),
                      ),
                    );
                  }
                },
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailPage(taskRef: task.reference),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: done,
                          onChanged: (val) {
                            _toggleTaskCompleted(task.id, val ?? false);
                          },
                        ),
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration:
                              done ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskSheet,
        backgroundColor: const Color(0xFF39EF8C),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CompletedPage()),
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




