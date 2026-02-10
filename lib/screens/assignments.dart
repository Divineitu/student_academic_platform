import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';

class AssignmentsScreen extends StatefulWidget {
  final List<Assignment> assignments;
  final Function(Assignment) onAdd;
  final Function(Assignment) onUpdate;
  final Function(String) onDelete;

  const AssignmentsScreen({
    super.key,
    required this.assignments,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  // Show dialog to add new assignment
  void _showAddDialog() {
    final titleController = TextEditingController();
    final courseController = TextEditingController();
    String selectedPriority = 'Medium';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1B2C5C),
          title: const Text('Add Assignment', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(titleController, 'Assignment Title'),
                const SizedBox(height: 12),
                _buildDialogTextField(courseController, 'Course Name'),
                const SizedBox(height: 12),
                _buildDatePicker(context, selectedDate, (date) {
                  setDialogState(() => selectedDate = date);
                }),
                const SizedBox(height: 12),
                _buildPriorityDropdown(selectedPriority, (value) {
                  setDialogState(() => selectedPriority = value!);
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && courseController.text.isNotEmpty) {
                  widget.onAdd(Assignment(
                    id: DateTime.now().toString(),
                    title: titleController.text,
                    course: courseController.text,
                    dueDate: DateFormat('MMM dd, yyyy').format(selectedDate),
                    priority: selectedPriority,
                  ));
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800)),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog to edit existing assignment
  void _showEditDialog(Assignment assignment) {
    final titleController = TextEditingController(text: assignment.title);
    final courseController = TextEditingController(text: assignment.course);
    String selectedPriority = assignment.priority;
    DateTime selectedDate = DateFormat('MMM dd, yyyy').parse(assignment.dueDate);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1B2C5C),
          title: const Text('Edit Assignment', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(titleController, 'Assignment Title'),
                const SizedBox(height: 12),
                _buildDialogTextField(courseController, 'Course Name'),
                const SizedBox(height: 12),
                _buildDatePicker(context, selectedDate, (date) {
                  setDialogState(() => selectedDate = date);
                }),
                const SizedBox(height: 12),
                _buildPriorityDropdown(selectedPriority, (value) {
                  setDialogState(() => selectedPriority = value!);
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onUpdate(Assignment(
                  id: assignment.id,
                  title: titleController.text,
                  course: courseController.text,
                  dueDate: DateFormat('MMM dd, yyyy').format(selectedDate),
                  priority: selectedPriority,
                  isCompleted: assignment.isCompleted,
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB800)),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort assignments by due date
    List<Assignment> sortedAssignments = List.from(widget.assignments)
      ..sort((a, b) => DateFormat('MMM dd, yyyy').parse(a.dueDate).compareTo(
            DateFormat('MMM dd, yyyy').parse(b.dueDate)));

    return Scaffold(
      backgroundColor: const Color(0xFF1B2C5C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B2C5C),
        elevation: 0,
        title: const Text('Assignments', style: TextStyle(color: Colors.white)),
      ),
      body: widget.assignments.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedAssignments.length,
              itemBuilder: (context, index) => _buildAssignmentCard(sortedAssignments[index]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFFFFB800),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment, size: 80, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No assignments yet',
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    // Set priority color based on assignment priority
    Color priorityColor = assignment.priority == 'High'
        ? const Color(0xFFD32F2F)
        : assignment.priority == 'Medium'
            ? const Color(0xFFFFA000)
            : const Color(0xFF4CAF50);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Checkbox(
            value: assignment.isCompleted,
            onChanged: (value) {
              assignment.isCompleted = value!;
              widget.onUpdate(assignment);
            },
            activeColor: const Color(0xFFFFB800),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: assignment.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(assignment.course, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text(assignment.dueDate, style: const TextStyle(color: Color(0xFFFFB800), fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: priorityColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(assignment.priority, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white70),
            onPressed: () => _showEditDialog(assignment),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => widget.onDelete(assignment.id),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, DateTime selectedDate, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (date != null) onDateSelected(date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Due Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                style: const TextStyle(color: Colors.white)),
            const Icon(Icons.calendar_today, color: Color(0xFFFFB800)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown(String selectedPriority, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedPriority,
      dropdownColor: const Color(0xFF1B2C5C),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Priority',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: ['High', 'Medium', 'Low']
          .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
