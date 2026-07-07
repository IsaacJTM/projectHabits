import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:apphabitsv01/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _fromKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isRegisterMode = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    if(!_fromKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try{
      final repo = ref.read(authRepositoryProvider);
      if(_isRegisterMode){
        await repo.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }else{
        await repo.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }
    }on Exception catch(e){
      setState(() => _errorMessage = _friendlyError(e));
    }finally{
      if(mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(Exception e){
    final msg = e.toString();
    if(msg.contains('user-not-found') || msg.contains('wrong-password') || msg.contains('invalid-credential')){
      return 'Correo o contraseña incorrectos';
    }
    if (msg.contains('email-already-in-use')) {
      return 'Ese correo ya está registrado.';
    }
    if (msg.contains('weak-password')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _fromKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 35),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  _isRegisterMode ? 'Crea una cuenta ' : 'Bienvenido de nuevo',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 4),
                Text(
                  'Construye tus hábitos, un día a la vez',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}