import 'package:transcosmos_test/domain/entities/ayat.dart';

class AyatModel extends Ayat {
  AyatModel({
    required super.id,
    required super.surah,
    required super.nomor,
    required super.ar,
    required super.tr,
    required super.idn,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    return AyatModel(
      id: json['id'] ?? 0,
      surah: json['surah'] ?? 0,
      nomor: json['nomor'] ?? 0,
      ar: json['ar'] ?? '',
      tr: json['tr'] ?? '',
      idn: json['idn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surah': surah,
      'nomor': nomor,
      'ar': ar,
      'tr': tr,
      'idn': idn,
    };
  }

  AyatModel copyWith({
    int? id,
    int? surah,
    int? nomor,
    String? ar,
    String? tr,
    String? idn,
  }) {
    return AyatModel(
      id: id ?? this.id,
      surah: surah ?? this.surah,
      nomor: nomor ?? this.nomor,
      ar: ar ?? this.ar,
      tr: tr ?? this.tr,
      idn: idn ?? this.idn,
    );
  }
}
