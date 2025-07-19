import 'package:transcosmos_test/domain/entities/surah_detail.dart';
import 'package:transcosmos_test/domain/entities/surah.dart';
import 'package:transcosmos_test/domain/entities/ayat.dart';
import 'ayat_model.dart';
import 'surah_model.dart';

class SurahDetailModel extends SurahDetail {
  SurahDetailModel({
    required super.status,
    required super.nomor,
    required super.nama,
    required super.namaLatin,
    required super.jumlahAyat,
    required super.tempatTurun,
    required super.arti,
    required super.deskripsi,
    required super.audio,
    required super.ayats,
    super.suratSelanjutnya,
    super.suratSebelumnya,
  });

  factory SurahDetailModel.fromJson(Map<String, dynamic> json) {
    return SurahDetailModel(
      status: json['status'] ?? false,
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['nama_latin'] ?? '',
      jumlahAyat: json['jumlah_ayat'] ?? 0,
      tempatTurun: json['tempat_turun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      ayats:
          (json['ayat'] as List<dynamic>?)
              ?.map((ayatJson) => AyatModel.fromJson(ayatJson))
              .toList() ??
          [],
      suratSelanjutnya:
          json['surat_selanjutnya'] != null
              ? SurahModel.fromJson(json['surat_selanjutnya'])
              : null,
      suratSebelumnya:
          json['surat_sebelumnya'] != null && json['surat_sebelumnya'] != false
              ? SurahModel.fromJson(json['surat_sebelumnya'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'nomor': nomor,
      'nama': nama,
      'nama_latin': namaLatin,
      'jumlah_ayat': jumlahAyat,
      'tempat_turun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audio': audio,
      'ayat': ayats.map((ayat) => (ayat as AyatModel).toJson()).toList(),
      'surat_selanjutnya':
          suratSelanjutnya != null
              ? (suratSelanjutnya as SurahModel).toJson()
              : null,
      'surat_sebelumnya':
          suratSebelumnya != null
              ? (suratSebelumnya as SurahModel).toJson()
              : null,
    };
  }

  SurahDetailModel copyWith({
    bool? status,
    int? nomor,
    String? nama,
    String? namaLatin,
    int? jumlahAyat,
    String? tempatTurun,
    String? arti,
    String? deskripsi,
    String? audio,
    List<Ayat>? ayats,
    Surah? suratSelanjutnya,
    Surah? suratSebelumnya,
  }) {
    return SurahDetailModel(
      status: status ?? this.status,
      nomor: nomor ?? this.nomor,
      nama: nama ?? this.nama,
      namaLatin: namaLatin ?? this.namaLatin,
      jumlahAyat: jumlahAyat ?? this.jumlahAyat,
      tempatTurun: tempatTurun ?? this.tempatTurun,
      arti: arti ?? this.arti,
      deskripsi: deskripsi ?? this.deskripsi,
      audio: audio ?? this.audio,
      ayats: ayats ?? this.ayats,
      suratSelanjutnya: suratSelanjutnya ?? this.suratSelanjutnya,
      suratSebelumnya: suratSebelumnya ?? this.suratSebelumnya,
    );
  }
}
