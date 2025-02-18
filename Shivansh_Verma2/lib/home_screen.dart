import 'package:flutter/material.dart';
import 'package:shivansh_verma2/login_screen.dart';
import 'package:shivansh_verma2/model/todo_model.dart';
import 'package:shivansh_verma2/services/auth_services.dart';
import 'package:shivansh_verma2/services/database_services.dart';
import 'package:shivansh_verma2/widgets/pending_widget.dart';
import 'package:shivansh_verma2/widgets/completed_widget.dart';
import 'package:intl/intl.dart';
import 'package:shivansh_verma2/widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseServices _databaseServices = DatabaseServices();
  int _buttonIndex = 0;
  bool _isSearching = false;
  String _searchKeyword = '';
  int _searchTabIndex = 0;
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
      if (mounted) {
        setState(() {
          _pendingTasksForMonth =
              tasks.where((task) => !task.completed).toList();
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
          title: _isSearching
              ? TextField(
                  autofocus: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value;
                    });
                  },
                )
              : Text('ToDo'),
          leading: _isSearching
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchKeyword = '';
                    });
                  },
                )
              : null,
          actions: [
            if (!_isSearching)
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                icon: Icon(Icons.search),
              ),
            IconButton(
              onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ]),
      body: Stack(
        children: [
          SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (!_isSearching) ...[
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
                                _currentMonth = DateTime(_currentMonth.year,
                                    _currentMonth.month - 1);
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
                                  _currentMonth = DateTime(
                                      selectedYear, _currentMonth.month);
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
                            icon:
                                Icon(Icons.arrow_forward, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _currentMonth = DateTime(_currentMonth.year,
                                    _currentMonth.month + 1);
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
                          int daysInCurrentMonth =
                              _getDaysInMonth(_currentMonth);

                          DateTime dayToDisplay;
                          bool isDimmed = false;

                          if (index < offset) {
                            int prevMonthYear = _currentMonth.year;
                            int prevMonth = _currentMonth.month - 1;

                            if (prevMonth == 0) {
                              prevMonth = 12;
                              prevMonthYear = _currentMonth.year - 1;
                            }
                            int daysInPrevMonth = _getDaysInMonth(
                                DateTime(prevMonthYear, prevMonth));
                            int day = daysInPrevMonth - (offset - index - 1);
                            dayToDisplay =
                                DateTime(prevMonthYear, prevMonth, day);
                            isDimmed = true;
                          } else if (index >= offset + daysInCurrentMonth) {
                            int day = index - (offset + daysInCurrentMonth) + 1;
                            dayToDisplay = DateTime(_currentMonth.year,
                                _currentMonth.month + 1, day);
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
                              (task) =>
                                  isSameDate(task.createdAt, dayToDisplay));

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = dayToDisplay;
                                _currentMonth = DateTime(
                                    dayToDisplay.year, dayToDisplay.month);
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
                                      bottom: 4,
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
            ]),
          ),
          if (_isSearching)
            Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _searchTabIndex = 0;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                            color: _searchTabIndex == 0
                                ? Colors.orange[300]
                                : Colors.white30,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Pending',
                              style: TextStyle(
                                fontSize: _searchTabIndex == 0 ? 16 : 14,
                                fontWeight: FontWeight.w500,
                                color: _searchTabIndex == 0
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          setState(() {
                            _searchTabIndex = 1;
                          });
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.2,
                          decoration: BoxDecoration(
                            color: _searchTabIndex == 1
                                ? Colors.orange[300]
                                : Colors.white30,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: _searchTabIndex == 1 ? 16 : 14,
                                fontWeight: FontWeight.w500,
                                color: _searchTabIndex == 1
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: _buildSearchResults(),
                  ),
                ],
              ),
            ),
        ],
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
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
                          Navigator.pop(context, selectedYear);
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

  Widget _buildSearchResults() {
    if (_searchKeyword.isEmpty) {
      return Center(
        child: Text(
          'Enter a keyword to search',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return StreamBuilder<List<ToDo>>(
      stream: DatabaseServices().getAllTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text('No tasks found',
                  style: TextStyle(color: Colors.white)));
        }

        List<ToDo> filteredTasks = snapshot.data!.where((task) {
          bool matchesKeyword =
              task.title.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
                  task.description
                      .toLowerCase()
                      .contains(_searchKeyword.toLowerCase());
          bool matchesTab =
              _searchTabIndex == 0 ? !task.completed : task.completed;
          return matchesKeyword && matchesTab;
        }).toList();

        if (filteredTasks.isEmpty) {
          return Center(
            child: Text(
              'No matching tasks found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return TaskListWidget(
          tasks: filteredTasks,
          databaseServices: DatabaseServices(),
          onEditTask: (task) => _showEditTaskDialog(context, todo: task),
          onDeleteTask: (taskId) => _showDeleteConfirmation(context, taskId),
          onMarkTaskComplete: (taskId) =>
              DatabaseServices().updateTodoStatus(taskId, true),
        );
      },
    );
  }

  void _showEditTaskDialog(BuildContext context, {ToDo? todo}) {
    final TextEditingController _titleController =
        TextEditingController(text: todo?.title);
    final TextEditingController _descriptionController =
        TextEditingController(text: todo?.description);

    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 61, 61, 61),
          title: Text(
            'Edit Task',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: screenWidth * 0.045,
            ),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(color: Colors.white10),
                      labelText: "No Title",
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
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: screenWidth * 0.04),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(color: Colors.white10),
                      labelText: "No Description",
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
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
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
                style:
                    TextStyle(color: Colors.red, fontSize: screenWidth * 0.045),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _databaseServices.updateTodo(
                  todo!.id,
                  _titleController.text,
                  _descriptionController.text,
                );
                Navigator.pop(context);
              },
              child: Text(
                'Update',
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String todoId) {
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: const Color.fromARGB(255, 104, 104, 104),
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to delete this task?',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenWidth * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () async {
                      await _databaseServices.deleteTodo(todoId);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                          color: Colors.red, fontSize: screenWidth * 0.045),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white, fontSize: screenWidth * 0.045),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}