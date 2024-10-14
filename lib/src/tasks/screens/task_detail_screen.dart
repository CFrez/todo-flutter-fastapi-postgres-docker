import 'package:family/src/components/checkbox_form_field.dart';
import 'package:family/src/components/date_form_field.dart';
import 'package:flutter/material.dart';

import 'package:family/main.dart';
import 'package:family/src/tasks/providers/task_details_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  static const routeName = '/detail';

  const TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final detailsProvider = getIt<TaskDetailsProvider>();

  @override
  void initState() {
    super.initState();
    detailsProvider.addListener(() {
      setStateIfMounted(() {});
    });
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void _handleSave() async {
    if (detailsProvider.isProcessing) return;

    final newItem = await detailsProvider.saveTask();
    if (newItem != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      // ToastService.error('Error saving item');
      print('Error saving item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Task Details'),
          actions: [
            TextButton(
              onPressed: _handleSave,
              child: Text('Save',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
          ],
        ),
        body: Form(
          key: detailsProvider.form,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    icon: Icon(Icons.task_alt_outlined),
                  ),
                  autofocus: true,
                  onChanged: detailsProvider.setTitle,
                  validator: detailsProvider.validateTitle,
                  initialValue: detailsProvider.task.title,
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    icon: Icon(Icons.description),
                  ),
                  maxLines: 3, //or
                  onChanged: detailsProvider.setDescription,
                  initialValue: detailsProvider.task.description,
                ),
                SizedBox(height: 8),
                CheckboxFormField(
                  value: detailsProvider.task.isCompleted,
                  onChanged: detailsProvider.setIsCompleted,
                  labelText: 'Complete',
                ),
                FutureDateFormField(
                    initialValue: detailsProvider.task.dueDate,
                    onChanged: detailsProvider.setDueDate),
                SizedBox(height: 24),
                if (detailsProvider.isProcessing)
                  Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        ));
  }
}
