import 'surah.dart';
import 'ayat.dart';

class SurahDetail {
  final bool status;
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;
  final List<Ayat> ayats;
  final Surah? suratSelanjutnya;
  final Surah? suratSebelumnya;

  SurahDetail({
    required this.status,
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
    required this.ayats,
    this.suratSelanjutnya,
    this.suratSebelumnya,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SurahDetail &&
        other.status == status &&
        other.nomor == nomor &&
        other.nama == nama &&
        other.namaLatin == namaLatin &&
        other.jumlahAyat == jumlahAyat &&
        other.tempatTurun == tempatTurun &&
        other.arti == arti &&
        other.deskripsi == deskripsi &&
        other.audio == audio &&
        other.ayats == ayats &&
        other.suratSelanjutnya == suratSelanjutnya &&
        other.suratSebelumnya == suratSebelumnya;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        nomor.hashCode ^
        nama.hashCode ^
        namaLatin.hashCode ^
        jumlahAyat.hashCode ^
        tempatTurun.hashCode ^
        arti.hashCode ^
        deskripsi.hashCode ^
        audio.hashCode ^
        ayats.hashCode ^
        suratSelanjutnya.hashCode ^
        suratSebelumnya.hashCode;
  }

  @override
  String toString() {
    return 'SurahDetail{nomor: $nomor, nama: $nama, namaLatin: $namaLatin, jumlahAyat: $jumlahAyat, ayats: ${ayats.length}}';
  }
}
