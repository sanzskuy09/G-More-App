// lib/utils/ktp_parser.dart

import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

Map<String, String> parseKtpFields(String ocrText) {
  final lines = ocrText.split('\n').map((e) => e.trim()).toList();

  debugPrint("📷 lines: $lines");

  final nik = detectNik(lines);
  final nama = detectNama(lines);
  final tempatDanTgl = detectTempatDanTglLahir(lines);
  final alamat = detectAlamat(lines);

  return {
    'nik': nik,
    'nama': nama,
    'tempat_lahir': tempatDanTgl['tempat'] ?? '',
    'tgl_lahir': tempatDanTgl['tgl'] ?? '',
    'alamat': alamat['alamat'] ?? '',
    'rt_rw': alamat['rt_rw'] ?? '',
    'kel_desa': alamat['kel_desa'] ?? '',
    'kecamatan': alamat['kecamatan'] ?? '',
  };
}

String detectNik(List<String> lines) {
  for (final line in lines) {
    if (RegExp(r'\b[\dA-Z]{12,18}\b', caseSensitive: false).hasMatch(line)) {
      return line;
    }
    // final match = ;
    // if (match != null) return match.group(0)!;
  }
  return '';
}

String detectNama(List<String> lines) {
  final exclusionKeywords = [
    'NIK',
    'KOTA',
    'PROVINSI',
    'VINSI',
    'KABUP',
    'PATEN',
    'KABUPATEN',
    'LAKI',
    'PEREMPUAN',
    'RT',
    'RW',
    'KP',
    'JL',
    'GG'
  ];

  final isLikelyName = RegExp(r"^[\p{Lu}\s'`´\-\.]+$", unicode: true);

  for (final line in lines) {
    String cleaned = line.replaceAll(':', '').trim();

    // Opsional: hapus aksen agar bisa dicek lebih netral
    String normalized = removeDiacritics(cleaned);

    if (isLikelyName.hasMatch(normalized) &&
        !normalized.contains(RegExp(r'\d')) &&
        !exclusionKeywords.any((k) => normalized.contains(k)) &&
        normalized.length > 3) {
      return cleaned;
    }
  }

  return '';
}

Map<String, String> detectTempatDanTglLahir(List<String> lines) {
  for (final rawLine in lines) {
    String line = rawLine.trim();

    // Bersihkan label seperti 'Tempat/Tgl Lahir:', 'TempatHg Lahir'
    line = line.replaceAll(
        RegExp(r'tempat.*?lahir[:\s]*', caseSensitive: false), '');

    // Kasus 1: Format dengan koma, seperti "Jakarta, 09-03-2000" atau "Jakarta, 09-03 2000"
    if (line.contains(',')) {
      final parts = line.split(',');
      if (parts.length == 2) {
        String tempat = parts[0].trim();
        String rawTgl = parts[1].trim();

        // Normalisasi jika formatnya 09-03 2000 → 09-03-2000
        rawTgl =
            rawTgl.replaceAll(RegExp(r'(\d{2}-\d{2})\s+(\d{4})'), r'\1-\2');

        return {
          'tempat': tempat,
          'tgl': rawTgl,
        };
      }
    }

    // Kasus 2: Format tanpa koma
    final match =
        RegExp(r'([A-Z\s]+)(\d{2}-\d{2}-\d{4}|\d{2}-\d{6}|\d{2}-\d{2}\s\d{4})')
            .firstMatch(line);
    if (match != null) {
      String tempat = match.group(1)?.trim() ?? '';
      String rawTgl = match.group(2)?.trim() ?? '';

      // Normalisasi jika 09-03 2000 → 09-03-2000
      rawTgl = rawTgl.replaceAll(RegExp(r'(\d{2}-\d{2})\s+(\d{4})'), r'\1-\2');

      return {
        'tempat': tempat,
        'tgl': rawTgl,
      };
    }
  }

  return {'tempat': '', 'tgl': ''};
}

Map<String, String> detectAlamat(List<String> lines) {
  String alamat = '';
  String rt = '';
  String rw = '';
  String kelDesa = '';
  String kecamatan = '';

  for (final line in lines) {
    final lowerLine = line.toLowerCase();

    if (alamat.isEmpty &&
        (lowerLine.contains('jalan') ||
            lowerLine.contains('jl') ||
            lowerLine.contains('gg') ||
            lowerLine.contains('kp'))) {
      alamat = line.trim();
    }

    // RT/RW format 001/002
    final rtRwRegex = RegExp(r'\b(\d{1,3})/(\d{1,3})\b');

    if ((rt.isEmpty || rw.isEmpty) && rtRwRegex.hasMatch(line)) {
      final match = rtRwRegex.firstMatch(line);
      if (match != null) {
        rt = match.group(1)!.padLeft(3, '0');
        rw = match.group(2)!.padLeft(3, '0');
      }
    }

    if (kelDesa.isEmpty &&
        (lowerLine.contains('kel') || lowerLine.contains('desa'))) {
      kelDesa = line.trim();
    }

    if (kecamatan.isEmpty && lowerLine.contains('kecamatan')) {
      kecamatan = line.trim();
    }
  }

  return {
    'alamat': alamat,
    'rt_rw': '$rt/$rw',
    'kel_desa': kelDesa,
    'kecamatan': kecamatan,
  };
}

// String detectAlamat(List<String> lines) {
//   for (final line in lines) {
//     final lower = line.toLowerCase();
//     if (lower.contains('jl') ||
//         lower.contains('jalan') ||
//         lower.contains('gg') ||
//         lower.contains('kp') &&
//             (!lower.contains('hidup') || !lower.contains('h1dup'))) {
//       return line;
//     }
//   }
//   return '';
// }
