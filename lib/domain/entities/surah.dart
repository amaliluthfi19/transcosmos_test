class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;

  Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Surah &&
        other.nomor == nomor &&
        other.nama == nama &&
        other.namaLatin == namaLatin &&
        other.jumlahAyat == jumlahAyat &&
        other.tempatTurun == tempatTurun &&
        other.arti == arti &&
        other.deskripsi == deskripsi &&
        other.audio == audio;
  }

  @override
  int get hashCode {
    return nomor.hashCode ^
        nama.hashCode ^
        namaLatin.hashCode ^
        jumlahAyat.hashCode ^
        tempatTurun.hashCode ^
        arti.hashCode ^
        deskripsi.hashCode ^
        audio.hashCode;
  }

  @override
  String toString() {
    return 'Surah{nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, tempatTurun: $tempatTurun, arti: $arti, audio: $audio}';
  }
}
