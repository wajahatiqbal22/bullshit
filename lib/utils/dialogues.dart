import 'package:bullshit/models/todo_model.dart';
import 'package:bullshit/network/network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingDialogue(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  width: 15,
                ),
                Text("Loading..."),
              ],
            ),
          ));
}

void showSuccessDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Close"),
        )
      ],
      title: const Text("Sucess"),
      content: Row(
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 20,
          ),
          Text("Todo Added Successfully"),
        ],
      ),
    ),
  );
}

void showDangerDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Close"),
        )
      ],
      title: const Text("Error"),
      content: Row(
        children: const [
          Icon(Icons.error),
          SizedBox(
            width: 20,
          ),
          Text("There was an issue"),
        ],
      ),
    ),
  );
}

void showEditTodoDialogue(BuildContext context,
    {required TodoModel passedTodo}) {
  final network = Network();
  GlobalKey<FormState> editFormKey = GlobalKey();
  TextEditingController editTodoCon = TextEditingController();

  editTodoCon.text = passedTodo.todoTitle;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Edit Todo"),
      content: Form(
        key: editFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (val) {
                if (val == null || val.length < 6) {
                  return "Title must be at least 6 characters";
                } else if (passedTodo.todoTitle == val) {
                  return "Title is the same";
                }
                return null;
              },
              controller: editTodoCon,
              decoration: const InputDecoration(label: Text("Edit todo")),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (editFormKey.currentState!.validate()) {
              passedTodo.todoTitle = editTodoCon.text;

              showLoadingDialogue(context);
              await network.editTodoNetwork(passedTodo: passedTodo);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: const Text("Edit"),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close")),
      ],
    ),
  );
}

void showDeleteDialogue(BuildContext context, {required TodoModel passedTodo}) {
  final network = Network();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () async {
            await network.deleteTodoNetwork(passedTodo: passedTodo);
            Navigator.pop(context);
          },
          child: const Text("Delete"),
          style: ElevatedButton.styleFrom(primary: Colors.red),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Close"),
        )
      ],
      title: const Text("Delete"),
      content: Row(
        children: const [
          Icon(Icons.remove),
          SizedBox(
            width: 20,
          ),
          Text("Are you sure you wanna delete?"),
        ],
      ),
    ),
  );
}
