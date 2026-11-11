// lib/notifiche/domain/orario.dart

DateTime prossimaOccorrenza(DateTime adesso, int ora, int minuto) {
  // Crea una data con oggi, all'ora e minuto specificati
  var data = DateTime(adesso.year, adesso.month, adesso.day, ora, minuto);
  
  // Se l'orario scelto è già passato rispetto ad "adesso", 
  // significa che il promemoria deve suonare domani.
  if (data.isBefore(adesso)) {
    data = data.add(const Duration(days: 1));
  }
  
  return data;
}
