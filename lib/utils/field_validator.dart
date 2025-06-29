String? validateField(String key, String label, String? value) {
  if ([
    'nama',
    'umur',
    'alamat',
    'kel',
    'kec',
    'kota',
    'provinsi',
    'kodepos',
    'tgllahir',
    'tampatlahir',
    'dealer',
  ].contains(key)) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
  }

  if (key == 'nik') {
    if (value == null || value.isEmpty) return 'NIK wajib diisi';
    if (value.length != 16) return 'NIK harus 16 digit';
  }

  if (key == 'nikpasangan') {
    if (value == null || value.isEmpty && value.length != 16) {
      return 'NIK harus 16 digit';
    }
  }

  if (key == 'rt' || key == 'rw') {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi';
    if (!RegExp(r'^\d+$').hasMatch(value)) return '$label harus berupa angka';
  }

  if (key == 'jeniskelamin') {
    if (value == null || value.trim().isEmpty) {
      return 'Jenis kelamin wajib dipilih';
    }
  }

  if (key == 'cabang') {
    if (value == null || value.trim().isEmpty) {
      return 'Cabang wajib dipilih';
    }
  }

  return null;
}
