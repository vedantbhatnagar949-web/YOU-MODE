import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/neo_brutalist_container.dart';
import '../widgets/neo_brutalist_button.dart';
import '../models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks');
    final lastCheckDateStr = prefs.getString('last_task_check_date');
    
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';

    if (tasksJson != null) {
      List<TaskModel> loadedTasks = tasksJson.map((jsonStr) => TaskModel.fromJson(json.decode(jsonStr))).toList();
      
      if (lastCheckDateStr != null && lastCheckDateStr != todayStr) {
        // It's a new day!
        loadedTasks.removeWhere((task) => !task.isDaily);
        for (var task in loadedTasks) {
          if (task.isDaily) {
            task.isCompleted = false;
            task.completionNote = null;
          }
        }
        await prefs.setString('last_task_check_date', todayStr);
        final updatedJson = loadedTasks.map((task) => json.encode(task.toJson())).toList();
        await prefs.setStringList('tasks', updatedJson);
      } else if (lastCheckDateStr == null) {
        await prefs.setString('last_task_check_date', todayStr);
      }
      
      setState(() {
        _tasks = loadedTasks;
      });
    } else {
      await prefs.setString('last_task_check_date', todayStr);
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    String startAmPm = 'AM';
    String endAmPm = 'AM';
    final categoryController = TextEditingController();
    String selectedDifficulty = 'MEDIUM';
    bool isDaily = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.background,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 3),
              ),
              contentPadding: const EdgeInsets.all(24),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('NEW TASK', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Task Title', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: startTimeController,
                            decoration: const InputDecoration(labelText: 'Start Time (e.g. 09:00)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 3)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setDialogState(() => startAmPm = 'AM'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  color: startAmPm == 'AM' ? AppTheme.primary : AppTheme.surface,
                                  child: Text('AM', style: TextStyle(color: startAmPm == 'AM' ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(width: 3, height: 42, color: Colors.black),
                              GestureDetector(
                                onTap: () => setDialogState(() => startAmPm = 'PM'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  color: startAmPm == 'PM' ? AppTheme.primary : AppTheme.surface,
                                  child: Text('PM', style: TextStyle(color: startAmPm == 'PM' ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: endTimeController,
                            decoration: const InputDecoration(labelText: 'End Time (e.g. 10:30)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 3)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setDialogState(() => endAmPm = 'AM'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  color: endAmPm == 'AM' ? AppTheme.primary : AppTheme.surface,
                                  child: Text('AM', style: TextStyle(color: endAmPm == 'AM' ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Container(width: 3, height: 42, color: Colors.black),
                              GestureDetector(
                                onTap: () => setDialogState(() => endAmPm = 'PM'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  color: endAmPm == 'PM' ? AppTheme.primary : AppTheme.surface,
                                  child: Text('PM', style: TextStyle(color: endAmPm == 'PM' ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category/About', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedDifficulty,
                      items: ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']
                          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (val) => setDialogState(() => selectedDifficulty = val!),
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Daily Task?'),
                      value: isDaily,
                      onChanged: (val) => setDialogState(() => isDaily = val!),
                    ),
                    const SizedBox(height: 24),
                    NeoBrutalistButton(
                      onPressed: () {
                        setState(() {
                          _tasks.add(
                            TaskModel(
                              id: DateTime.now().toString(),
                              title: titleController.text,
                              time: '${startTimeController.text} $startAmPm - ${endTimeController.text} $endAmPm',
                              difficulty: selectedDifficulty,
                              category: categoryController.text,
                              isDaily: isDaily,
                            ),
                          );
                        });
                        _saveTasks();
                        Navigator.pop(context);
                      },
                      child: const Center(child: Text('ADD')),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCompleteTaskDialog(TaskModel task) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.background,
          shape: const RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 3),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('COMPLETE TASK', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppTheme.primary)),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Completion Note',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              NeoBrutalistButton(
                backgroundColor: AppTheme.primary,
                onPressed: () {
                  setState(() {
                    task.isCompleted = true;
                    task.completionNote = noteController.text;
                  });
                  _saveTasks();
                  Navigator.pop(context);
                },
                child: const Center(child: Text('MARK DONE')),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getDifficultyColor(String diff) {
    switch (diff) {
      case 'CRITICAL': return const Color(0xFFFF005C);
      case 'HIGH': return const Color(0xFFFFB4AB);
      case 'MEDIUM': return AppTheme.primary;
      case 'LOW': return AppTheme.tertiary;
      default: return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _tasks.where((t) => t.isCompleted).length;
    int totalCount = _tasks.length;
    double efficiency = totalCount == 0 ? 0 : (completedCount / totalCount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'DAILY TASKS',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 24),

          Align(
            alignment: Alignment.centerLeft,
            child: NeoBrutalistButton(
              onPressed: _showAddTaskDialog,
              backgroundColor: AppTheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.black),
                  SizedBox(width: 8),
                  Text('ADD TASK'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          NeoBrutalistContainer(
            backgroundColor: AppTheme.secondary,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'EFFICIENCY',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${(efficiency * 100).toInt()}%',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.black,
                            height: 1.0,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      height: 24,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: efficiency,
                      child: Container(
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text("NO TASKS IN LOG.")),
            ),

          for (var task in _tasks) ...[
            _buildTaskBlock(context, task),
            const SizedBox(height: 24),
          ]
        ],
      ),
    );
  }

  Widget _buildTaskBlock(BuildContext context, TaskModel task) {
    Color bg = _getDifficultyColor(task.difficulty);
    if (task.isCompleted) bg = AppTheme.surface; // Dim completed tasks

    return Opacity(
      opacity: task.isCompleted ? 0.6 : 1.0,
      child: NeoBrutalistContainer(
        backgroundColor: bg,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 16,
                        height: 48,
                        color: task.isCompleted ? Colors.grey : Colors.white,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              task.isCompleted = !task.isCompleted;
                              if (!task.isCompleted) {
                                task.completionNote = null;
                              }
                            });
                            _saveTasks();
                          },
                          child: Text(
                            task.title.toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: task.isCompleted ? Colors.white : Colors.black,
                                  height: 1.0,
                                  decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: task.isCompleted ? Colors.grey : Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text(
                    task.difficulty,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  task.time,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: task.isCompleted ? Colors.white : Colors.black,
                      ),
                ),
                const SizedBox(width: 24),
                Icon(task.isDaily ? Icons.loop : Icons.circle, size: 16, color: Colors.black),
                const SizedBox(width: 8),
                Text(
                  task.category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: task.isCompleted ? Colors.white : Colors.black,
                      ),
                ),
              ],
            ),
            if (task.isCompleted && task.completionNote != null && task.completionNote!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black.withOpacity(0.1),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notes, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.completionNote!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (!task.isCompleted) ...[
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.check_circle_outline, size: 32, color: Colors.black),
                  onPressed: () => _showCompleteTaskDialog(task),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
