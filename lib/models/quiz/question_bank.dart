/// Central question registry — maps category names to question lists.
/// All existing question data files are re-exported through here.
import 'package:quizzybea_in/models/quizz/AstroScience_Questions.dart';
import 'package:quizzybea_in/models/quizz/Chemistry_Questions.dart';
import 'package:quizzybea_in/models/quizz/Geopolitics_Questions.dart';
import 'package:quizzybea_in/models/quizz/History_Questions.dart';
import 'package:quizzybea_in/models/quizz/Music_and_Poetry.dart';
import 'package:quizzybea_in/models/quizz/general_knoledge.dart';
import 'package:quizzybea_in/models/quizz/science_question.dart';

class QuestionBank {
  QuestionBank._();

  static List<Map<String, dynamic>> getQuestions(String category) {
    switch (category) {
      case 'General Knowledge':
        return GeneralKnowledgeQuestions.gKquestions;
      case 'Music & Poetry':
        return MusicAndPoetry.mPquestions;
      case 'Geopolitics':
        return GeopoliticsQuestions.gPQuestions;
      case 'Astro science':
        return AstroScienceQuestions.aSquestions;
      case 'Chemistry':
        return ChemistryQuestions.cQuestions;
      case 'History':
        return HistoryQuestions.hQuestions;
      case 'Science':
        return ScienceQuestion.scienceQuestions;
      default:
        return [];
    }
  }
}
