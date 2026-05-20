import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFF5722),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF5722),
          onSecondary: Colors.white,
          surface: Color(0xFFFFFFFF),
          onSurface: Colors.black87,
          surfaceContainerHighest: Color(0xFFEDE7F6),
          primaryContainer: Color(0xFFC7B3FF),
          error: Color(0xFFD32F2F),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F0FF),
        useMaterial3: true,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoItem {
  TodoItem({required this.text, this.completed = false});

  final String text;
  bool completed;
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final List<TodoItem> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    final newTodo = _controller.text.trim();
    if (newTodo.isEmpty) return;

    setState(() {
      _todos.insert(0, TodoItem(text: newTodo));
      _controller.clear();
    });
  }

  void _toggleTodo(int index, bool? value) {
    setState(() {
      _todos[index].completed = value ?? false;
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _clearCompleted() {
    setState(() {
      _todos.removeWhere((todo) => todo.completed);
    });
  }

  void _clearAll() {
    setState(() {
      _todos.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _todos.length;
    final completed = _todos.where((todo) => todo.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear completed',
            onPressed: completed > 0 ? _clearCompleted : null,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tasks: $completed / $total completed',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Chip(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text(
                        total == 0 ? 'Empty' : '$total total',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Add a new task',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTodo(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 90,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _addTodo,
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _todos.isEmpty
                    ? Center(
                        child: Text(
                          'No tasks yet. Add one above!',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.separated(
                        itemCount: _todos.length,
                        separatorBuilder: (_, _) => const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final todo = _todos[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Dismissible(
                              key: ValueKey(todo.text + index.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) => _removeTodo(index),
                              child: CheckboxListTile(
                                tileColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                                selectedTileColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                selected: todo.completed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                value: todo.completed,
                                onChanged: (value) => _toggleTodo(index, value),
                                title: Text(
                                  todo.text,
                                  style: TextStyle(
                                    decoration: todo.completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                secondary: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _removeTodo(index),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
