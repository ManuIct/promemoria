import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'package:riverpod/src/framework.dart';

class DiagnosticaPage extends ConsumerWidget {
 const DiagnosticaPage({super.key});

  ProviderListenable<dynamic>? get idAvvioProvider => null;

  ProviderListenable<dynamic>? get codaProvider => null;

   @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idAvvio = ref.watch(idAvvioProvider!);
    final coda = ref.watch(codaProvider!);
    final permesso = ref.watch(permessoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostica'),
        actions: [
          IconButton(
            tooltip: 'Aggiorna',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(codaProvider as ProviderOrFamily);
              ref.read(permessoProvider.notifier).ricontrolla();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App avviata da una notifica?'),
            subtitle: Text(idAvvio == null ? 'No' : 'Si, promemoria $idAvvio'),
          ),
          ListTile(
            title: Text('In coda (${coda.value?.length ?? '....'})'),
            subtitle: Text(coda.value?.join(',') ?? ''),
          ),
          ListTile(
            title: const Text('Permesso notifiche'),
            subtitle: Text(permesso.value == true ? 'Concesso' : 'NON concesso'),
          )
        ],
      ),
    );
  }
}