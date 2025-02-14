import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return CircularProgressIndicator();
            }
            // if (state is Authenticated) {
            //   return Text("Usuario autenticado: ${state.userId}");
            // }
            return ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignInAnonymouslyEvent());
              },
              child: Text("Iniciar Sesión Anónimamente"),
            );
          },
        ),
      ),
    );
  }
}
