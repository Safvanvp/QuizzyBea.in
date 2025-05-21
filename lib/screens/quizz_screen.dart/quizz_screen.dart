import 'package:flutter/material.dart';
import 'package:quizzybea_in/models/AstroScience_Questions.dart';
import 'package:quizzybea_in/models/Chemistry_Questions.dart';
import 'package:quizzybea_in/models/Geopolitics_Questions.dart';
import 'package:quizzybea_in/models/History_Questions.dart';
import 'package:quizzybea_in/models/Music_and_Poetry.dart';
import 'package:quizzybea_in/models/general_knoledge.dart';
import 'package:quizzybea_in/models/science_question.dart';



class QuizzScreen extends StatefulWidget {
  final String quizzcategory;
  const QuizzScreen({super.key, required this.quizzcategory});

  @override
  State<QuizzScreen> createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  late List<Map<String, dynamic>> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  int? selectedOptionIndex;

  @override
  void initState() {
    super.initState();
    questions = _getQuestionsForCategory(widget.quizzcategory);
  }

  List<Map<String, dynamic>> _getQuestionsForCategory(String category) {
    switch (category) {
      case "General Knowledge":
        return GeneralKnowledgeQuestions.gKquestions;
      case "Music & Poetry":
        return MusicAndPoetry.mPquestions;
      case "Geopolitics":
        return GeopoliticsQuestions.gPQuestions;
      case"Astro science":
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
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Completed"),
        content: Text("Your score is $score / ${questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back to home
            },
            child: const Text("OK"),
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
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
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

            const Spacer(),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: selectedOptionIndex == null ? null : _nextQuestion,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(currentQuestionIndex == questions.length - 1 ? "Finish" : "Next"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
