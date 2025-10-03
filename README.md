📋 Flutter Task Manager
A sleek, offline-first task management application built with Flutter. Designed with a clean, dark-mode interface, this app helps you organize your daily tasks efficiently. It supports local data persistence and allows you to import your task schedule directly from an Excel file.

✨ Features
Clean Dark-Mode UI: Aesthetically pleasing and easy on the eyes.

Day-by-Day Task Organization: Add separate task lists for each day.

Full Task Control: Add, delete, and mark tasks as complete.

Local Data Persistence: Your tasks are saved locally on your device using shared_preferences, ensuring your data is always available, even offline.

Import from Excel: Quickly populate your schedule by importing tasks from a .xlsx file.

📸 Screenshots
Main Screen

Add Task Dialog





📥 Import Tasks from Excel
This feature allows you to bulk-add days and tasks from a standard .xlsx Excel file.

Excel File Structure
To import successfully, your Excel file must be structured correctly. The importer will read the first sheet of your workbook, which should have the following columns in order:

Column A

Column B

Column C

Date

DayNumber

Tasks

2025-10-23

1

Plan project, First meeting, Draft outline

2025-10-24

2

Develop feature A, Test feature A

2025-10-25

3

Design UI mockups, Get feedback

Formatting Rules:

The first row must be a header row (it will be skipped).

Date (Column A): Must be in YYYY-MM-DD format.

DayNumber (Column B): A simple number representing the day's order.

Tasks (Column C): A single cell containing all tasks for that day, separated by a comma (,).

🚀 Getting Started
Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

Prerequisites
You need to have the Flutter SDK installed on your machine. For instructions, see the official Flutter documentation.

Installation & Running
Clone the repository:

git clone [https://github.com/your-username/flutter-task-manager.git](https://github.com/your-username/flutter-task-manager.git)
cd flutter-task-manager

Install dependencies:

flutter pub get

Run the app:

flutter run

📦 Key Packages Used
provider: For state management.

shared_preferences: For simple local data persistence.

file_picker: To allow users to select files from their device storage.

excel: For parsing data from .xlsx files.

intl: For date formatting.

uuid: For generating unique IDs for tasks and days.

📂 Project Structure
The project follows a standard Flutter structure to keep the codebase organized and maintainable.

lib/
├── models/
│   ├── day_model.dart
│   └── task_model.dart
├── providers/
│   └── task_provider.dart
├── screens/
│   └── home_screen.dart
├── widgets/
│   ├── day_card.dart
│   └── task_chip.dart
└── main.dart

🤝 Contributing
Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)

Commit your Changes (git commit -m 'Add some AmazingFeature')

Push to the Branch (git push origin feature/AmazingFeature)

Open a Pull Request

📜 License
Distributed under the MIT License. See LICENSE for more information.
