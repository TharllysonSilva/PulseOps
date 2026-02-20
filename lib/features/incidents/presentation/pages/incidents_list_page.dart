import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/incidents_controller.dart';
import '../../domain/entities/incident.dart';

class IncidentsListPage extends ConsumerWidget {
  const IncidentsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentsAsync = ref.watch(incidentsStreamProvider);
    final controllerState = ref.watch(incidentsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PulseOps'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () => ref.read(incidentsControllerProvider.notifier).sync(),
          )
        ],
      ),
      body: Stack(
        children: [
          incidentsAsync.when(
            data: (incidents) => _IncidentsList(incidents),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
          ),
          if (controllerState.isLoading)
            const LinearProgressIndicator(minHeight: 2),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openCreateDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Incident'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            child: const Text('Create'),
            onPressed: () async {
              await ref.read(incidentsControllerProvider.notifier).create(
                    title: titleCtrl.text,
                    description: descCtrl.text,
                  );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _IncidentsList extends StatelessWidget {
  final List<Incident> incidents;
  const _IncidentsList(this.incidents);

  @override
  Widget build(BuildContext context) {
    if (incidents.isEmpty) {
      return const Center(child: Text('No incidents yet'));
    }

    return ListView.builder(
      itemCount: incidents.length,
      itemBuilder: (_, i) {
        final incident = incidents[i];

        return ListTile(
          leading: const Icon(Icons.warning_amber),
          title: Text(incident.title),
          subtitle: Text(incident.status),
          trailing: Text(
            _formatDate(incident.updatedAt),
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}