import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/promemoria.dart';

abstract interface class PromemoriaStore {
  Future<List<Promemoria>> tutti();
  Future<void> salva(Promemoria promemoria);
  Future<void> elimina(int id);
}

class PromemoriaStorePreferenze implements PromemoriaStore {
  static const String _chiave = 'promemoria.v1';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<List<Promemoria>> tutti() async {
    final prefs = await _prefs;
    final raw = prefs.getString(_chiave);

    if (raw == null || raw.isEmpty) return [];

    final lista = (jsonDecode(raw) as List)
        .map((e) => Promemoria.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    lista.sort((a, b) => a.quando.compareTo(b.quando));
    return lista;
  }

  Future<void> _scrivi(List<Promemoria> lista) async {
    final prefs = await _prefs;
    await prefs.setString(
      _chiave,
      jsonEncode(lista.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> salva(Promemoria promemoria) async {
    final lista = await tutti();
    final indice = lista.indexWhere((e) => e.id == promemoria.id);

    if (indice == -1) {
      lista.add(promemoria);
    } else {
      lista[indice] = promemoria;
    }

    await _scrivi(lista);
  }

  @override
  Future<void> elimina(int id) async {
    final lista = await tutti();
    lista.removeWhere((e) => e.id == id);
    await _scrivi(lista);
  }
}