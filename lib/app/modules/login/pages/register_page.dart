import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app/app/core/components/elevated_button_component.dart';
import 'package:task_app/app/core/components/text_field_headline_component.dart';
import 'package:task_app/app/core/ui/styles/text_styles.dart';
import 'package:task_app/app/modules/login/controllers/register_controller.dart';
import 'package:task_app/app/modules/login/pages/login_page.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final controller = Modular.get<RegisterController>();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        leading: IconButton(
          onPressed: () {
            Modular.to.pop();
          },
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 16, top: 100, right: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Registra-se',
                    style: GoogleFonts.lato(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.87),
                    ),
                  ),
                  const SizedBox(height: 62),
                  TextFieldHeadlineComponent(
                    controller: nameController,
                    headlineText: 'Nome de usuário',
                    labelText: 'Entre com seu nome de usuário',
                    validator:
                        Validatorless.required('Nome de usuário Obrigatório'),
                  ),
                  const SizedBox(height: 24),
                  TextFieldHeadlineComponent(
                    controller: emailController,
                    headlineText: 'E-mail',
                    labelText: 'Entre com seu nome email',
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
                  const SizedBox(height: 24),
                  TextFieldHeadlineComponent(
                    controller: confirmPasswordController,
                    headlineText: 'Confirmar Senha',
                    labelText: '••••••••••••',
                    validator: Validatorless.multiple([
                      Validatorless.min(4, 'O mínimo de caracteres é 4'),
                      Validatorless.required('Senha Obrigatória'),
                      Validatorless.compare(
                          passwordController, 'As senhas não coincidem')
                    ]),
                  ),
                  const SizedBox(height: 40),
                  ScopedBuilder(
                    store: controller,
                    onError: (context, error) {
                      String message = error.message;
                      if (message.contains('302')) {
                        return ElevatedButtonLogin(
                          label: 'E-mail já existe',
                          color: Colors.red.shade600,
                          onPressed: () {
                            isFormValid();
                          },
                        );
                      } else {
                        print('Error Message: $message');
                        return ElevatedButtonLogin(
                          label: 'Login falhou',
                          color: Colors.red.shade600,
                          onPressed: () => isFormValid(),
                        );
                      }
                    },
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
                    onState: (context, state) {
                      return ElevatedButtonComponent(
                        labelText: 'Registra-se',
                        onPressed: () => isFormValid(),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'já tem uma conta?',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.60),
                      ),
                    ),
                    const SizedBox(width: 2),
                    TextButton(
                      onPressed: () {
                        Modular.to.pushNamed('/');
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.compact,
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      ),
                      child: Text(
                        'Conecte-se',
                        style: TextStyles.instance.label.copyWith(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  isFormValid() {
    final isValid = _formKey.currentState?.validate() ?? false;
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    if (isValid) {
      controller.register(name, email, password);
    }
  }
}
