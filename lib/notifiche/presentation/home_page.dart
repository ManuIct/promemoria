import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers.dart';
import 'dettaglio_page.dart';

String quandoInTesto(DateTime data) {
  final giorni = ['Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];
  final mesi = ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'];

  final giornoSettimana = giorni[data.weekday - 1];
  final mese = mesi[data.month - 1];
  final oraString = data.hour.toString().padLeft(2, '0');
  final minutoString = data.minute.toString().padLeft(2, '0');

  return '$giornoSettimana ${data.day} $mese alle $oraString:$minutoString';
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> _aggiungi(
    BuildContext context,
    WidgetRef ref,
    Future<bool> Function() azione,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final concesso = await azione();

    if (!concesso) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Notifiche non permesse: il promemoria è salvato ma non suonerà'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final promemoriaAsync = ref.watch(promemoriaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('I miei promemoria'),
        centerTitle: true,
      ),

      body: promemoriaAsync.when(
        data: (promemoriaList) {
          if (promemoriaList.isEmpty) {
            return const Center(
              child: Text(
                'Nessun promemoria presente.\nTicca il + per crearne uno!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: promemoriaList.length,
            itemBuilder: (context, index) {
              final promemoria = promemoriaList[index];
              if (promemoria == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    promemoria.titolo ?? 'Senza titolo',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: promemoria.dataOra != null
                      ? Text(quandoInTesto(promemoria.dataOra!))
                      : null,
                  trailing: Icon(
                    promemoria.fatto == true ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: promemoria.fatto == true ? Colors.green : Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DettaglioPage(id: promemoria.id!),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'prova',
            tooltip: 'Fra 10 secondi',
            onPressed: () => _aggiungi(
              context,
              ref,
              () => ref
                  .read(promemoriaProvider.notifier)
                  .aggiungiTraSecondi('Test 10 secondi', 10),
            ),
            child: const Icon(Icons.timer_10),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'nuovo',
            onPressed: () {
              try {
                context.push('/nuovo');
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rotta /nuovo non trovata nel router')),
                );
              }
            },
            icon: const Icon(Icons.add_alarm),
            label: const Text('Nuovo'),
          ),
        ],
      ),
    );
  }
}