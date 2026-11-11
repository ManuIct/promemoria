import '../domain/orario.dart';
import '../domain/promemoria.dart';
import 'notifiche_repository.dart';
import 'promemoria_store.dart';
import 'source/notifiche_source.dart';
class NotificheRepositoryImpl implements NotificheRepository {
NotificheRepositoryImpl(this._source, this._store, {DateTime Function()? adesso}) : _adesso = adesso
?? DateTime.now;
final NotificheSource _source;
final PromemoriaStore _store;
final DateTime Function() _adesso;
int _prossimoId = DateTime.now().millisecondsSinceEpoch.remainder(0x7fffffff);
int _id() => ++_prossimoId;
@override Future<bool> permessoConcesso() => _source.permessoConcesso();
@override Future<bool> chiediPermesso() => _source.chiediPermesso();
@override Future<List<Promemoria>> tutti() => _store.tutti();
@override Future<Promemoria?> perId(int id) async {
for (final p in await _store.tutti()) { if (p.id == id) return p; }
return null;
}
Future<bool> _crea(DateTime quando, String titolo) async {
final id = _id();
final p = Promemoria(id: id, titolo: titolo, quando: quando);
await _store.salva(p);
if (await _source.permessoConcesso()) {
await _source.programma(id: id, quando: quando, titolo: titolo);
return true;
}
return false;
}
@override Future<bool> alle(int ora, int minuto, String titolo) =>
_crea(prossimaOccorrenza(_adesso(), ora, minuto), titolo);
@override Future<bool> traSecondi(int secondi, String titolo) {
if (secondi < 1) throw ArgumentError.value(secondi, 'secondi');
return _crea(_adesso().add(Duration(seconds: secondi)), titolo);
}
@override Future<void> elimina(int id) async { await _source.cancella(id); await _store.elimina(id); }
@override Future<void> segnaFatto(int id) async {
final p = await perId(id); if (p == null) return;
await _store.salva(p.copyWith(fatto: true)); await _source.cancella(id);
}
}