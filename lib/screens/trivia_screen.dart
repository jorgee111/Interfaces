import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import '../models/trivia.dart';
import '../providers/eco_state.dart';

class TriviaScreen extends StatefulWidget {
  final VoidCallback onBackToHome;

  const TriviaScreen({
    super.key,
    required this.onBackToHome,
  });

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  TriviaQuestion? _currentQuestion;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  bool _isAnswerCorrect = false;
  String _funFact = '';
  int _streak = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentQuestion == null) {
      _loadNewQuestion();
    }
  }

  void _loadNewQuestion() {
    final state = Provider.of<EcoState>(context, listen: false);
    setState(() {
      _currentQuestion = state.getRandomQuestion();
      _selectedAnswerIndex = null;
      _hasAnswered = false;
      _isAnswerCorrect = false;
      _funFact = '';
      _streak = state.state.trivia.streak;
    });
  }

  void _answerQuestion(int index) {
    if (_hasAnswered) return;

    final state = Provider.of<EcoState>(context, listen: false);
    final result = state.answerQuestion(_currentQuestion!.id, index);

    // Increment mission progress
    state.incrementMissionProgress('dm2', 1);

    setState(() {
      _selectedAnswerIndex = index;
      _hasAnswered = true;
      _isAnswerCorrect = result['correct'] as bool;
      _funFact = result['funFact'] as String;
      _streak = result['streak'] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    final stats = state.getTriviaStats();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Trivia de la Naturaleza'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: widget.onBackToHome,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: _currentQuestion == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stats panel card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Streak count
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppTheme.rSm),
                          ),
                          child: Row(
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 4),
                              Text(
                                '$_streak Rachas',
                                style: AppTheme.tXs(AppColors.orange, FontWeight.w800),
                              ),
                            ],
                          ),
                        ),

                        // Correct ratios
                        Text(
                          'Aciertos: ${stats['correct']}/${stats['answered']}',
                          style: AppTheme.tSm(AppColors.primary, FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Question Card Frame
                    Container(
                      padding: const EdgeInsets.all(AppTheme.sp5),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(AppTheme.rLg),
                        boxShadow: AppShadows.sm,
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _currentQuestion!.category.toUpperCase(),
                              style: AppTheme.tXs(AppColors.primary, FontWeight.w800),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _currentQuestion!.question,
                            style: AppTheme.tLg(textC, FontWeight.w900),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Choice options buttons list
                    ...List.generate(_currentQuestion!.options.length, (index) {
                      final option = _currentQuestion!.options[index];
                      final bool isSelected = _selectedAnswerIndex == index;
                      final bool isCorrectOption = _currentQuestion!.correct == index;

                      Color btnBorderColor = isDark ? Colors.white10 : Colors.black.withOpacity(0.08);
                      Color btnBgColor = cardBg;
                      Color textThemeColor = textC;

                      if (_hasAnswered) {
                        if (isCorrectOption) {
                          btnBorderColor = AppColors.green2;
                          btnBgColor = AppColors.green2.withOpacity(0.12);
                          textThemeColor = AppColors.green2;
                        } else if (isSelected) {
                          btnBorderColor = AppColors.red;
                          btnBgColor = AppColors.red.withOpacity(0.12);
                          textThemeColor = AppColors.red;
                        } else {
                          textThemeColor = textM.withOpacity(0.5);
                        }
                      }

                      return Padding(
                        key: ValueKey('option_$index'),
                        padding: const EdgeInsets.only(bottom: AppTheme.sp3),
                        child: InkWell(
                          onTap: () => _answerQuestion(index),
                          borderRadius: BorderRadius.circular(AppTheme.rMd),
                          child: AnimatedContainer(
                            duration: AppTheme.durFast,
                            padding: const EdgeInsets.all(AppTheme.sp4),
                            decoration: BoxDecoration(
                              color: btnBgColor,
                              borderRadius: BorderRadius.circular(AppTheme.rMd),
                              border: Border.all(color: btnBorderColor, width: isSelected || (_hasAnswered && isCorrectOption) ? 2 : 1),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  String.fromCharCode(65 + index), // A, B, C
                                  style: AppTheme.tBase(textThemeColor, FontWeight.w900),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: AppTheme.tBase(textThemeColor, FontWeight.w700),
                                  ),
                                ),
                                if (_hasAnswered)
                                  Icon(
                                    isCorrectOption
                                        ? Icons.check_circle_rounded
                                        : (isSelected ? Icons.cancel_rounded : null),
                                    color: isCorrectOption ? AppColors.green2 : AppColors.red,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),

                    // Educational Fun Fact Reveal Panel
                    if (_hasAnswered) ...[
                      FadeInUp(
                        duration: AppTheme.durNorm,
                        child: Container(
                          padding: const EdgeInsets.all(AppTheme.sp4),
                          decoration: BoxDecoration(
                            color: _isAnswerCorrect
                                ? AppColors.green2.withOpacity(0.08)
                                : AppColors.adventureGold.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(AppTheme.rLg),
                            border: Border.all(
                              color: _isAnswerCorrect
                                  ? AppColors.green2.withOpacity(0.2)
                                  : AppColors.adventureGold.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _isAnswerCorrect ? '💡 ¡ACERTADO!' : '📚 ¿SABÍAS QUÉ?',
                                    style: AppTheme.tXs(
                                      _isAnswerCorrect ? AppColors.green2 : AppColors.adventureGold,
                                      FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _funFact,
                                style: AppTheme.tSm(textC, FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Next Question Trigger Button
                      ElevatedButton(
                        onPressed: _loadNewQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.rMd),
                          ),
                          padding: const EdgeInsets.all(14),
                        ),
                        child: Text(
                          'Siguiente Pregunta',
                          style: AppTheme.tBase(Colors.white, FontWeight.w800),
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
