import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_states.dart';
import 'category_cubit.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: BlocConsumer<CategoryCubit, CategoryState>(
        listenWhen: (a, b) => a.actionError != b.actionError,
        listener: (context, state) {
          if (state.actionError != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.actionError!)));
            context.read<CategoryCubit>().clearActionError();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const AppLoading(message: 'Loading categories…');
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'New category name',
                        ),
                        onSubmitted: (_) => _add(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => _add(context),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              SwitchListTile(
                value: state.showArchived,
                onChanged: (v) =>
                    context.read<CategoryCubit>().toggleArchived(v),
                title: const Text('Show archived'),
                dense: true,
              ),
              const Divider(height: 1),
              Expanded(
                child: state.items.isEmpty
                    ? const AppEmpty(
                        icon: Icons.category_outlined,
                        title: 'No categories yet',
                        message:
                            'Categories are optional but help organise stock.',
                      )
                    : ListView.separated(
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final c = state.items[i];
                          return ListTile(
                            leading: Icon(
                              c.isArchived
                                  ? Icons.archive_outlined
                                  : Icons.label_outline,
                            ),
                            title: Text(
                              c.name,
                              style: c.isArchived
                                  ? const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                    )
                                  : null,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  tooltip: 'Rename',
                                  onPressed: () =>
                                      _rename(context, c.id, c.name),
                                ),
                                if (c.isArchived)
                                  IconButton(
                                    icon: const Icon(Icons.unarchive_outlined),
                                    tooltip: 'Restore',
                                    onPressed: () => context
                                        .read<CategoryCubit>()
                                        .unarchive(c.id),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.archive_outlined),
                                    tooltip: 'Archive',
                                    onPressed: () => context
                                        .read<CategoryCubit>()
                                        .archive(c.id),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _add(BuildContext context) {
    final v = _name.text.trim();
    if (v.isEmpty) return;
    context.read<CategoryCubit>().create(v);
    _name.clear();
  }

  Future<void> _rename(BuildContext context, String id, String current) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Category name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && context.mounted) {
      context.read<CategoryCubit>().rename(id, result);
    }
    controller.dispose();
  }
}
