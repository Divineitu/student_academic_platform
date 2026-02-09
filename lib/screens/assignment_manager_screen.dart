import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment.dart';

class AssignmentManagerScreen extends StatefulWidget {
  const AssignmentManagerScreen({super.key});

  @override
  State<AssignmentManagerScreen> createState() => _AssignmentManagerScreenState();
}

class _AssignmentManagerScreenState extends State<AssignmentManagerScreen> {
  // In-memory list of assignments
  final List<Assignment> _assignments = [];

  // Brand Colors
  final Color _aluNavy = const Color(0xFF003366);
  final Color _aluGold = const Color(0xFFFFCC00);

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback because context might not be available immediately
    // or to simulate loading initial data if needed.
  }

  void _addOrUpdateAssignment(Assignment assignment) {
    setState(() {
      int index = _assignments.indexWhere((a) => a.id == assignment.id);
      if (index != -1) {
        _assignments[index] = assignment;
      } else {
        _assignments.add(assignment);
      }
      _sortAssignments();
    });
  }

  void _deleteAssignment(String id) {
    setState(() {
      _assignments.removeWhere((a) => a.id == id);
    });
  }

  void _toggleCompletion(Assignment assignment) {
    _addOrUpdateAssignment(assignment.copyWith(isCompleted: !assignment.isCompleted));
  }

  void _sortAssignments() {
    _assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void _showAssignmentModal({Assignment? assignment}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _AssignmentForm(
          assignment: assignment,
          onSave: (savedAssignment) {
            _addOrUpdateAssignment(savedAssignment);
            Navigator.pop(context);
          },
          aluNavy: _aluNavy,
          aluGold: _aluGold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Separate completed and pending if needed in the future.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: _aluNavy,
        foregroundColor: Colors.white,
      ),
      body: _assignments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
                   const SizedBox(height: 16),
                   Text(
                    'No assignments yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _assignments.length,
              itemBuilder: (context, index) {
                final assignment = _assignments[index];
                return _buildAssignmentTile(assignment);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentModal(),
        backgroundColor: _aluGold,
        foregroundColor: _aluNavy,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssignmentTile(Assignment assignment) {
    // Visual indicators
    Color priorityColor;
    switch (assignment.priority) {
      case AssignmentPriority.high:
        priorityColor = Colors.redAccent;
        break;
      case AssignmentPriority.medium:
        priorityColor = Colors.orangeAccent;
        break;
      case AssignmentPriority.low:
        priorityColor = Colors.green;
        break;
    }

    return Dismissible(
      key: Key(assignment.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Delete Confirmation"),
              content: const Text("Are you sure you want to delete this assignment?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel")),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        _deleteAssignment(assignment.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${assignment.title} deleted')),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: () => _showAssignmentModal(assignment: assignment),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: _aluNavy),
            onPressed: () => _showAssignmentModal(assignment: assignment),
          ),
          leading: Checkbox(
            value: assignment.isCompleted,
            activeColor: _aluNavy,
            onChanged: (bool? value) {
              _toggleCompletion(assignment);
            },
          ),
          title: Text(
            assignment.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: assignment.isCompleted ? TextDecoration.lineThrough : null,
              color: assignment.isCompleted ? Colors.grey : Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              if (assignment.courseName.isNotEmpty)
                Text(
                  assignment.courseName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, y').format(assignment.dueDate),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: priorityColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      assignment.priority.name.toUpperCase(),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignmentForm extends StatefulWidget {
  final Assignment? assignment;
  final Function(Assignment) onSave;
  final Color aluNavy;
  final Color aluGold;

  const _AssignmentForm({
    this.assignment,
    required this.onSave,
    required this.aluNavy,
    required this.aluGold,
  });

  @override
  State<_AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<_AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _courseController;
  late DateTime _selectedDate;
  late AssignmentPriority _priority;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment?.title ?? '');
    _courseController = TextEditingController(text: widget.assignment?.courseName ?? '');
    _selectedDate = widget.assignment?.dueDate ?? DateTime.now().add(const Duration(days: 1));
    _priority = widget.assignment?.priority ?? AssignmentPriority.medium;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.aluNavy,
              onPrimary: Colors.white,
              onSurface: widget.aluNavy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newAssignment = Assignment(
        id: widget.assignment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        courseName: _courseController.text.trim(),
        dueDate: _selectedDate,
        priority: _priority,
        isCompleted: widget.assignment?.isCompleted ?? false,
      );
      widget.onSave(newAssignment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.assignment == null ? 'Add Assignment' : 'Edit Assignment',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.aluNavy,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Assignment Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(
                labelText: 'Course Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<AssignmentPriority>(
                    value: _priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: AssignmentPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(priority.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
             InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  DateFormat('MMM d, y').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.aluNavy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: widget.aluGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
