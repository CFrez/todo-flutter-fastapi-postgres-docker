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
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                  autofocus: true,
                  onChanged: detailsProvider.setName,
                  validator: detailsProvider.validateName,
                  initialValue: detailsProvider.task.name,
                ),
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
