import 'package:bloc_cubit/cubit/todo_cubit.dart';
import 'package:bloc_cubit/cubit/todo_state.dart';
import 'package:bloc_cubit/cubit/todo_search_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              final _ = context.locale;

              return SearchBar(
                hintText: "search_todo".tr(),
                controller: _searchController,
                leading: const Icon(Icons.search),
                onChanged: (value) {
                  context.read<TodoSearchCubit>().setQuery(value);
                },
              );
            },
          ),
        ),

        // Add todo
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    final _ = context.locale;
                    return TextField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: "enter_todo".tr()),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    context.read<TodoCubit>().addTodo(text);
                    _controller.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("todo_added".tr()),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("empty_todo_msg".tr()),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),

        // Todo list (filtered)
        Expanded(
          child: BlocBuilder<TodoCubit, TodoState>(
            builder: (context, todoState) {
              return BlocBuilder<TodoSearchCubit, String>(
                builder: (context, query) {
                  final filtered = query.isEmpty
                      ? todoState.todos
                      : todoState.todos
                            .where(
                              (t) => t.title.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            )
                            .toList();

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final todo = filtered[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isComplete,
                          onChanged: (_) {
                            context.read<TodoCubit>().toggleTodo(todo.id);
                          },
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isComplete
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<TodoCubit>().deleteTodo(todo.id);
                          },
                        ),
                        onTap: () async {
                          final newTitle = await showDialog(
                            context: context,
                            builder: (context) {
                              final editController = TextEditingController(
                                text: todo.title,
                              );
                              return AlertDialog(
                                title: Text("edit_todo".tr()),
                                content: TextField(
                                  controller: editController,
                                  autofocus: true,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, null),
                                    child: Text("cancel".tr()),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                      context,
                                      editController.text.trim(),
                                    ),
                                    child: Text("save".tr()),
                                  ),
                                ],
                              );
                            },
                          );
                          if (newTitle != null && newTitle.isNotEmpty) {
                            context.read<TodoCubit>().updateTodo(
                              todo.id,
                              newTitle,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
