import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteTodoButton extends StatelessWidget {
  final DocumentReference docRef;
  const DeleteTodoButton({super.key, required this.docRef});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Delete Todo"),
            content: const Text("Are you sure, you want to delete this task!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (confirm != true) return;
        try {
          await docRef.delete();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Task Deleted Successfully"),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Deleted failed: $e"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
    );
  }
}
