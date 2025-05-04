import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TrackProgress(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TrackProgress extends StatefulWidget {
  const TrackProgress({super.key});

  @override
  State<TrackProgress> createState() => _TrackProgressState();
}

class _TrackProgressState extends State<TrackProgress> {
  final Map<String, String> _selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tell me how you are feeling Today',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How are you feeling today?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 117, 105, 105)),
              ),
              SizedBox(height: 16),
              buildCategory(
                title: 'Skin Condition',
                borderColor: Colors.teal,
                options: ['Good', 'Normal', 'Itching', 'Aching', 'Burning'],
                backgroundColor: Colors.teal[100],
                selectedColor: Colors.teal,
              ),
              buildCategory(
                title: 'Stool Nature',
                borderColor: Colors.purple,
                options: ['Watery', 'Semi Solid', 'Solid'],
                backgroundColor: Colors.purple[100],
                selectedColor: Colors.purple,
              ),
              buildCategory(
                title: 'Emptying Frequency',
                borderColor: Colors.teal,
                options: ['1 - 5 times', '5 - 10 times', '10+ times'],
                backgroundColor: Colors.teal[100],
                selectedColor: Colors.teal,
              ),
              buildCategory(
                title: 'Appetite',
                borderColor: Colors.pink,
                options: ['Good', 'Fair', 'Bad'],
                backgroundColor: Colors.pink[100],
                selectedColor: Colors.pink,
              ),
              buildCategory(
                title: 'Other Symptoms',
                borderColor: Colors.purple,
                options: ['Nausea', 'Bloating', 'Abdominal Pain', 'None'],
                backgroundColor: Colors.purple[100],
                selectedColor: Colors.purple,
              ),
              buildCategory(
                title: 'Emotional Wellbeing',
                borderColor: Colors.purple,
                options: [
                  'Happy',
                  'Stressed',
                  'Self Conscious',
                  'Anxious',
                  'Depressed',
                  'Calm'
                ],
                backgroundColor: Colors.pink[100],
                selectedColor: Colors.pink,
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    //logic here
                    print('Saved: $_selectedOptions');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Progress saved successfully!')),
                    );
                  },
                  label: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategory({
    required String title,
    required Color borderColor,
    required List<String> options,
    required Color? backgroundColor,
    required Color selectedColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = _selectedOptions[title] == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: selectedColor.withOpacity(0.8),
                onSelected: (_) {
                  setState(() {
                    _selectedOptions[title] = option;
                  });
                },
                backgroundColor: backgroundColor,
                labelStyle: TextStyle(
                    color: isSelected ? Colors.white : selectedColor,
                    fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
