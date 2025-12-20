import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Addtodo extends StatefulWidget {
  const Addtodo({super.key});

  @override
  State<Addtodo> createState() => _AddtodoState();
}

class _AddtodoState extends State<Addtodo> {
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Add ToDo",
            style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              ///Title field:
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              SizedBox(height: 15),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 4,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),
                ),
              ),

              SizedBox(height: 30),

              //Submit button
              SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitData,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      // body: ListView(
      //   padding: EdgeInsets.all(20),

      //   // children: [
      //   //   TextField(
      //   //     controller: titleController,
      //   //     decoration: InputDecoration(hintText: "Title"),
      //   //   ),

      //   //   SizedBox(height: 10),
      //   //   TextField(
      //   //     controller: descriptionController,
      //   //     decoration: InputDecoration(hintText: "Description"),
      //   //     minLines: 4,
      //   //     maxLines: 5,
      //   //   ),

      //   //   SizedBox(height: 30),
      //   //   ElevatedButton(
      //   //     onPressed: isLoading ? null : submitData,
      //   //     child: isLoading
      //   //         ? CircularProgressIndicator()
      //   //         : Text(
      //   //             "Submit",
      //   //             style: TextStyle(
      //   //               fontWeight: FontWeight.bold,
      //   //               fontSize: 16,
      //   //               color: Colors.blue,
      //   //               // backgroundColor: Colors.black,
      //   //             ),
      //   //           ),
      //   //   ),
      //   // ],
      // ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (!_formkey.currentState!.validate()) {
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection("todos").add({
        "title": title,
        "description": description,
        "createdAt": DateTime.now(),
        "completed": false,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Todo Added Successfully")));

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }
}
