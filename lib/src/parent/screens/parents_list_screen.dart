import 'package:family/src/parent/components/parents_list.dart';
import 'package:flutter/material.dart';

import 'package:family/main.dart';
import 'package:family/src/parent/providers/parent_details_provider.dart';
import 'package:family/src/parent/providers/parents_list_provider.dart';
import 'package:family/src/parent/screens/parent_detail_screen.dart';

class ParentsListScreen extends StatefulWidget {
  static const routeName = '/';

  const ParentsListScreen({super.key});

  @override
  State<ParentsListScreen> createState() => _ParentsListScreenState();
}

class _ParentsListScreenState extends State<ParentsListScreen> {
  final listProvider = getIt<ParentsListProvider>();

  void _handleAddParent() {
    getIt<ParentDetailsProvider>().clearParent();
    Navigator.of(context).pushNamed(ParentDetailScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleAddParent();
        },
        child: const Icon(Icons.add),
      ),
      body: ParentsList(handleAddParent: _handleAddParent),
    );
  }
}
