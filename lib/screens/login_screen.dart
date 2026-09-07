import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _api = ApiService();
  final _storage = StorageService();
  bool loading = false;
  bool obscure = true;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    try {
      final success = await _api.login(_email.text, _password.text);
      if (!success) throw Exception('Invalid credentials');
      await _storage.setLoggedIn(true);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void dispose() { _email.dispose(); _password.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const SizedBox(height: 18),
                const Text('Login', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 34),
                TextFormField(
				controller: _email, 
				keyboardType: TextInputType.emailAddress,
				decoration: const InputDecoration(
				labelText: 'Email / Mobile', 
				prefixIcon: Icon(Icons.person)
				), 
				validator: (v) => v == null || v.trim().isEmpty ? 'Enter email or mobile' : null),
                const SizedBox(height: 16),
                TextFormField(
				controller: _password,
				obscureText: obscure,
				decoration: InputDecoration(
				labelText: 'Password', 
				prefixIcon: const Icon(Icons.lock),
				suffixIcon: IconButton(
				icon: Icon(obscure ? Icons.visibility : Icons.visibility_off), 
				onPressed: () => setState(() => obscure = !obscure))),
				validator: (v) => v == null || v.length < 8 ? 'Minimum 8 characters' : null),
                const SizedBox(height: 24),
                SizedBox(
				height: 52,
				child: FilledButton(
				onPressed: loading ? null : login,
				child: loading ? const SizedBox(
				width: 22, height: 22, 
				child: CircularProgressIndicator(strokeWidth: 2)) : const Text('LOGIN'))
				),
                const SizedBox(height: 12),
                const Text('Rules: enter any dummy email/mobile and  password of 8+ characters',
				textAlign: TextAlign.center, 
				style: TextStyle(
				fontSize: 12, 
				color: Colors.grey)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
