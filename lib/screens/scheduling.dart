import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calendar_view/calendar_view.dart';
import '../models/session.dart';

class SchedulingScreen extends StatefulWidget {
  final List<Session> sessions;
  final Function(Session) onAdd;
  final Function(Session) onUpdate;
  final Function(String) onDelete;

  const SchedulingScreen({
    super.key,
    required this.sessions,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _SchedulingScreenState createState() => _SchedulingScreenState();
}

class _SchedulingScreenState extends State<SchedulingScreen> {
  bool showCalendar = false;

  void _showAddDialog() {
    final titleController = TextEditingController();
    final locationController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay(
      hour: TimeOfDay.now().hour + 1,
      minute: TimeOfDay.now().minute,
    );
    String selectedType = 'Class';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1B2C5C),
          title: const Text(
            'Add Session',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(titleController, 'Session Title'),
                const SizedBox(height: 12),
                _buildDatePicker(context, selectedDate, (date) {
                  setDialogState(() => selectedDate = date);
                }),
                const SizedBox(height: 12),
                _buildTimePicker(context, 'Start Time', startTime, (time) {
                  setDialogState(() => startTime = time);
                }),
                const SizedBox(height: 12),
                _buildTimePicker(context, 'End Time', endTime, (time) {
                  setDialogState(() => endTime = time);
                }),
                const SizedBox(height: 12),
                _buildTextField(locationController, 'Location (Optional)'),
                const SizedBox(height: 12),
                _buildTypeDropdown(selectedType, (value) {
                  setDialogState(() => selectedType = value!);
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  widget.onAdd(
                    Session(
                      id: DateTime.now().toString(),
                      title: titleController.text,
                      date: DateFormat('MMM dd, yyyy').format(selectedDate),
                      startTime: startTime.format(context),
                      endTime: endTime.format(context),
                      location: locationController.text,
                      sessionType: selectedType,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Session session) {
    final titleController = TextEditingController(text: session.title);
    final locationController = TextEditingController(text: session.location);
    DateTime selectedDate = DateFormat('MMM dd, yyyy').parse(session.date);
    TimeOfDay startTime = _parseTime(session.startTime);
    TimeOfDay endTime = _parseTime(session.endTime);
    String selectedType = session.sessionType;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1B2C5C),
          title: const Text(
            'Edit Session',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(titleController, 'Session Title'),
                const SizedBox(height: 12),
                _buildDatePicker(context, selectedDate, (date) {
                  setDialogState(() => selectedDate = date);
                }),
                const SizedBox(height: 12),
                _buildTimePicker(context, 'Start Time', startTime, (time) {
                  setDialogState(() => startTime = time);
                }),
                const SizedBox(height: 12),
                _buildTimePicker(context, 'End Time', endTime, (time) {
                  setDialogState(() => endTime = time);
                }),
                const SizedBox(height: 12),
                _buildTextField(locationController, 'Location (Optional)'),
                const SizedBox(height: 12),
                _buildTypeDropdown(selectedType, (value) {
                  setDialogState(() => selectedType = value!);
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onUpdate(
                  Session(
                    id: session.id,
                    title: titleController.text,
                    date: DateFormat('MMM dd, yyyy').format(selectedDate),
                    startTime: startTime.format(context),
                    endTime: endTime.format(context),
                    location: locationController.text,
                    sessionType: selectedType,
                    isPresent: session.isPresent,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB800),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(' ');
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    if (parts[1] == 'PM' && hour != 12) hour += 12;
    if (parts[1] == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  List<CalendarEventData> _getCalendarEvents() {
    return widget.sessions.map((session) {
      DateTime date = DateFormat('MMM dd, yyyy').parse(session.date);
      TimeOfDay start = _parseTime(session.startTime);
      TimeOfDay end = _parseTime(session.endTime);

      return CalendarEventData(
        title: session.title,
        date: date,
        startTime: DateTime(
          date.year,
          date.month,
          date.day,
          start.hour,
          start.minute,
        ),
        endTime: DateTime(
          date.year,
          date.month,
          date.day,
          end.hour,
          end.minute,
        ),
        description: '${session.sessionType} - ${session.location}',
        color: const Color(0xFFFFB800),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2C5C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2C5C),
        elevation: 0,
        title: const Text('Schedule', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              showCalendar ? Icons.list : Icons.calendar_month,
              color: Colors.white,
            ),
            onPressed: () => setState(() => showCalendar = !showCalendar),
          ),
        ],
      ),
      body: showCalendar ? _buildCalendarView() : _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFFFFB800),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarView() {
    return CalendarControllerProvider(
      controller: EventController()..addAll(_getCalendarEvents()),
      child: WeekView(
        backgroundColor: const Color(0xFF1B2C5C),
        headerStyle: const HeaderStyle(
          headerTextStyle: TextStyle(color: Colors.white, fontSize: 18),
          decoration: BoxDecoration(color: Color(0xFF1B2C5C)),
        ),
        timeLineBuilder: (date) => Container(
          padding: const EdgeInsets.all(4),
          child: Text(
            DateFormat('ha').format(date),
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
        weekDayBuilder: (day) => Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(border: Border.all(color: Colors.white24)),
          child: Text(
            DateFormat('EEE\nd').format(day),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                events[0].title,
                style: const TextStyle(color: Colors.white, fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    if (widget.sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 80,
              color: Colors.white.withAlpha(77),
            ),
            const SizedBox(height: 16),
            Text(
              'No sessions yet',
              style: TextStyle(
                color: Colors.white.withAlpha(128),
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.sessions.length,
      itemBuilder: (context, index) =>
          _buildSessionCard(widget.sessions[index]),
    );
  }

  Widget _buildSessionCard(Session session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${session.startTime} - ${session.endTime}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      session.date,
                      style: const TextStyle(
                        color: Color(0xFFFFB800),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB800),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  session.sessionType,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          if (session.location.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  session.location,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: session.isPresent,
                      onChanged: (value) {
                        session.isPresent = value!;
                        widget.onUpdate(session);
                      },
                      activeColor: const Color(0xFF4CAF50),
                    ),
                    const Text(
                      'Present',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white70),
                onPressed: () => _showEditDialog(session),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => widget.onDelete(session.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withAlpha(26),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    DateTime selectedDate,
    Function(DateTime) onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime(2030),
        );
        if (date != null) onDateSelected(date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(Icons.calendar_today, color: Color(0xFFFFB800)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    String label,
    TimeOfDay time,
    Function(TimeOfDay) onTimeSelected,
  ) {
    return InkWell(
      onTap: () async {
        final selected = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (selected != null) onTimeSelected(selected);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: ${time.format(context)}',
              style: const TextStyle(color: Colors.white),
            ),
            const Icon(Icons.access_time, color: Color(0xFFFFB800)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeDropdown(String selectedType, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedType,
      dropdownColor: const Color(0xFF1B2C5C),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Session Type',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withAlpha(26),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: ['Class', 'Mastery Session', 'Study Group', 'PSL Meeting']
          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
