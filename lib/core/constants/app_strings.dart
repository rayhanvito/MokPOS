/// App string constants (non-translated)
/// For localized strings, use l10n in the future
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'MokPOS';
  static const String appTagline = 'Easy Management for your Store.';

  // Auth
  static const String loginAsOwner = 'Masuk sebagai Pemilik';
  static const String loginAsEmployee = 'Masuk sebagai Karyawan';
  static const String createAccount = 'Buat Akun Baru';
  static const String alreadyHaveAccount = 'Sudah punya akun?';
  static const String dontHaveAccount = 'Belum punya akun?';
  static const String register = 'Daftar sekarang';
  static const String login = 'Masuk';
  static const String logout = 'Keluar';
  static const String forgotPassword = 'Lupa password?';

  // Common Actions
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String delete = 'Hapus';
  static const String edit = 'Edit';
  static const String add = 'Tambah';
  static const String search = 'Cari';
  static const String filter = 'Filter';
  static const String confirm = 'Konfirmasi';
  static const String continue_ = 'Lanjut';
  static const String back = 'Kembali';
  static const String close = 'Tutup';
  static const String done = 'Selesai';
  static const String next = 'Selanjutnya';
  static const String previous = 'Sebelumnya';
  static const String skip = 'Lewati';

  // Validation Messages
  static const String fieldRequired = 'Field ini wajib diisi';
  static const String invalidEmail = 'Email tidak valid';
  static const String invalidPhone = 'Nomor telepon tidak valid';
  static const String passwordTooShort = 'Password minimal 8 karakter';
  static const String passwordNotMatch = 'Password tidak cocok';

  // Error Messages
  static const String errorGeneral = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String errorNetwork = 'Tidak ada koneksi internet';
  static const String errorTimeout = 'Koneksi timeout. Silakan coba lagi.';
  static const String errorUnauthorized = 'Sesi Anda telah berakhir. Silakan login kembali.';

  // Success Messages
  static const String successSave = 'Data berhasil disimpan';
  static const String successDelete = 'Data berhasil dihapus';
  static const String successUpdate = 'Data berhasil diperbarui';

  // Empty States
  static const String emptyData = 'Tidak ada data';
  static const String emptySearch = 'Pencarian tidak ditemukan';
  static const String emptyCart = 'Keranjang kosong';
  static const String emptyHistory = 'Belum ada riwayat transaksi';
  static const String emptyProduct = 'Belum ada produk';

  // Currency
  static const String currencySymbol = 'Rp';
  static const String currencyLocale = 'id_ID';
}
