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
      body: Container(
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
                'Select a Subject',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _showQuestionCountDialog(context, subjects[index]);
                      },
                      child: Text(subjects[index], style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuestionCountDialog(BuildContext context, String category) {
    int selectedCount = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Select Number of Questions',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 150,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  physics: FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    // Update the selected index when user scrolls
                    setState(() {
                      selectedCount = index + 1;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      return Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 24,
                            color: (index + 1 == selectedCount) ? Colors.yellow : Colors.grey,
                          ),
                        ),
                      );
                    },
                    childCount: 50,
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      category: category,
                      questionCount: selectedCount,
                    ),
                  ),
                );
              },
              child: Text('Start Quiz', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            ),
          ],
        );
      },
    );
  }
}