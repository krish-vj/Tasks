import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_cascade_manager/providers/task_provider.dart';
import 'package:task_cascade_manager/widgets/day_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Method to show the dialog for adding multiple days
  void _showAddDaysDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final provider = Provider.of<TaskProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Days'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Only allow numbers
          decoration: const InputDecoration(
            hintText: 'How many days?',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              final int? count = int.tryParse(controller.text.trim());
              if (count != null && count > 0) {
                provider.addMultipleDays(count);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Text('Add', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TaskProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            
            // Special layout for when the list of days is empty
            if (provider.days.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No days yet!\nClick "Add New Day(s)" to get started.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    _buildAddDayButton(context),
                  ],
                ),
              );
            }

            // Main list view with the button at the very end
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80), // Add padding to the bottom
              itemCount: provider.days.length + 1, // +1 for the button
              itemBuilder: (context, index) {
                if (index < provider.days.length) {
                  // Render a DayCard for each day
                  final day = provider.days[index];
                  return DayCard(day: day);
                } else {
                  // Render the button as the last item in the list
                  return _buildAddDayButton(context);
                }
              },
            );
          },
        ),
      ),
    );
  }

  // Helper widget for the button to avoid code duplication
  Widget _buildAddDayButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () => _showAddDaysDialog(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Add New Day(s)', style: TextStyle(color: Colors.white)),
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
    );
  }
}
