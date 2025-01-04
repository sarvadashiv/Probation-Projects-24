import 'package:flutter/material.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:shivansh_verma3/pages/subject_selection_screen.dart';

class SummaryScreen extends StatefulWidget {
  final String subjectName;
  final int correctAnswers;
  final int totalQuestions;
  final int unattemptedQuestions;

  SummaryScreen({
    required this.subjectName,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.unattemptedQuestions,
  });

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));

    if (widget.correctAnswers >= 1 &&
        widget.correctAnswers >= widget.totalQuestions / 2) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double percentageCorrect = widget.correctAnswers / widget.totalQuestions;
    final double percentageIncorrect =
        (widget.totalQuestions - widget.correctAnswers - widget.unattemptedQuestions) /
            widget.totalQuestions;

    final bool showConfetti =
        widget.correctAnswers >= 1 && widget.correctAnswers >= widget.totalQuestions / 2;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            if (showConfetti)
              Positioned(
                top: 0,
                left: screenWidth * 0.4,
                right: 0,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: [Colors.green, Colors.blue, Colors.yellow, Colors.pink],
                  numberOfParticles: 50,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "Quiz Summary - ${widget.subjectName}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                SizedBox(
                  width: double.infinity,
                  height: screenHeight * 0.2,
                  child: CustomPaint(
                    size: Size(double.infinity, screenHeight * 0.2),
                    painter: RingPainter(
                      percentageCorrect: percentageCorrect,
                      percentageIncorrect: percentageIncorrect,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.correctAnswers} / ${widget.totalQuestions}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Correct",
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    "Unattempted Questions: ${widget.unattemptedQuestions}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (!showConfetti)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "Better Luck Next Time!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.1),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubjectSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
                  ),
                  child: Text(
                    "Restart Quiz",
                    style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.yellow),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final double percentageCorrect;
  final double percentageIncorrect;

  RingPainter({
    required this.percentageCorrect,
    required this.percentageIncorrect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    final Paint correctPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final Paint incorrectPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final double radius = (size.width / 2) / 2.75;

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), radius, backgroundPaint);

    final double startAngleCorrect = -pi / 2;
    final double sweepAngleCorrect = 2 * pi * percentageCorrect;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      startAngleCorrect,
      sweepAngleCorrect,
      false,
      correctPaint,
    );

    final double startAngleIncorrect = startAngleCorrect + sweepAngleCorrect;
    final double sweepAngleIncorrect = 2 * pi * percentageIncorrect;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: radius),
      startAngleIncorrect,
      sweepAngleIncorrect,
      false,
      incorrectPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}