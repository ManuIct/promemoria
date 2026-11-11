abstract interface class NotificheSource {
  Future<bool> permessoConcesso();
  Future<bool> chiediPermesso();
  Future<void> programma({required int id, required DateTime quando, required String titolo});
  Future<void> cancella(int id);
  Future<List<int>> idInCoda();

  Future<void> inizializza({void Function(String? payload)? onTap}) async {}
}
