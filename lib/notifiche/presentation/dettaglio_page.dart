import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class DettaglioPage extends ConsumerWidget {
  final int id;

  const DettaglioPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final promemoriaAsync = ref.watch(promemoriaProvider);

    return promemoriaAsync.when(
      data: (promemoriaList) {
        final promemoria = promemoriaList.where((p) => p?.id == id).firstOrNull;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dettaglio promemoria'),
          ),
          body: promemoria == null
              ? const Center(
                  child: Text(
                    'Promemoria non trovato',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promemoria.titolo ?? 'Senza titolo',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Stato: ${promemoria.fatto == true ? "Completato" : "Da fare"}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Dettaglio promemoria'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Dettaglio promemoria'),
        ),
        body: Center(
          child: Text('Errore nel caricamento: $err'),
        ),
      ),
    );
  }
}