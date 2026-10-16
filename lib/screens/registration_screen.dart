import 'package:flutter/material.dart';

import '../widgets/custom_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _selectedGender;
  bool _isAgreed = false;
  double _passwordStrength = 0.0;
  Color _passwordStrengthColor = Colors.grey;
  String _passwordStrengthText = '';
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Validasi nama
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Validasi email
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  // Validasi password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf kapital';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null;
  }

  // Validasi konfirmasi password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    return null;
  }

  // Fungsi untuk menghitung kekuatan password
  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthColor = Colors.grey;
        _passwordStrengthText = '';
      });
      return;
    }

    // Kategori Kuat: Minimal 8 karakter, huruf besar, huruf kecil, angka, dan simbol
    final hasUpper = RegExp(r'[A-Z]').hasMatch(value);
    final hasLower = RegExp(r'[a-z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (value.length >= 8 && hasUpper && hasLower && hasDigit && hasSymbol) {
      setState(() {
        _passwordStrength = 1.0;
        _passwordStrengthColor = Colors.green;
        _passwordStrengthText = 'Kuat';
      });
    }
    // Kategori Sedang: Minimal 8 karakter, mengandung huruf dan angka
    else if (value.length >= 8 && (hasUpper || hasLower) && hasDigit) {
      setState(() {
        _passwordStrength = 0.66;
        _passwordStrengthColor = Colors.orange;
        _passwordStrengthText = 'Sedang';
      });
    }
    // Kategori Lemah: Kurang dari 8 karakter
    else {
      setState(() {
        _passwordStrength = 0.33;
        _passwordStrengthColor = Colors.red;
        _passwordStrengthText = 'Lemah';
      });
    }
  }

  // Handler submit form
  void _submitForm() {
    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Anda harus menyetujui Syarat & Ketentuan terlebih dahulu!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // Berhentikan proses submit jika belum dicentang
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      // Simulasi proses registrasi
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        // Tampilkan dialog sukses
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registrasi Berhasil'),
            content: Text(
              'Selamat, ${_nameController.text}!\n'
              'Email: ${_emailController.text}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetForm();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  // Reset form
  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _phoneController.clear();
    _dobController.clear();
    setState(() {
      _selectedGender = null;
      _isAgreed = false;
      _passwordStrength = 0.0;
      _passwordStrengthColor = Colors.grey;
      _passwordStrengthText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // Header
                const SizedBox(height: 16),
                const Icon(
                  Icons.person_add,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Isi form di bawah ini untuk mendaftar',
                  style: TextStyle(fontSize: 14, color: Colors.grey),

                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Field Nama
                CustomTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap Anda',
                  prefixIcon: Icons.person,
                  validator: _validateName,
                ),
                // Field Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                // Field Password
                CustomTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  hint: 'Masukkan nomor telepon',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Nomor telepon wajib diisi';
                    if (!RegExp(r'^[0-9]+$').hasMatch(value))
                      return 'Hanya boleh berisi angka';
                    if (value.length < 10 || value.length > 13)
                      return 'Nomor harus 10-13 digit';
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _dobController,
                    readOnly: true, // WAJIB TRUE: Agar keyboard tidak muncul saat diklik
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      hintText: 'Pilih tanggal lahir Anda',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(
                        0xFFFAFAFA,
                      ), // Sesuaikan dengan Colors.grey[50]
                    ),

                    // onTap adalah aksi ketika kolom ditekan
                    onTap: () async {
                      // Memunculkan popup kalender bawaan Flutter
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now(), // Tanggal awal saat kalender dibuka
                        firstDate: DateTime(
                          1900,
                        ), // Tanggal paling lampau yang bisa dipilih
                        lastDate:
                            DateTime.now(), // Tanggal paling baru (hari ini)
                      );

                      // Jika user memilih tanggal (tidak menekan cancel)
                      if (pickedDate != null) {
                        // Perbarui tampilan dengan tanggal yang dipilih
                        setState(() {
                          // Format tanggal menjadi YYYY-MM-DD
                          _dobController.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal lahir wajib diisi';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Kelamin',
                      hintText: 'Pilih jenis kelamin',
                      prefixIcon: Icon(Icons.wc),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color(0xFFFAFAFA),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Laki-laki',
                        child: Text('Laki-laki'),
                      ),
                      DropdownMenuItem(
                        value: 'Perempuan',
                        child: Text('Perempuan'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jenis kelamin wajib dipilih';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    onChanged: _checkPasswordStrength,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Minimal 8 karakter, huruf kapital, angka',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    obscureText: _obscurePassword,
                    validator: _validatePassword,
                  ),
                ),
                if (_passwordStrengthText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _passwordStrength,
                            backgroundColor: Colors.grey[300],
                            color: _passwordStrengthColor,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kekuatan Password: $_passwordStrengthText',
                          style: TextStyle(
                            color: _passwordStrengthColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                // Field Konfirmasi Password
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      hintText: 'Ulangi password Anda',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),

                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),

                      border: const OutlineInputBorder(),

                      filled: true,
                      fillColor: Colors.grey[50],
                    ),

                    obscureText: _obscureConfirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text(
                    'Saya menyetujui Syarat dan Ketentuan yang berlaku',
                    style: TextStyle(fontSize: 14),
                  ),
                  value: _isAgreed,
                  controlAffinity: ListTileControlAffinity
                      .leading, // Letak kotak centang di sebelah kiri
                  contentPadding: EdgeInsets.zero,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 24),
                // Tombol Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Daftar', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 12),
                // Tombol Reset
                OutlinedButton(
                  onPressed: _isLoading ? null : _resetForm,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
