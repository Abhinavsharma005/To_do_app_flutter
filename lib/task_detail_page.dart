import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskDetailPage extends StatefulWidget {
  final DocumentReference taskRef;

  const TaskDetailPage({super.key, required this.taskRef});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  bool _editing = false;
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    final snapshot = await widget.taskRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    _titleController.text = data['title'] ?? '';
    _detailsController.text = data['details'] ?? '';
  }

  Future<void> _updateTask() async {
    await widget.taskRef.update({
      'title': _titleController.text,
      'details': _detailsController.text,
    });
    setState(() => _editing = false);
    Navigator.pop(context); // go back to TasksPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF0FE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF070E3A)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () {
                        setState(() => _editing = !_editing);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Task Details",
                    style: GoogleFonts.interTight(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                Text("Task",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _titleController,
                  readOnly: !_editing,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _editing ? Colors.white : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                Text("Details",
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _detailsController,
                  readOnly: !_editing,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _editing ? Colors.white : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _editing ? _updateTask : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39EF8C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    "Update Task",
                    style: GoogleFonts.interTight(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
