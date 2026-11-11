int? idDa(String? payload) {
  if (payload == null) return null;
  final numero = int.tryParse(payload);
  if (numero == null || numero < 1) return null;
  return numero;
}