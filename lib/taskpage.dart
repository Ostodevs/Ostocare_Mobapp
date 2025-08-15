import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  final String? taskName; // Task selected from AdminHomePage

  TaskPage({super.key, this.taskName});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Ostomy Meeting',
      'subtitle': 'Morning Session with all the nurses',
      'start': '09:00 AM',
      'end': '11:00 AM',
      'colors': [Colors.amber, Colors.teal, Colors.green],
      'gradient': [Color(0xFFB06AB3), Color(0xFF4568DC)],
    },
    {
      'title': 'Document Collection',
      'start': '11:00 AM',
      'end': '12:00 PM',
      'colors': [],
      'gradient': [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    },
    {
      'title': 'Senior Admin Meeting',
      'start': '12:00 PM',
      'end': '01:00 PM',
      'colors': [Colors.amber, Colors.teal, Colors.green],
      'gradient': [Color(0xFF434343), Color(0xFF000000)],
    },
    {
      'title': 'Personal Work',
      'start': '01:00 PM',
      'end': '',
      'colors': [],
      'gradient': [Color(0xFF9D50BB), Color(0xFF6E48AA)],
    },
  ];

  final List<String> weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI'];
  final int selectedDayIndex = 0; // Always Monday for now

  @override
  void initState() {
    super.initState();

    // Scroll to the selected task if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.taskName != null) {
        final index = tasks.indexWhere((t) => t['title'] == widget.taskName);
        if (index != -1) {
          _scrollController.animateTo(
            index * 140.0, // approximate height of each task item
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeNow = DateFormat('hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    timeNow,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1 January 2025',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: weekdays.length,
                itemBuilder: (context, index) {
                  bool selected = index == selectedDayIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: selected ? Colors.purple : Colors.grey[300],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekdays[index],
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  bool isSelected = widget.taskName == task['title'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStartTimeText(task['start']),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: List<Color>.from(task['gradient']),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                          border: isSelected
                              ? Border.all(
                                  color: Colors.deepPurple,
                                  width: 3,
                                )
                              : null,
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (task['subtitle'] != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  task['subtitle'],
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (task['colors'].isNotEmpty)
                              Row(
                                children: task['colors']
                                    .map<Widget>((c) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4.0),
                                          child: CircleAvatar(
                                            radius: 6,
                                            backgroundColor: c,
                                          ),
                                        ))
                                    .toList(),
                              ),
                            const SizedBox(height: 6),
                            Text(
                              '${task['start']} - ${task['end']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Task page active
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  String _getStartTimeText(String startTime) {
    final hour = int.tryParse(startTime.split(':')[0]) ?? 0;
    final isPM = startTime.toLowerCase().contains('pm');
    final label = isPM ? 'pm' : 'am';
    return '$hour $label';
  }
}
