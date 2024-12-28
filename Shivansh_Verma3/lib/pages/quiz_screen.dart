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
    final url = Uri.parse('https://opentdb.com/api.php?amount=${widget.questionCount}&category=${getCategoryId(widget.category)}&type=multiple');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        questions = List<Map<String, dynamic>>.from(data['results']);
        shuffleOptions();
        isLoading = false;
      });
    } else {
      setState(() {
        questions = [];
        isLoading = false;
      });
    }
  }

  int getCategoryId(String category) {
    switch (category) {
      case 'General Knowledge': return 9;
      case 'Entertainment: Video Games': return 15;
      case 'Entertainment: Film': return 11;
      case 'Science: Computers': return 18;
      case 'Geography': return 22;
      case 'Music': return 12;
      case 'Science: Nature': return 17;
      case 'Food & Drink': return 19;
      default: return 9;
    }
  }

  void shuffleOptions() {
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
    } else {
      showSummary();
    }
  }

  void checkAnswer(String selectedAnswer) {
    setState(() {
      this.selectedAnswer = selectedAnswer;
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
                });
                Navigator.pop(context);
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
      //appBar: null,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                      widget.category,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Question ${currentQuestionIndex + 1} of ${widget.questionCount}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Text(
                          htmlParser.parse(questions[currentQuestionIndex]['question']).documentElement?.text ?? '',
                          style: TextStyle(fontSize: 22, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ..._buildChoices(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: isAnswered ? nextQuestion : null,
                          child: Text('Next Question'),
                        ),
                ],
              ),
            ),
    );
  }
List<Widget> _buildChoices() {
  List<String> choices = List<String>.from(questions[currentQuestionIndex]['choices']);

  return choices.map((choice) {
    String decodedChoice = htmlParser.parse(choice).documentElement?.text ?? choice;
    
    bool isCorrect = decodedChoice == questions[currentQuestionIndex]['correct_answer'];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: isAnswered ? null : () {
          checkAnswer(decodedChoice);
          if (decodedChoice == questions[currentQuestionIndex]['correct_answer']) {
            correctAnswers++;
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            selectedAnswer == decodedChoice
                ? (isCorrect ? Colors.green : Colors.red)
                : Colors.grey,
          ),
        ),
        child: Text(decodedChoice),
      ),
    );
  }).toList();
}
}