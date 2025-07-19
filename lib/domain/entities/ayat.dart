class Ayat {
  final int id;
  final int surah;
  final int nomor;
  final String ar; // Arabic text
  final String tr; // Transliteration
  final String idn; // Indonesian translation

  Ayat({
    required this.id,
    required this.surah,
    required this.nomor,
    required this.ar,
    required this.tr,
    required this.idn,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ayat &&
        other.id == id &&
        other.surah == surah &&
        other.nomor == nomor &&
        other.ar == ar &&
        other.tr == tr &&
        other.idn == idn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        surah.hashCode ^
        nomor.hashCode ^
        ar.hashCode ^
        tr.hashCode ^
        idn.hashCode;
  }

  @override
  String toString() {
    return 'Ayat{id: $id, surah: $surah, nomor: $nomor, ar: $ar}';
  }
}
