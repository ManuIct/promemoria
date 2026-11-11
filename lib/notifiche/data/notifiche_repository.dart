



import 'package:promemoria/notifiche/domain/promemoria.dart';

abstract interface class NotificheRepository {
  Future<bool> permessoConcesso();
  Future<bool> chiediPermesso();
  Future<List<Promemoria>> tutti();
  Future<Promemoria?> perId(int id);
  Future<bool> alle(int ora, int minuto, String titolo);
  Future<bool> traSecondi(int secondi, String titolo);
  Future<void> elimina(int id);
  Future<void> segnaFatto(int id);
}