import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as htmlParser;

class QuizScreen extends StatefulWidget {
  final String category;
  final int questionCount;

  QuizScreen({required this.category, required this.questionCount});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  bool isLoading = true;
  bool isAnswered = false;
  String? selectedAnswer;
  int correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final url = Uri.parse(
        'https://opentdb.com/api.php?amount=${widget.questionCount}&category=${getCategoryId(widget.category)}&type=multiple');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          questions = List<Map<String, dynamic>>.from(data['results']);
          if (questions.isNotEmpty) {
            shuffleOptions();
          }
          isLoading = false;
        });
      } else {
        setState(() {
          questions = [];
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        questions = [];
        isLoading = false;
      });
    }
  }

  int getCategoryId(String category) {
    switch (category) {
      case 'General Knowledge':
        return 9;
      case 'Entertainment: Video Games':
        return 15;
      case 'Entertainment: Film':
        return 11;
      case 'Science: Computers':
        return 18;
      case 'Geography':
        return 22;
      case 'Music':
        return 12;
      case 'Science: Nature':
        return 17;
      case 'Food & Drink':
        return 19;
      default:
        return 9;
    }
  }

  void shuffleOptions() {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return;
    }

    List<String> choices = List<String>.from(questions[currentQuestionIndex]['incorrect_answers']);
    choices.add(questions[currentQuestionIndex]['correct_answer']);
    choices.shuffle();
    questions[currentQuestionIndex]['choices'] = choices;
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = false;
        selectedAnswer = null;
        shuffleOptions();
      });
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        isAnswered = false;
        selectedAnswer = null;
        shuffleOptions();
      });
    }
  }

  void checkAnswer(String selectedAnswer) {
    setState(() {
      this.selectedAnswer = selectedAnswer; // Store the selected answer
      isAnswered = true;
    });
  }

  void showSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Summary"),
          content: Text("You got $correctAnswers out of ${widget.questionCount} correct!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("Go Back"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  currentQuestionIndex = 0;
                  correctAnswers = 0;
                  isAnswered = false;
                  selectedAnswer = null;
                  questions.clear(); // Clear the current questions
                  isLoading = true; // Set loading to true
                });
                Navigator.pop(context); // Close the dialog
                fetchQuestions(); // Fetch new questions
              },
              child: Text("Restart Quiz"),
            ),
          ],
        );
      },
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // Subject at the top of the screen
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text(
                    widget.category,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50),
                // Question container
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Navigation arrows and "Question X of Y"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: currentQuestionIndex > 0 ? Colors.white : Colors.grey),
                            onPressed: currentQuestionIndex > 0 ? previousQuestion : null,
                          ),
                          Text(
                            'Question ${currentQuestionIndex + 1} of ${widget.questionCount}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward, color: currentQuestionIndex < questions.length - 1 ? Colors.white : Colors.grey),
                            onPressed: currentQuestionIndex < questions.length - 1 ? nextQuestion : null,
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Question text
                      Text(
                        htmlParser.parse(questions[currentQuestionIndex]['question']).documentElement?.text ?? '',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      // Answer choices
                      ..._buildChoices(),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Submit Answers button
                ElevatedButton(
                  onPressed: showSummary,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 36.0),
                  ),
                  child: Text('Submit Answers'),
                ),
              ],
            ),
          ),
  );
}



  List<Widget> _buildChoices() {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return [Text('No questions available', style: TextStyle(color: Colors.white))];
    }

    List<String> choices = List<String>.from(questions[currentQuestionIndex]['choices']);

    return choices.map((choice) {
      String decodedChoice = htmlParser.parse(choice).documentElement?.text ?? choice;
      bool isCorrect = decodedChoice == questions[currentQuestionIndex]['correct_answer'];

      Color backgroundColor = Colors.transparent;
      if (isAnswered) {
        if (isCorrect) {
          backgroundColor = Colors.green; // Correct answer
        } else if (selectedAnswer == decodedChoice) {
          backgroundColor = Colors.red; // Wrong selected answer
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isAnswered
                ? null // Disable buttons after answering
                : () => checkAnswer(decodedChoice),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              side: BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              elevation: 0, // Removes the shadow
            ).copyWith(
              backgroundColor: MaterialStateProperty.all(backgroundColor),
            ),
            child: Center(
              child: Text(
                decodedChoice,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}