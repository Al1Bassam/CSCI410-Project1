import 'package:flutter/material.dart';


/// Uses ChangeNotifier to notify listeners of state changes
class QuizProvider with ChangeNotifier {
  // List of questions with their options, correct answers, and tips
  // Index of correct answer corresponds to the option's position (0-3)
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the capital of France?',
      'options': ['London', 'Berlin', 'Paris', 'Madrid'],
      'correctAnswer': 2,
      'tip': 'This city is known as the "City of Light" and has the Eiffel Tower.',
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Venus', 'Mars', 'Jupiter', 'Saturn'],
      'correctAnswer': 1,
      'tip': 'This planet gets its reddish color from iron oxide (rust) on its surface.',
    },
    {
      'question': 'What is the largest mammal in the world?',
      'options': ['African Elephant', 'Blue Whale', 'Giraffe', 'Polar Bear'],
      'correctAnswer': 1,
      'tip': 'This marine mammal can grow up to 100 feet long.',
    },
    {
      'question': 'Who painted the Mona Lisa?',
      'options': ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
      'correctAnswer': 2,
      'tip': 'This Italian Renaissance polymath also designed flying machines.',
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Ag', 'Fe', 'Au', 'Cu'],
      'correctAnswer': 2,
      'tip': 'This symbol comes from the Latin word "aurum".',
    },
    {
      'question': 'Which country is home to the kangaroo?',
      'options': ['New Zealand', 'South Africa', 'Australia', 'Brazil'],
      'correctAnswer': 2,
      'tip': 'This country is both a continent and an island.',
    },
    {
      'question': 'What is the largest ocean on Earth?',
      'options': ['Atlantic Ocean', 'Indian Ocean', 'Arctic Ocean', 'Pacific Ocean'],
      'correctAnswer': 3,
      'tip': 'This ocean covers about 30% of Earth\'s surface and means "peaceful".',
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Mark Twain'],
      'correctAnswer': 1,
      'tip': 'This English playwright also wrote "Hamlet" and "Macbeth".',
    },
    {
      'question': 'What is the square root of 64?',
      'options': ['6', '7', '8', '9'],
      'correctAnswer': 2,
      'tip': 'Think about what number multiplied by itself equals 64.',
    },
    {
      'question': 'Which element has the atomic number 1?',
      'options': ['Helium', 'Oxygen', 'Hydrogen', 'Carbon'],
      'correctAnswer': 2,
      'tip': 'This is the lightest and most abundant element in the universe.',
    },
  ];

  // State variables
  int _currentQuestionIndex = 0;  // Tracks current question being displayed
  int _score = 0;                 // Keeps track of correct answers
  int? _selectedAnswer;           // Currently selected answer (-1 if none)
  bool _isAnswered = false;       // Whether current question has been answered
  int _timer = 30;                // Timer countdown for current question
  int _tipsRemaining = 4;         // Number of tips available to use
  bool _tipUsedForCurrentQuestion = false;  // Prevents multiple tip usage per question

  // Getters for accessing state
  List<Map<String, dynamic>> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  int? get selectedAnswer => _selectedAnswer;
  bool get isAnswered => _isAnswered;
  int get timer => _timer;
  bool get isLastQuestion => _currentQuestionIndex == _questions.length - 1;
  int get tipsRemaining => _tipsRemaining;
  bool get tipUsedForCurrentQuestion => _tipUsedForCurrentQuestion;

  //answer selection

  void selectAnswer(int index) {
    if (!_isAnswered) {
      _selectedAnswer = index;
      notifyListeners();
    }
  }

  // Validtes the selected answer and updates score
  // returns early if no answer is selected
  void checkAnswer() {
    if (_selectedAnswer == null) return;

    _isAnswered = true;
    if (_selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer']) {
      _score++;
    }
    notifyListeners();
  }

  /// Moves to the next question if available
  /// Resets question-specific states (selected answer, timer, tip usage)
  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswered = false;
      _timer = 30;
      _tipUsedForCurrentQuestion = false;
      notifyListeners();
    }
  }

  /// Resets the entire quiz state to initial values
  
  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    _isAnswered = false;
    _timer = 30;
    _tipsRemaining = 4;
    _tipUsedForCurrentQuestion = false;
    notifyListeners();
  }

  /// Updates the timer countdown
  /// Called every second while question is active
  void updateTimer() {
    if (_timer > 0) {
      _timer--;
      notifyListeners();
    }
  }

  /// Provides a tip for the current question if available
  /// Returns null if no tips remaining or tip already used for current question
  String? useTip() {
    if (_tipsRemaining > 0 && !_tipUsedForCurrentQuestion) {
      _tipsRemaining--;
      _tipUsedForCurrentQuestion = true;
      notifyListeners();
      return _questions[_currentQuestionIndex]['tip'];
    }
    return null;
  }
} 