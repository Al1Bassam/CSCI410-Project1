import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart';

// Main screen for displaying and handling quiz questions

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Stores the currently displayed tip text
  String? _currentTip;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  /// Handles the countdown timer logic
  /// Updates every second and triggers answer check when time runs out
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final provider = Provider.of<QuizProvider>(context, listen: false);
        if (provider.timer > 0 && !provider.isAnswered) {
          provider.updateTimer();
          _startTimer();
        } else if (provider.timer == 0 && !provider.isAnswered) {
          provider.checkAnswer();
          _moveToNextQuestion();
        }
      }
    });
  }

  /// Handles transition to next question or results screen
  /// Includes delay for showing answer feedback
  void _moveToNextQuestion() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _currentTip = null);  // Clear the tip when moving to next question
        final provider = Provider.of<QuizProvider>(context, listen: false);
        if (provider.isLastQuestion) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultScreen(),
            ),
          );
        } else {
          provider.nextQuestion();
          _startTimer();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar 
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          final currentQuestion = provider.questions[provider.currentQuestionIndex];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Line showing how far in the quiz
                LinearProgressIndicator(
                  value: (provider.currentQuestionIndex + 1) / provider.questions.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                const SizedBox(height: 20),

                // Question number 
                Text(
                  'Question ${provider.currentQuestionIndex + 1}/${provider.questions.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Timer 
                Text(
                  'Time remaining: ${provider.timer} seconds',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),

                // Question text
                Text(
                  currentQuestion['question'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Answer options
                ...List.generate(
                  currentQuestion['options'].length,
                  (index) {
                    final isSelected = provider.selectedAnswer == index;
                    final isCorrect = index == currentQuestion['correctAnswer'];
                    
                    // Determine button color based on answer state
                    Color? buttonColor;
                    if (provider.isAnswered) {
                      if (isSelected) {
                        buttonColor = isCorrect ? Colors.green : Colors.red;
                      } else if (isCorrect) {
                        buttonColor = Colors.green;
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: provider.isAnswered
                            ? null
                            : () => provider.selectAnswer(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // Border color for answer feedback
                            side: BorderSide(
                              color: provider.isAnswered && isSelected
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          currentQuestion['options'][index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),

                // Tip display 
                if (_currentTip != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      _currentTip!,
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),

                // Bottom row with tips and submit button
                Row(
                  children: [
                    // Tips indicator and button
                    Row(
                      children: [
                        // Tip availability 
                        ...List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.lightbulb,
                              color: index < provider.tipsRemaining 
                                  ? Colors.amber 
                                  : Colors.grey[300],
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Use tip button
                        if (provider.tipsRemaining > 0 && !provider.tipUsedForCurrentQuestion)
                          ElevatedButton.icon(
                            onPressed: () {
                              final tip = provider.useTip();
                              if (tip != null) {
                                setState(() => _currentTip = tip);
                              }
                            },
                            icon: const Icon(Icons.lightbulb, color: Colors.white),
                            label: const Text(
                              'Use a Tip',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    // Submit answer button
                    if (!provider.isAnswered && provider.selectedAnswer != null)
                      ElevatedButton(
                        onPressed: () {
                          provider.checkAnswer();
                          _moveToNextQuestion();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                        child: const Text(
                          'Submit Answer',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 