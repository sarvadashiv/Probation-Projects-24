import 'package:flutter/material.dart';
import 'quiz_screen.dart';

class SubjectSelectionScreen extends StatelessWidget {
  final List<String> subjects = [
    'General Knowledge',
    'Entertainment: Video Games',
    'Entertainment: Film',
    'Science: Computers',
    'Geography',
    'Music',
    'Science: Nature',
    'Food & Drink',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Subject'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionCountScreen(category: subjects[index]),
                  ),
                );
              },
              child: Text(subjects[index]),
            ),
          );
        },
      ),
    );
  }
}

class QuestionCountScreen extends StatelessWidget {
  final String category;
  final TextEditingController _controller = TextEditingController();

  QuestionCountScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Number of Questions for $category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter number of questions',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                int questionCount = int.tryParse(_controller.text) ?? 1;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(category: category, questionCount: questionCount),
                  ),
                );
              },
              child: Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}