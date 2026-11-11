import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/notifiche_repository.dart';
import 'data/notifiche_repository_impl.dart';
import 'data/promemoria_store.dart';
import 'data/source/notifiche_locali_source_impl.dart';
import 'data/source/notifiche_source.dart';
import 'domain/promemoria.dart';

final notificheSourceProvider = Provider<NotificheSource>(
  (ref) => NotificheLocaliSourceImpl(),
);

final promemoriaStoreProvider = Provider<PromemoriaStore>(
  (ref) => PromemoriaStorePreferenze(),
);

final notificheRepositoryProvider = Provider<NotificheRepository>(
  (ref) => NotificheRepositoryImpl(
    ref.watch(notificheSourceProvider),
    ref.watch(promemoriaStoreProvider),
  ),
);

class PromemoriaController extends AsyncNotifier<List<Promemoria>> {
  NotificheRepository get _repo => ref.read(notificheRepositoryProvider);

  @override
  Future<List<Promemoria>> build() => _repo.tutti();

  Future<void> ricarica() async => state = AsyncData(await _repo.tutti());

  Future<bool> aggiungi(String titolo, int ora, int minuto) async {
    final concesso = await ref.read(permessoProvider.notifier).chiedi();
    await _repo.alle(ora, minuto, titolo);
    await ricarica();
    return concesso;
  }

  Future<bool> aggiungiTraSecondi(String titolo, int secondi) async {
    final concesso = await ref.read(permessoProvider.notifier).chiedi();
    await _repo.traSecondi(secondi, titolo);
    await ricarica();
    return concesso;
  }

  Future<void> elimina(int id) async {
    await _repo.elimina(id);
    await ricarica();
  }

  Future<void> fatto(int id) async {
    await _repo.segnaFatto(id);
    await ricarica();
  }
}

final promemoriaProvider =
    AsyncNotifierProvider<PromemoriaController, List<Promemoria>>(
  PromemoriaController.new,
);

class PermessoController extends AsyncNotifier<bool> {
  NotificheRepository get _repo => ref.read(notificheRepositoryProvider);

  @override
  Future<bool> build() => _repo.permessoConcesso();

  Future<bool> chiedi() async {
    final ok = await _repo.chiediPermesso();
    state = AsyncData(ok);
    return ok;
  }

  Future<void> ricontrolla() async {
    state = AsyncData(await _repo.permessoConcesso());
  }
}

final permessoProvider = AsyncNotifierProvider<PermessoController, bool>(
  PermessoController.new,
);

final idAvvioProvider = Provider<int?>((ref) => null);

final codaProvider = FutureProvider.autoDispose<List<int>>(
  (ref) => ref.watch(notificheSourceProvider).idInCoda(),
);