class Promemoria {
  const Promemoria({
    required this.id,
    required this.titolo,
    required this.quando,
    this.fatto = false,
  });

  final int id;
  final String titolo;
  final DateTime quando;
  final bool fatto;

  Promemoria copyWith({
    String? titolo,
    DateTime? quando,
    bool? fatto,
  }) =>
      Promemoria(
        id: id,
        titolo: titolo ?? this.titolo,
        quando: quando ?? this.quando,
        fatto: fatto ?? this.fatto,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'titolo': titolo,
        'quando': quando.toIso8601String(),
        'fatto': fatto,
      };

  factory Promemoria.fromJson(Map<String, dynamic> json) => Promemoria(
        id: json['id'] as int,
        titolo: json['titolo'] as String,
        quando: DateTime.parse(json['quando'] as String),
        fatto: json['fatto'] as bool? ?? false,
      );

  get dataOra => null;
}