import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/models/AstroScience_Questions.dart';
import 'package:quizzybea_in/models/Chemistry_Questions.dart';
import 'package:quizzybea_in/models/Geopolitics_Questions.dart';
import 'package:quizzybea_in/models/History_Questions.dart';
import 'package:quizzybea_in/models/Music_and_Poetry.dart';
import 'package:quizzybea_in/models/general_knoledge.dart';
import 'package:quizzybea_in/models/science_question.dart';
import 'package:quizzybea_in/services/quizz/quiz_service.dart';

class QuizzScreen extends StatefulWidget {
  final String quizzcategory;
  const QuizzScreen({super.key, required this.quizzcategory});

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  late Timer _timer;
  int _start = 15;
  late List<Map<String, dynamic>> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    final allQuestions = _getQuestionsForCategory(widget.quizzcategory);
    allQuestions.shuffle();
    questions = _getQuestionsForCategory(widget.quizzcategory)..shuffle();
    questions = questions.take(10).toList();

    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 15;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        _timer.cancel();
        _nextQuestion();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  List<Map<String, dynamic>> _getQuestionsForCategory(String category) {
    switch (category) {
      case "General Knowledge":
        return GeneralKnowledgeQuestions.gKquestions;
      case "Music & Poetry":
        return MusicAndPoetry.mPquestions;
      case "Geopolitics":
        return GeopoliticsQuestions.gPQuestions;
      case "Astro science":
        return AstroScienceQuestions.aSquestions;
      case "Chemistry":
        return ChemistryQuestions.cQuestions;
      case "History":
        return HistoryQuestions.hQuestions;
      case "Science":
        return ScienceQuestion.scienceQuestions;
      default:
        return [];
    }
  }

  void _onOptionSelected(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  void _nextQuestion() {
    if (selectedOptionIndex == questions[currentQuestionIndex]['answerIndex']) {
      score++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      _timer.cancel();
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
      });
      _startTimer();
    } else {
      _showResult();
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  void _showResult() async {
    await QuizService().saveQuizResult(
      category: widget.quizzcategory,
      score: score,
      total: questions.length,
    );

    _timer.cancel();
    // Show a dialog with the result
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 21, 0, 107),
        title: Center(
          child: const Text("Quiz Completed",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('Assets/lottie/reward.json',
                height: 200, width: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              "Your score is $score / ${questions.length}",
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "OK",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quizzcategory)),
        body: const Center(child: Text("No questions available.")),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizzcategory),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //progress bar
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "${currentQuestionIndex + 1}/${questions.length}",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),
            Text(
              "Q${currentQuestionIndex + 1}: ${currentQuestion['question']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            // Options
            ...List.generate(currentQuestion['options'].length, (index) {
              final isSelected = selectedOptionIndex == index;
              final isCorrect = currentQuestion['answerIndex'] == index;

              return GestureDetector(
                onTap: () => _onOptionSelected(index),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selectedOptionIndex == null
                        ? const Color.fromARGB(148, 238, 238, 238)
                        : isSelected
                            ? isCorrect
                                ? Colors.green[300]
                                : Colors.red[300]
                            : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    currentQuestion['options'][index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "$_start seconds",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),

            const Spacer(),

            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "${questions.length - currentQuestionIndex - (selectedOptionIndex != null ? 1 : 0)} Questions Remaining",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: selectedOptionIndex == null ? null : _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(currentQuestionIndex == questions.length - 1
                    ? "Finish"
                    : "Next"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
