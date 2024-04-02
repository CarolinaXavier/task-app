import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/components/elevated_button_component.dart';
import 'package:task_app/app/core/components/text_field_headline_component.dart';
import 'package:task_app/app/core/ui/styles/colors_app.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/login/controllers/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final controller = Modular.get<LoginController>();

  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 122, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conecte-se',
                    style: GoogleFonts.lato(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: context.colors.secondary,
                    ),
                  ),
                  const SizedBox(height: 62),
                  TextFieldHeadlineComponent(
                    controller: nameController,
                    headlineText: 'E-mail',
                    labelText: 'Entre com seu email',
                    validator: Validatorless.multiple([
                      Validatorless.email('E-mail Inválido'),
                      Validatorless.required('E-mail Obrigatório'),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  TextFieldHeadlineComponent(
                    controller: passwordController,
                    headlineText: 'Senha',
                    labelText: '••••••••••••',
                    validator: Validatorless.multiple([
                      Validatorless.min(4, 'O mínimo de caracteres é 4'),
                      Validatorless.required('Senha Obrigatória'),
                    ]),
                  ),
                  const SizedBox(height: 40),
                  ScopedBuilder(
                    store: controller,
                    onLoading: (context) {
                      return const ElevatedButtonLogin(
                        label: '',
                        onPressed: null,
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                    onError: (context, error) {
                      String message = error.message;
                      if (message.contains('401')) {
                        return ElevatedButtonLogin(
                          label: 'Não autorizado',
                          color: Colors.red.shade600,
                          onPressed: () {
                            isFormValid();
                          },
                        );
                      } else {
                        print('Error Message: $message');
                        return  ElevatedButtonLogin(
                          label: 'Login falhou',
                          color: Colors.red.shade600,
                          onPressed: () => isFormValid(),
                        );
                      }
                    },
                    onState: (context, state) {
                      return ElevatedButtonComponent(
                        labelText: 'Entrar',
                        onPressed: () => isFormValid(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta?',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.60),
                    ),
                  ),
                  const SizedBox(width: 2),
                  TextButton(
                    onPressed: () {
                      Modular.to.pushNamed('./register-page');
                    },
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    ),
                    child: Text(
                      'Registrar',
                      style: TextStyles.instance.label.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  isFormValid() {
    final isValid = _formKey.currentState?.validate() ?? false;
    String name = nameController.text;
    String password = passwordController.text;
    if (isValid) {
      controller.login(name, password);
    }
  }
}

class ElevatedButtonLogin extends StatelessWidget {
  final String label;
  final Widget? child;
  final Function()? onPressed;
  final Color? color;
  const ElevatedButtonLogin(
      {required this.label, required this.onPressed, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              color ?? context.colors.primary,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
          onPressed: onPressed,
          child: child ??
              Text(
                label,
                style: TextStyles.instance.label.copyWith(color: Colors.white),
              ),
        ),
      ),
    );
  }
}
