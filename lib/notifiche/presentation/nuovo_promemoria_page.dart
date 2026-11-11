import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/orario.dart';
import 'home_page.dart' show quandoInTesto;
import '../providers.dart';

class NuovoPromemoriaPage extends ConsumerStatefulWidget {
  const NuovoPromemoriaPage({super.key});

  @override
  ConsumerState<NuovoPromemoriaPage> createState() =>
      _NuovoPromemoriaPageState();
}

class _NuovoPromemoriaPageState extends ConsumerState<NuovoPromemoriaPage> {
  final _titolo = TextEditingController();
  TimeOfDay _ora = const TimeOfDay(hour: 9, minute: 0);
  bool _inCorso = false;

  @override
  void dispose() {
    _titolo.dispose(); 
    super.dispose();
  }

  Future<void> _scegliOra() async {
    final scelta = await showTimePicker(context: context, initialTime: _ora);
    if (scelta != null) setState(() => _ora = scelta);
  }

  Future<void> _salva() async {
    final titolo = _titolo.text.trim();
    if (titolo.isEmpty || _inCorso) return;
    
    setState(() => _inCorso = true);
    final messenger = ScaffoldMessenger.of(context);
    
   
    final concesso = await ref
        .read(promemoriaProvider.notifier)
        .aggiungi(titolo, _ora.hour, _ora.minute); 

    if (!mounted) return;
    
   
    if (!concesso) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Notifiche non permesse: il promemoria è salvato ma non suonerà',
          ),
        ),
      );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final suonera = prossimaOccorrenza(DateTime.now(), _ora.hour, _ora.minute);

    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo promemoria')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titolo,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Cosa devo ricordarti?',
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _scegliOra,
              icon: const Icon(Icons.schedule),
              label: Text('Ora: ${_ora.format(context)}'),
            ),
            const SizedBox(height: 8),
            Text('Suonerà il ${quandoInTesto(suonera)}'),
            const Spacer(),
            FilledButton(
              onPressed: _inCorso ? null : _salva,
              child: const Text('Salva promemoria'),
            ),
          ],
        ),
      ),
    );
  }
}