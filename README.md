# ALU Academic Assistant 📚

A comprehensive Flutter-based mobile application designed specifically for African Leadership University (ALU) students to manage their academic responsibilities while balancing university life. This app serves as a personal academic assistant helping students organize coursework, track schedules, and monitor academic engagement throughout the term.

## 👥 Team Members

- **Divine Okon Itu**
- **Jongkuch Isaac Chol Anyar**
- **Julie Isaro**
- **Mahlet Assefa Tilahun**
- **Rwema Gisa**

## 🎯 Project Overview

At African Leadership University, we identify challenges and create innovative solutions. This project addresses a common issue among ALU students: managing academic responsibilities effectively.

Students across all years struggle with:
- Tracking assignments and deadlines
- Remembering class schedules
- Monitoring their attendance
- Balancing academic stress

**Our Solution**: A mobile application that serves as a personal academic assistant, helping users:
- Organize their coursework efficiently
- Track their academic schedule
- Monitor attendance with real-time alerts
- Stay on top of assignments and deadlines
- Maintain academic engagement throughout the term

## ✨ Core Application Features

### 1. Home Dashboard
The dashboard displays all essential academic information at a glance:

**Required Display Elements:**
- ✅ Today's date and current academic week number
- ✅ List of today's scheduled academic sessions
- ✅ Assignments due within the next seven days
- ✅ Current overall attendance percentage
- ✅ Visual warning indicator when attendance falls below 75%
- ✅ Summary count of pending assignments

**Implementation Highlights:**
- Real-time date tracking with week calculation
- Smart filtering for upcoming assignments (7-day window)
- Color-coded attendance stats (Green ≥75%, Red <75%)
- At-risk alert system with prominent visual warnings
- Quick access to profile via AppBar navigation

### 2. Assignment Management System

**Create New Assignments:**
- ✅ Assignment title (required text field)
- ✅ Due date (calendar date picker)
- ✅ Course name (text input)
- ✅ Priority level (High/Medium/Low dropdown)

**Assignment Operations:**
- ✅ View all assignments sorted by due date
- ✅ Mark assignments as completed with checkbox
- ✅ Remove assignments from the list
- ✅ Edit assignment details with pre-filled forms

**Visual Features:**
- Priority-based color coding (High: Red, Medium: Orange, Low: Green)
- Completion status with visual feedback
- Filter options: All, Pending, Completed
- Clean, organized card-based layout

### 3. Academic Session Scheduling

**Create New Sessions:**
- ✅ Session title (required text field)
- ✅ Date (calendar date picker)
- ✅ Start time (time picker)
- ✅ End time (time picker)
- ✅ Location (optional text field)
- ✅ Session type selector: Class, Mastery Session, Study Group, PSL Meeting

**Schedule Management:**
- ✅ View weekly schedule with all sessions
- ✅ Toggle between List View and Calendar Week View
- ✅ Record attendance (Present/Absent toggle via checkbox)
- ✅ Remove scheduled sessions
- ✅ Modify session details

**Advanced Features:**
- Calendar integration using `calendar_view` package
- Intelligent 12-hour time format parsing (AM/PM)
- Visual calendar display with color-coded events
- Location tracking for each session

### 4. Attendance Tracking

**Automatic Calculations:**
- ✅ Real-time attendance percentage calculation
- ✅ Based on Present/Absent records for all sessions
- ✅ Clear display on dashboard with visual indicators

**Alert System:**
- ✅ Automatic alerts when attendance drops below 75%
- ✅ Prominent red warning card on dashboard
- ✅ "AT RISK" status notification
- ✅ Attendance history maintained for reference

### 5. Navigation Structure

**Bottom Navigation Bar** with three primary tabs:
- 📊 **Dashboard** - Main overview screen
- 📝 **Assignments** - Assignment management interface
- 📅 **Schedule** - Session planning and calendar view

**Additional Navigation:**
- Profile screen accessible from Dashboard AppBar
- Smooth transitions with state preservation
- Consistent navigation patterns throughout

## 🏗️ Architecture & Design Patterns

### Project Structure
```
student_academic_platform/
├── lib/
│   ├── main.dart                    # App entry point & initialization
│   ├── models/
│   │   ├── assignment.dart          # Assignment data model
│   │   └── session.dart             # Session data model
│   ├── screens/
│   │   ├── dashboard.dart           # Dashboard screen (StatelessWidget)
│   │   ├── assignments.dart         # Assignment management (StatefulWidget)
│   │   ├── scheduling.dart          # Session scheduling (StatefulWidget)
│   │   ├── navigation.dart          # Bottom navigation controller
│   │   ├── profile.dart             # User profile & statistics
│   │   └── login.dart               # Authentication screen
│   ├── services/
│   │   ├── attendance_service.dart  # Attendance calculation logic
│   │   ├── data_service.dart        # Data management & persistence
│   │   └── validation_service.dart  # Input validation utilities
│   └── widgets/
│       ├── custom_button.dart       # Reusable button component
│       ├── custom_text_field.dart   # Reusable text input field
│       └── stats_card.dart          # Statistics display card
├── android/                         # Android-specific files
├── ios/                             # iOS-specific files
├── web/                             # Web platform files
├── pubspec.yaml                     # Dependencies & configuration
└── README.md                        # Project documentation
```

### Design Principles Applied

1. **Separation of Concerns**
   - Business logic separated in service classes
   - UI components isolated in widgets
   - Data models defined independently

2. **Widget Composition**
   - Reusable custom widgets (StatsCard, CustomButton, CustomTextField)
   - Method extraction for complex widget trees
   - Single Responsibility Principle for each widget method

3. **State Management**
   - StatefulWidget for screens requiring local state (Scheduling, Assignments)
   - StatelessWidget for presentation-only components (Dashboard)
   - Callback pattern for parent-child communication

4. **Data Flow**
   - Unidirectional data flow from parent to child
   - Callback functions for child-to-parent updates
   - Navigation widget as central state manager

## 🛠️ Technical Implementation

### Key Technologies
- **Flutter SDK**: ^3.10.0
- **Dart Language**: Modern null-safe Dart
- **Packages**:
  - `intl: ^0.18.0` - Date/time formatting and internationalization
  - `calendar_view: ^1.0.4` - Calendar visualization component
  - `cupertino_icons: ^1.0.8` - iOS-style icons

### Notable Code Features

#### 1. Smart Date Handling
```dart
// Intelligent time parsing from 12-hour format
TimeOfDay _parseTime(String timeStr) {
  final parts = timeStr.split(' ');
  final timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);
  if (parts[1] == 'PM' && hour != 12) hour += 12;
  if (parts[1] == 'AM' && hour == 12) hour = 0;
  return TimeOfDay(hour: hour, minute: minute);
}
```

#### 2. Attendance Risk Detection
```dart
// Automatic at-risk calculation
static bool isAttendanceAtRisk(List<Session> sessions) {
  double attendance = calculateAttendance(sessions);
  return attendance < 75.0;
}
```

**Why This Matters**: Separates business logic from UI, making it reusable and testable.

#### 3. Dynamic UI Color Coding (dashboard.dart)
**Implementation**: UI elements change color based on attendance status

```dart
// Color-coded stats cards based on attendance threshold
StatsCard(
  value: '${attendance.toInt()}%',
  label: 'Attendance',
  backgroundColor: attendance >= 75 
    ? const Color(0xFF4CAF50)  // Green when safe
    : const Color(0xFFD32F2F), // Red when at risk
)
```

**Visual Feedback**: Students immediately see their status through color coding.

#### 4. State Management via Navigation Widget (navigation.dart)
**Implementation**: Central state manager using callback pattern

```dart
class _NavigationScreenState extends State<NavigationScreen> {
  List<Assignment> assignments = [];
  List<Session> sessions = [];

  void updateSession(Session session) {
    setState(() {
      int index = sessions.indexWhere((s) => s.id == session.id);
      if (index != -1) sessions[index] = session;
    });
  }

  // Passes data down, callbacks up
  final screens = [
    SchedulingScreen(
      sessions: sessions,
      onAdd: addSession,
      onUpdate: updateSession,
      onDelete: deleteSession,
    ),
  ];
}
```

**Why This Matters**: Implements unidirectional data flow.

## 🎨 UI/UX Design

### ALU Official Color Palette
Our app strictly follows ALU's official branding guidelines:

- **Primary Dark**: `#1B2C5C` (ALU Navy Blue)
- **Accent/Highlight**: `#FFB800` (ALU Golden Yellow)
- **Success**: `#4CAF50` (Green - Good attendance, completed tasks)
- **Warning**: `#FFA000` (Orange - Medium priority)
- **Danger/Alert**: `#D32F2F` (Red - At-risk attendance, high priority)
- **Text**: White/White70 on dark backgrounds for optimal contrast

### User Interface Standards

✅ **ALU Branding Compliance**
- Consistent use of ALU colors throughout the app
- Professional, academic-focused design
- University-appropriate aesthetics

✅ **Clear Form Labeling**
- All input fields have descriptive labels
- Validation messages are clear and helpful
- Required fields are marked appropriately

✅ **Responsive Mobile Design**
- No pixel overflow errors
- Layouts adapt to different screen sizes
- Proper use of Expanded and Flexible widgets
- Tested on multiple device sizes

✅ **Input Validation**
- Date/time fields use proper pickers
- Required fields validated before submission
- Error feedback for invalid inputs
- User-friendly error messages

✅ **Consistent Navigation Patterns**
- Bottom navigation bar always accessible
- Back navigation works as expected
- Modal dialogs with clear Cancel/Confirm actions
- Floating action buttons for primary actions

### Design Philosophy
- **Professional**: University-appropriate interface design
- **Intuitive**: Familiar mobile UI patterns
- **Accessible**: High contrast for readability
- **Efficient**: Quick access to key features
- **Consistent**: Unified design language throughout
### Design Philosophy
- **Flutter SDK**: 3.10.0 or higher
- **Dart SDK**: (included with Flutter)
- **IDE**: Android Studio or VS Code with Flutter extensions
- **Device**: Android Emulator, iOS Simulator (macOS), or Physical Device

⚠️ **Important**: This app must run on a mobile emulator or physical device. Browser-based execution is not supported per assignment requirements.

### Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Divineitu/student_academic_platform.git
   cd student_academic_platform
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Fix any issues reported before proceeding.

4. **List available devices**
   ```bash
   flutter devices
   ```
   Ensure at least one mobile device (emulator or physical) is connected.

5. **Run the application**
   ```bash
   # Run on default device
   flutter run
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Run in debug mode with hot reload
   flutter run --debug
   ```

6. **Build for production** (Optional)
   ```bash
   # Android APK
   flutter build apk --release
   
   # iOS (macOS only)
   flutter build ios --release
   ```

### Troubleshooting

**Common Issues:**

- **"No devices found"**: Start an emulator or connect a physical device
- **Gradle errors**: Run `cd android && ./gradlew clean` then return to root
- **Dependency conflicts**: Run `flutter pub cache clean` then `flutter pub get`
- **Build errors**: Run `flutter clean` then rebuilderequisites
- Flutter SDK 3.10.0 or higher
- Dart SDK (comes with Flutter)
- Android Studio / VS Code with Flutter extensions
- iOS Simulator (for macOS) or Android Emulator

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd final_student_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   #� Data Management & Persistence

### Current Implementation
**Session-Based Storage**: Data is maintained during the current app session using in-memory state management through the Navigation widget.

**Data Flow:**
1. User inputs are validated in screen widgets
2. Callback functions propagate changes to parent Navigation widget
3. Navigation widget maintains the app's state
4. Updated data flows back down to child screens

**Why This Approach:**
- Simplified implementation focused on core functionality
- Faster development and testing cycles
- No external dependencies for basic operation
- Meets assignment requirements for basic data management

### Challenges Encountered & Solutions

**1. State Management Across Multiple Screens**

**The Challenge**:
Initially, each screen (Dashboard, Assignments, Schedule) maintained its own data, causing synchronization issues. When marking attendance in Schedule, Dashboard wouldn't update.

**The Solution**:
```dart
// Lifted state to NavigationScreen (parent widget)
class _NavigationScreenState extends State<NavigationScreen> {
  List<Assignment> assignments = [];
  List<Session> sessions = [];
  
  // Child widgets receive data and callbacks
  DashboardScreen(
    assignments: assignments,
    sessions: sessions,
  ),
  SchedulingScreen(
    sessions: sessions,
    onUpdate: updateSession,  // Callback to update parent state
  ),
}
```

**What We Learned**: "Lifting state up" to the nearest common ancestor ensures single source of truth. Data flows down, events flow up through callbacks.

---

**2. 12-Hour Time Format Parsing**

**The Challenge**:
Flutter's `TimeOfDay.format(context)` returns "9:00 AM", but we needed to parse it back for editing sessions. Edge cases like "12:00 AM" (midnight) and "12:00 PM" (noon) caused bugs.

**The Solution**:
```dart
TimeOfDay _parseTime(String timeStr) {
  final parts = timeStr.split(' ');      // ["12:00", "PM"]
  final timeParts = parts[0].split(':'); // ["12", "00"]
  int hour = int.parse(timeParts[0]);
  
  // Critical edge case handling
  if (parts[1] == 'PM' && hour != 12) hour += 12;  // 1 PM = 13:00
  if (parts[1] == 'AM' && hour == 12) hour = 0;    // 12 AM = 00:00
  
  return TimeOfDay(hour: hour, minute: int.parse(timeParts[1]));
}
```

**Debugging Process**: Used print statements to test all edge cases (1 AM, 12 AM, 1 PM, 12 PM). Discovered 12 AM was being interpreted as 12:00 instead of 00:00.

**What We Learned**: Time handling requires careful edge case testing. Always test boundary conditions.

---

**3. Calendar View Integration**

**The Challenge**:
The `calendar_view` package expects `CalendarEventData` objects, but we had custom `Session` objects. The package documentation was limited.

**The Solution**:
```dart
List<CalendarEventData> _getCalendarEvents() {
  return widget.sessions.map((session) {
    DateTime date = DateFormat('MMM dd, yyyy').parse(session.date);
    TimeOfDay start = _parseTime(session.startTime);
    TimeOfDay end = _parseTime(session.endTime);

    return CalendarEventData(
      title: session.title,
      date: date,
      startTime: DateTime(date.year, date.month, date.day, start.hour, start.minute),
      endTime: DateTime(date.year, date.month, date.day, end.hour, end.minute),
      color: const Color(0xFFFFB800),  // ALU gold color
    );
  }).toList();
}
```

**Debugging Process**: Read package source code on GitHub when docs were unclear. Used trial-and-error to understand required DateTime format.

**What We Learned**: When documentation is insufficient, reading package source code helps. Creating adapter/mapper functions bridges incompatible data structures.

---

**4. Real-Time Attendance Updates**

**The Challenge**:
When users checked "Present" on a session, the Dashboard's attendance percentage wasn't updating immediately.

**The Solution**:
```dart
// In SchedulingScreen - checkbox triggers callback
Checkbox(
  value: session.isPresent,
  onChanged: (value) {
    session.isPresent = value!;
    widget.onUpdate(session);  // Notifies parent
  },
)

// In NavigationScreen - setState triggers rebuild
void updateSession(Session session) {
  setState(() {  // This rebuilds all child widgets
    int index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) sessions[index] = session;
  });
}

// Dashboard recalculates automatically on rebuild
double attendance = AttendanceService.calculateAttendance(sessions);
```

**What We Learned**: Understanding Flutter's widget tree and rebuild mechanism is crucial. `setState()` in parent causes children to rebuild with new data.

---

**5. Pixel Overflow Errors**

**The Challenge**:
Dialog forms with multiple inputs were causing "RenderFlex overflowed by X pixels" errors on smaller screens.

**The Solution**:
```dart
AlertDialog(
  content: SingleChildScrollView(  // Makes content scrollable
    child: Column(
      mainAxisSize: MainAxisSize.min,  // Takes minimum space
      children: [
        _buildTextField(titleController, 'Session Title'),
        const SizedBox(height: 12),
        _buildDatePicker(context, selectedDate, onDateSelected),
        // More form fields...
      ],
    ),
  ),
)
```

**What We Learned**: Always wrap potentially large content in `SingleChildScrollView`. Use `mainAxisSize: MainAxisSize.min` for columns inside dialogs.

---

### Key Technical Learnings

1. **State Management**: Understanding when to use StatefulWidget vs StatelessWidget, and how to lift state to parent components for shared data.

2. **Widget Lifecycle**: How `initState()`, `setState()`, and `build()` work together. When `setState()` is called, all child widgets receive updated data.

3. **Callback Pattern**: Passing functions as parameters (`onAdd`, `onUpdate`, `onDelete`) enables child-to-parent communication without tight coupling.

4. **Date/Time Handling**: The `intl` package's `DateFormat` class is essential for parsing and formatting dates consistently.

5. **Package Integration**: Reading package source code on GitHub helped when official documentation was insufficient (calendar_view package).

6. **Separation of Concerns**: 
   - Models: Data structure only
   - Services: Business logic (calculations, validations)
   - Widgets: Reusable UI components
   - Screens: Composition of widgets

7. **Debugging Techniques**:
   - Print statements for data flow tracking
   - Flutter DevTools for widget inspection
   - Hot reload for rapid iteration

8. **UI Best Practices**:
   - Always use `SingleChildScrollView` for potentially long content
   - `Expanded` for flexible layouts
   - `const` constructors for performance optimization
   - Color consistency through centralized color definitions

## 📄 Academic Integrity Statement

**Original Work Declaration:**
This project represents our team's original work and genuine understanding of Flutter development. We have:
- Written all code ourselves with proper understanding
- Used AI tools only for learning and debugging assistance (not code generation)
- Ensured less than 50% AI assistance in total codebase
- Can explain every line of code we've submitted
- Demonstrated our understanding in the demo video

## 👨‍💻 Development Team

**ALU Academic Assistant Team**
- **Institution**: African Leadership University
- **Course**: Mobile Application Development
- **Term**: January 2026
- **Assignment**: Formative Assignment 1

## 🙏 Acknowledgments

- **African Leadership University** - For the educational opportunity
- **Flutter Team** - For the excellent mobile framework
- **calendar_view package** - Calendar visualization component
- **intl package** - Internationalization and date/time formatting
- **Material Design** - UI/UX design guidelines
- **Our Instructors** - For guidance and support

## 📞 Contact & Support

**Repository**: [student_academic_platform](https://github.com/Divineitu/student_academic_platform)

**For Issues:**
1. Check documentation and code comments
2. Review existing GitHub issues
3. Contact team members via repository

---

## 📊 Project Status

**Version**: 1.0.0  
**Last Updated**: February 10, 2026  
**Flutter Version**: 3.10.0  
**Platform**: Android & iOS  
**Status**: Completed for Assignment Submission

---

## ⚡ Quick Start Commands

```bash
# Clone repository
git clone https://github.com/Divineitu/student_academic_platform.git

# Navigate to project
cd student_academic_platform

# Install dependencies
flutter pub get

# Check Flutter setup
flutter doctor

# Run app (ensure device/emulator is connected)
flutter run

# Build release APK
flutter build apk --release

# Clean build files
flutter clean
```

---

**Made with ❤️ by ALU Students for ALU Students**
## 🐛 Known Limitations

**Current Limitations:**
- Data resets on app restart (session-based storage)
- No user authentication system
- Single user environment
- Calendar shows week view only
- Local time zone only (no timezone conversion)
- No conflict detec
### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 📊 Data Models

### Session Model
**File**: `lib/models/session.dart`

```dart
class Session {
  String id;
  String title;
  String date;              // Format: 'MMM dd, yyyy' (e.g., 'Feb 10, 2026')
  String startTime;         // Format: '9:00 AM'
  String endTime;           // Format: '11:00 AM'
  String location;          // Optional: Room number or location
  String sessionType;       // Class, Mastery Session, Study Group, PSL Meeting
  bool isPresent;           // Attendance tracking

  Session({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.location = '',     // Defaults to empty string
    required this.sessionType,
    this.isPresent = false, // Defaults to absent
  });
}
```

### Assignment Model
**File**: `lib/models/assignment.dart`

```dart
class Assignment {
  String id;
  String title;
  String course;
  String dueDate;           // Format: 'MMM dd, yyyy'
  String priority;          // High, Medium, or Low
  bool isCompleted;         // Completion status

  Assignment({
    required this.id,
    required this.title,
    required this.course,
    required this.dueDate,
    this.priority = 'Medium', // Defaults to Medium
    this.isCompleted = false, // Defaults to incomplete
  });
}
```

## 🚀 Future Enhancements

- [ ] Backend integration with Firebase/Supabase
- [ ] User authentication and multi-user support
- [ ] Push notifications for upcoming deadlines
- [ ] Grade tracking and GPA calculation
- [ ] Export data to PDF/CSV
- [ ] Dark/Light theme toggle
- [ ] Offline data persistence with local database
- [ ] Study timer and Pomodoro technique integration
- [ ] Integration with university LMS systems
- [ ] Assignment file attachments
- [ ] Collaborative study groups feature

## 🐛 Known Issues & Limitations

- Data is currently stored in memory (resets on app restart)
- No user authentication system
- Calendar view shows week view only (no month/day views)
- Time zone handling assumes local time
- No data validation for overlapping sessions

## 📄 License

This project is created for educational purposes.

## 👨‍💻 Developer

**Student Management App**
- Built with Flutter & Dart
- Designed for academic tracking and productivity

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **calendar_view package** - Calendar visualization
- **intl package** - Date/time formatting
- **Material Design** - UI/UX guidelines

## 📞 Support

For questions or issues:
1. Check existing documentation
2. Review code comments
3. Contact the development team

---

**Version**: 1.0.0  
**Last Updated**: February 2026  
**Flutter Version**: 3.10.0  

---

### Quick Start Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk

# Clean build
flutter clean
```
