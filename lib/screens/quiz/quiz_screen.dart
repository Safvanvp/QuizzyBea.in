import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/models/quiz/question_bank.dart';
import 'package:quizzybea_in/models/user/user_level.dart';
import 'package:quizzybea_in/services/quiz/quiz_service.dart';
import 'package:quizzybea_in/theme/app_colors.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  static const int _questionCount = 10;
  static const int _timerSeconds = 15;

  late final List<Map<String, dynamic>> _questions;
  late final AnimationController _timerAnimController;

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  late Timer _timer;
  int _secondsLeft = _timerSeconds;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _questions = (QuestionBank.getQuestions(widget.category)..shuffle())
        .take(_questionCount)
        .toList();

    _timerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _timerSeconds),
    );

    _startTimer();
  }

  void _startTimer() {
    _timerAnimController.forward(from: 0);
    _secondsLeft = _timerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
        if (!_answered) _handleAnswer(null);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _handleAnswer(int? index) {
    if (_answered) return;
    _timer.cancel();
    _timerAnimController.stop();
    setState(() {
      _answered = true;
      _selectedOption = index;
      if (index == _questions[_currentIndex]['answerIndex']) _score++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
      _startTimer();
    } else {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    _timer.cancel();
    final result = await QuizService.instance.saveQuizResult(
      category: widget.category,
      score: _score,
      total: _questions.length,
    );
    if (mounted) _showResultDialog(result);
  }

  void _showResultDialog(QuizSaveResult result) {
    final pct = (_score / _questions.length * 100).round();
    final level = result.newLevel;
    final progress = UserLevel.levelProgress(result.newTotalXP);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Level-up banner
              if (result.leveledUp)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        level.color.withAlpha(80),
                        level.color.withAlpha(30),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: level.color.withAlpha(120)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(level.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text(
                        'Level Up! You are now ${level.name}',
                        style: TextStyle(
                          color: level.color,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

              Lottie.asset(
                'Assets/lottie/reward.json',
                height: 140,
                width: 140,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text(
                'Quiz Completed!',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 6),
              Text(
                '$_score / ${_questions.length} correct',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              _ScoreBadge(percentage: pct),
              const SizedBox(height: 16),

              // XP card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(level.emoji,
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            Text(
                              'Lv.${level.level} ${level.name}',
                              style: TextStyle(
                                color: level.color,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        // XP earned chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withAlpha(36),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '+${result.xpEarned} XP',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Level progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.divider,
                        valueColor: AlwaysStoppedAnimation(level.color),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${result.newTotalXP} XP total',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.textHint),
                        ),
                        if (level.maxXP != -1)
                          Text(
                            '${UserLevel.xpToNextLevel(result.newTotalXP)} XP to next level',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: AppColors.textHint),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.pop();
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _timerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.category)),
        body: const Center(child: Text('No questions available.')),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text(widget.category),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              _ProgressRow(
                current: _currentIndex + 1,
                total: _questions.length,
                secondsLeft: _secondsLeft,
                totalSeconds: _timerSeconds,
                controller: _timerAnimController,
              ),
              const SizedBox(height: 24),
              // Question card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider, width: 0.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${_currentIndex + 1}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.primaryLight),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      question['question'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Options
              Expanded(
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (question['options'] as List).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _OptionTile(
                    text: question['options'][i] as String,
                    index: i,
                    selectedIndex: _selectedOption,
                    correctIndex:
                        _answered ? question['answerIndex'] as int : null,
                    answered: _answered,
                    onTap: _answered ? null : () => _handleAnswer(i),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_answered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    child: Text(
                      _currentIndex == _questions.length - 1
                          ? 'See Results'
                          : 'Next Question',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final int current;
  final int total;
  final int secondsLeft;
  final int totalSeconds;
  final AnimationController controller;

  const _ProgressRow({
    required this.current,
    required this.total,
    required this.secondsLeft,
    required this.totalSeconds,
    required this.controller,
  });

  Color get _timerColor {
    if (secondsLeft > 10) return AppColors.success;
    if (secondsLeft > 5) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Progress
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$current / $total',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: current / total,
                  minHeight: 6,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Timer circle
        SizedBox(
          width: 54,
          height: 54,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedBuilder(
                animation: controller,
                builder: (_, __) => CircularProgressIndicator(
                  value: 1 - controller.value,
                  strokeWidth: 4,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation(_timerColor),
                ),
              ),
              Center(
                child: Text(
                  '$secondsLeft',
                  style: TextStyle(
                    color: _timerColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final int? selectedIndex;
  final int? correctIndex;
  final bool answered;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.correctIndex,
    required this.answered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = AppColors.divider;
    Color bgColor = AppColors.bgCard;
    Color textColor = AppColors.textPrimary;
    IconData? trailingIcon;

    if (answered && correctIndex == index) {
      borderColor = AppColors.success;
      bgColor = AppColors.success.withOpacity(0.12);
      textColor = AppColors.success;
      trailingIcon = Icons.check_circle_rounded;
    } else if (answered &&
        selectedIndex == index &&
        selectedIndex != correctIndex) {
      borderColor = AppColors.error;
      bgColor = AppColors.error.withOpacity(0.12);
      textColor = AppColors.error;
      trailingIcon = Icons.cancel_rounded;
    } else if (!answered && selectedIndex == index) {
      borderColor = AppColors.primary;
      bgColor = AppColors.primary.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, color: textColor, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final int percentage;
  const _ScoreBadge({required this.percentage});

  @override
  Widget build(BuildContext context) {
    Color color;
    String emoji;
    if (percentage >= 80) {
      color = AppColors.success;
      emoji = '🎉';
    } else if (percentage >= 50) {
      color = AppColors.warning;
      emoji = '💪';
    } else {
      color = AppColors.error;
      emoji = '📚';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        '$emoji  $percentage% accuracy',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
