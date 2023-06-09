import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd_firebase/application/notes/note_actor/note_actor_bloc.dart';
import 'package:flutter_ddd_firebase/domain/notes/note.dart';
import 'package:flutter_ddd_firebase/domain/notes/todo_item.dart';
import 'package:kt_dart/kt.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          // TODO: navigate to edit form
        },
        onLongPress: () => _showDeletionDialog(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.body.getOrCrash(),
                style: const TextStyle(fontSize: 18),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(height: 4.0),
                Wrap(
                  spacing: 8.0,
                  children: note.todos
                      .getOrCrash()
                      .map((todoItem) => TodoDisplay(todoItem: todoItem))
                      .iter
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context) {
    final noteActorBloc = BlocProvider.of<NoteActorBloc>(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Selected note:"),
          content: Text(
            note.body.getOrCrash(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL"),
            ),
            ElevatedButton(
              onPressed: () {
                noteActorBloc.add(NoteActorEvent.deleted(note));
                Navigator.pop(context);
              },
              child: const Text("DELETE"),
            ),
          ],
        );
      },
    );
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todoItem;

  const TodoDisplay({super.key, required this.todoItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: todoItem.done,
          onChanged: null,
          checkColor: Theme.of(context).colorScheme.secondary,
        ),
        Text(todoItem.name.getOrCrash()),
      ],
    );
  }
}
