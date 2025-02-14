import 'package:flutter/material.dart';
import 'package:shivansh_verma2/login_screen.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/auth_services.dart';
import 'package:shivansh_verma2/services/database_services.dart';
import 'package:shivansh_verma2/widgets/pending_widget.dart';
import 'package:shivansh_verma2/widgets/completed_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _buttonIndex = 0;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  List<Widget> get _widgets => [
        PendingWidget(selectedDate: _selectedDate),
        CompletedWidget(selectedDate: _selectedDate)
      ];
  List<String> _weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

  int _getFirstDayOffset(DateTime month) {
    int weekday = DateTime(month.year, month.month, 1).weekday;
    return (weekday % 7);
  }

  int _getCalendarGridCount(DateTime month) {
    int offset = _getFirstDayOffset(month);
    int daysInMonth = _getDaysInMonth(month);
    int totalCells = offset + daysInMonth;
    return (totalCells % 7 == 0)
        ? totalCells
        : totalCells + (7 - totalCells % 7);
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<ToDo> _pendingTasksForMonth = [];

  void _fetchPendingTasksForMonth() {
    DatabaseServices().getTodosForMonth(_currentMonth).listen((tasks) {
      if(mounted){
        setState(() {
          _pendingTasksForMonth = tasks.where((task) => !task.completed).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        title: Text('ToDo'),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                                _currentMonth.year, _currentMonth.month - 1);
                          });
                          _fetchPendingTasksForMonth();
                        },
                      ),
                      GestureDetector(
                        onTap: () async {
                          int? selectedYear = await _showYearPicker(
                              context, _currentMonth.year);
                          if (selectedYear != null) {
                            setState(() {
                              _currentMonth =
                                  DateTime(selectedYear, _currentMonth.month);
                            });
                          }
                        },
                        child: Text(
                          DateFormat('MMMM yyyy').format(_currentMonth),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _currentMonth = DateTime(
                                _currentMonth.year, _currentMonth.month + 1);
                          });
                          _fetchPendingTasksForMonth();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _weekDays.map((day) {
                        return Expanded(
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _getCalendarGridCount(_currentMonth),
                    itemBuilder: (context, index) {
                      int offset = _getFirstDayOffset(_currentMonth);
                      int daysInCurrentMonth = _getDaysInMonth(_currentMonth);

                      DateTime dayToDisplay;
                      bool isDimmed = false;

                      if (index < offset) {
                        int prevMonthYear = _currentMonth.year;
                        int prevMonth = _currentMonth.month - 1;

                        if (prevMonth == 0) {
                          prevMonth = 12;
                          prevMonthYear = _currentMonth.year - 1;
                        }
                        int daysInPrevMonth = _getDaysInMonth(DateTime(prevMonthYear, prevMonth));
                        int day = daysInPrevMonth - (offset - index - 1);
                        dayToDisplay = DateTime(prevMonthYear, prevMonth, day);
                        isDimmed = true;
                      } else if (index >= offset + daysInCurrentMonth) {
                        int day = index - (offset + daysInCurrentMonth) + 1;
                        dayToDisplay = DateTime(
                            _currentMonth.year, _currentMonth.month + 1, day);
                        isDimmed = true;
                      } else {
                        int day = index - offset + 1;
                        dayToDisplay = DateTime(
                            _currentMonth.year, _currentMonth.month, day);
                      }

                      bool isSelected =
                          dayToDisplay.year == _selectedDate.year &&
                              dayToDisplay.month == _selectedDate.month &&
                              dayToDisplay.day == _selectedDate.day;

                      bool hasPendingTasks = _pendingTasksForMonth.any(
                          (task) => isSameDate(task.createdAt, dayToDisplay));

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = dayToDisplay;
                            _currentMonth = DateTime(dayToDisplay.year, dayToDisplay.month);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(4),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    shape: BoxShape.circle,
                                  ),
                                  width: 40,
                                  height: 40,
                                ),
                              Text(
                                '${dayToDisplay.day}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.black
                                      : isDimmed
                                          ? Color.fromARGB(255, 96, 96, 96)
                                          : Colors.white,
                                ),
                              ),
                              if (hasPendingTasks)
                                Positioned(
                                  bottom:
                                      4,     
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 0;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        color: _buttonIndex == 0
                            ? Colors.orange[300]
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Pending',
                        style: TextStyle(
                            fontSize: _buttonIndex == 0 ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 0
                                ? Colors.black
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _buttonIndex = 1;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                        color: _buttonIndex == 1
                            ? Colors.orange[300]
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'Completed',
                        style: TextStyle(
                            fontSize: _buttonIndex == 1 ? 16 : 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 1
                                ? Colors.black
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            _widgets[_buttonIndex],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white38,
        child: Icon(Icons.add, color: Colors.orange),
        onPressed: () {
          _showTaskDialog(context);
        },
      ),
    );
  }

  void _showTaskDialog(BuildContext context, {ToDo? todo}) {
    final TextEditingController _titleController =
        TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: todo?.description);
    final DatabaseServices _databaseService = DatabaseServices();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 61, 61, 61),
          title: Text('Add Task',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "No Title",
                      hintStyle: TextStyle(color: Colors.white10),
                      labelText: "Title",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.white),
                    minLines: 1,
                    maxLines: null,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "No Description",
                      hintStyle: TextStyle(color: Colors.white10),
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(
                        color: Colors.white),
                    minLines: 1,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white),
              onPressed: () async {
                await _databaseService.addToDoTask(
                  _titleController.text,
                  _descriptionController.text,
                  _selectedDate,
                );
                Navigator.pop(context);
                _fetchPendingTasksForMonth();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
  int _getDaysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }
}

Future<int?> _showYearPicker(BuildContext context, int currentYear) async {
  final int startYear = 1947;
  final int endYear = DateTime.now().year + 7;
  final int initialIndex = currentYear - startYear;

  int? selectedYear = currentYear;

  return await showModalBottomSheet<int>(
    context: context,
    backgroundColor: const Color.fromARGB(255, 61, 61, 61),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 240,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Year',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                controller:
                    FixedExtentScrollController(initialItem: initialIndex),
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  selectedYear = startYear + index;
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: endYear - startYear + 1,
                  builder: (context, index) {
                    final year = startYear + index;
                    return GestureDetector(
                      onTap: () {
                        selectedYear = year;
                        Navigator.pop(
                            context, selectedYear);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: Text(
                          '$year',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: year == currentYear
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: year == currentYear
                                ? Colors.amber
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}