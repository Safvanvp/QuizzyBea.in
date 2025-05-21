import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzybea_in/services/quizz/quiz_service.dart';
import 'package:quizzybea_in/theme/colors.dart'; // Optional for color theming

class UserQuizHistoryPage extends StatefulWidget {
  const UserQuizHistoryPage({super.key});

  @override
  State<UserQuizHistoryPage> createState() => _UserQuizHistoryPageState();
}

class _UserQuizHistoryPageState extends State<UserQuizHistoryPage> {
  List<Map<String, dynamic>> _quizHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizHistory();
  }

  Future<void> _loadQuizHistory() async {
    final history = await QuizService().getQuizHistory();
    setState(() {
      _quizHistory = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Quiz History'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quizHistory.isEmpty
              ? const Center(
                  child: Text(
                    'No quiz attempts yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _quizHistory.length,
                  itemBuilder: (context, index) {
                    final quiz = _quizHistory[index];
                    final timestamp = quiz['timestamp'] as Timestamp;
                    final dateTime = timestamp.toDate();

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.deepPurple.shade100,
                              child: const Icon(Icons.school,
                                  color: Colors.deepPurple),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quiz['category'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Score: ${quiz['score']} / ${quiz['total']}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today,
                                          size: 16, color: Colors.blueGrey),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${dateTime.day}/${dateTime.month}/${dateTime.year} | ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}',
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
