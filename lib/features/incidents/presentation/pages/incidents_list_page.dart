import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_ops/design/components/app_scaffold.dart';
import 'package:pulse_ops/design/components/empty_state.dart';
import 'package:pulse_ops/design/components/status_chip.dart';
import 'package:pulse_ops/design/tokens/colors.dart';
import 'package:pulse_ops/design/tokens/spacing.dart';
import 'package:pulse_ops/design/tokens/typography.dart';
import 'package:pulse_ops/features/incidents/domain/entities/incident.dart';


import '../controllers/incidents_controller.dart';

class IncidentsListPage extends ConsumerWidget {
  const IncidentsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incidentsAsync = ref.watch(incidentsStreamProvider);

    return AppScaffold(
      title: 'PulseOps',
      actions: [
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () =>
              ref.read(incidentsControllerProvider.notifier).sync(),
        )
      ],
      fab: FloatingActionButton.extended(
        onPressed: () => _openCreateDialog(context, ref),
        label: const Text('Novo'),
        icon: const Icon(Icons.add),
      ),
      body: incidentsAsync.when(
        data: (incidents) => _Content(incidents),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  void _openCreateDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Criar incidente'),
        content: TextField(
          controller: titleCtrl,
          decoration: const InputDecoration(labelText: 'Título'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            child: const Text('Criar'),
            onPressed: () async {
              await ref.read(incidentsControllerProvider.notifier)
                  .create(title: titleCtrl.text);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final List<Incident> incidents;
  const _Content(this.incidents);

  @override
  Widget build(BuildContext context) {
    if (incidents.isEmpty) {
      return const EmptyState(
        title: 'Nenhum incidente',
        subtitle: 'Toque no botão + para criar o primeiro',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(incidents),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: ListView.separated(
            itemCount: incidents.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _IncidentCard(incidents[i]),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final List<Incident> incidents;
  const _Header(this.incidents);

  @override
  Widget build(BuildContext context) {
    final open = incidents.where((e) => e.status == 'open').length;
    final resolved = incidents.where((e) => e.status == 'resolved').length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Incidents', style: AppTypography.title),
        const SizedBox(height: 8),
        Row(
          children: [
            _StatCard('Abertos', open, AppColors.warning),
            const SizedBox(width: 12),
            _StatCard('Resolvidos', resolved, AppColors.success),
          ],
        )
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(value.toString(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _IncidentCard extends StatelessWidget {
  final Incident incident;
  const _IncidentCard(this.incident);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/incidents/${incident.id}',
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(incident.title, style: AppTypography.body),
                  const SizedBox(height: 4),
                  Text(
                    '${incident.updatedAt}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            StatusChip(incident.status),
          ],
        ),
      ),
    );
  }
}