import 'package:flutter/material.dart';
import 'dart:math';

import 'package:shivansh_verma3/pages/subject_selection_screen.dart';

class SummaryScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final double percentageCorrect = correctAnswers / totalQuestions;
    final double percentageIncorrect =
        (totalQuestions - correctAnswers - unattemptedQuestions) / totalQuestions;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Quiz Summary - $subjectName",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 100,
              child: CustomPaint(
                size: Size(double.infinity, 100),
                painter: RingPainter(
                  percentageCorrect: percentageCorrect,
                  percentageIncorrect: percentageIncorrect,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$correctAnswers / $totalQuestions",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Correct",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Unattempted Questions: $unattemptedQuestions",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectSelectionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "Restart Quiz",
                style: TextStyle(fontSize: 18, color: Colors.yellowAccent),
              ),
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