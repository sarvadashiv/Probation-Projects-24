import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' as htmlParser;
import 'package:shivansh_verma3/pages/Summary.dart';

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
  Map<int, String> markedAnswers = {};
  int correctAnswers = 0;
  bool isReviewMode = false;

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
      case 'Maths':
        return 19;
      default:
        return 9;
    }
  }

  void shuffleOptions() {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return;
    }

    if (!questions[currentQuestionIndex].containsKey('choices')) {
      List<String> choices = List<String>.from(
          questions[currentQuestionIndex]['incorrect_answers']);
      choices.add(questions[currentQuestionIndex]['correct_answer']);
      choices.shuffle();
      questions[currentQuestionIndex]['choices'] = choices;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        isAnswered = markedAnswers.containsKey(currentQuestionIndex);
        shuffleOptions();
        selectedAnswer = null;
      });
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        isAnswered = markedAnswers.containsKey(currentQuestionIndex);
        shuffleOptions();
        selectedAnswer = null;
      });
    }
  }

  void checkAnswer(String selectedAnswer) {
    setState(() {
      this.selectedAnswer = selectedAnswer;
    });
  }

  void markAnswer() {
    if (selectedAnswer != null) {
      setState(() {
        markedAnswers[currentQuestionIndex] = selectedAnswer!;
        if (selectedAnswer ==
            questions[currentQuestionIndex]['correct_answer']) {
          correctAnswers++;
        }
        selectedAnswer = null;
      });
    }
  }

  void showSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Submit Answers',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to submit your answers?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.yellow),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(
                      subjectName: widget.category,
                      correctAnswers: correctAnswers,
                      totalQuestions: widget.questionCount,
                      unattemptedQuestions:
                          widget.questionCount - markedAnswers.length,
                    ),
                  ),
                ).then((_) {
                  setState(() {
                    isReviewMode = true;
                    selectedAnswer = null;
                  });
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : questions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No questions available.'),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton(
                        onPressed: fetchQuestions,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/bg1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.05,
                              left: screenWidth * 0.05,
                              right: screenWidth * 0.05),
                          child: Text(
                            widget.category,
                            style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.02),
                              ),
                              margin:
                                  EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.arrow_back,
                                            color: currentQuestionIndex > 0
                                                ? Colors.white
                                                : Colors.grey),
                                        onPressed: currentQuestionIndex > 0
                                            ? previousQuestion
                                            : null,
                                      ),
                                      Text(
                                        'Question ${currentQuestionIndex + 1} of ${widget.questionCount}',
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.arrow_forward,
                                            color: currentQuestionIndex <
                                                    questions.length - 1
                                                ? Colors.white
                                                : Colors.grey),
                                        onPressed: currentQuestionIndex <
                                                questions.length - 1
                                            ? nextQuestion
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    htmlParser
                                            .parse(
                                                questions[currentQuestionIndex]
                                                    ['question'])
                                            .documentElement
                                            ?.text ??
                                        '',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.05,
                                        color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  ..._buildChoices(screenWidth, screenHeight),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: showSummary,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                    horizontal: screenWidth * 0.08),
                              ),
                              child: Text('Submit Answers'),
                            ),
                            ElevatedButton(
                              onPressed: selectedAnswer != null &&
                                      !markedAnswers
                                          .containsKey(currentQuestionIndex)
                                  ? markAnswer
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                    horizontal: screenWidth * 0.08),
                              ),
                              child: Text('Mark Answer'),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ],
                ),
    );
  }

  List<Widget> _buildChoices(double screenWidth, double screenHeight) {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return [
        Text('No questions available', style: TextStyle(color: Colors.white))
      ];
    }

    List<String> choices =
        List<String>.from(questions[currentQuestionIndex]['choices']);
    String? markedAnswer = markedAnswers[currentQuestionIndex];

    return choices.map((choice) {
      String decodedChoice =
          htmlParser.parse(choice).documentElement?.text ?? choice;
      bool isCorrect =
          decodedChoice == questions[currentQuestionIndex]['correct_answer'];

      Color backgroundColor = Colors.transparent;
      Color borderColor = Colors.white;

      if (markedAnswer != null) {
        if (isCorrect) {
          backgroundColor = Colors.green;
        } else if (markedAnswer == decodedChoice) {
          backgroundColor = Colors.red;
        }
      } else if (selectedAnswer == decodedChoice) {
        borderColor = Colors.blue;
      }

      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01, horizontal: screenWidth * 0.02),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (isReviewMode || markedAnswer != null)
                ? null
                : () => checkAnswer(decodedChoice),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              side: MaterialStateProperty.all(
                  BorderSide(color: borderColor, width: 2)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
              ),
            ),
            child: Text(
              decodedChoice,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}