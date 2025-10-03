import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_cascade_manager/providers/task_provider.dart';
import 'package:task_cascade_manager/widgets/day_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    '📋 Task Manager',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Organize your tasks day by day',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<TaskProvider>(context, listen: false).addDay();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add New Day', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),

            // Task List
            Expanded(
              child: Consumer<TaskProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (provider.days.isEmpty) {
                    return const Center(
                      child: Text(
                        'No days yet!\nClick "Add New Day" to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.days.length,
                    itemBuilder: (context, index) {
                      final day = provider.days[index];
                      return DayCard(day: day);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}