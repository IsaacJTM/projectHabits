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
      print('ERROR REAL DE FIREBASE: $e');
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
                ),
                const SizedBox(height: 24),
                if(_isRegisterMode)...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      filled: false,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder()
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingrese tu nombre': null,
                  )
                ],
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder()
                  ),
                  validator: (v) => (v == null || !v.contains('@')) ? 'Correo invalido': null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder()
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Mínimo 6 caracteres': null,
                ),
                if(_errorMessage != null)...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.secondary),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null: _submit, 
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8)
                        )
                    ),
                    child: _isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:  CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2,
                          ),
                        )
                      : Text(_isRegisterMode ? 'Registrate' : 'Iniciar Sesión'),    
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isRegisterMode = !_isRegisterMode), 
                  child: Text(_isRegisterMode 
                  ? '¿Ya tienes cuenta? Inicia Sesión'
                  : '¿No tienes cuenta? Regístrate')
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}