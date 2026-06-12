import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:rede_campo_online/app/router.dart';
import 'package:rede_campo_online/core/global/injection.dart';
import 'package:rede_campo_online/core/ui/buttons/custom_button.dart';
import 'package:rede_campo_online/core/ui/forms/custom_text_field.dart';
import 'package:rede_campo_online/core/ui/theme/custom_colors.dart';
import 'package:rede_campo_online/core/utils/formatters.dart';
import 'package:rede_campo_online/features/login/stores/login_store.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final loginStore = getIt<LoginStore>();

  @override
  void initState() {
    super.initState();
    loginStore.clearError();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await loginStore.submit(
      _emailController.text,
      _passwordController.text,
    );
    if (ok && mounted) context.go(AppRoutes.admin);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'E-mail',
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final v = value?.trim() ?? '';
              if (v.isEmpty) return 'Informe o e-mail';
              if (!v.isEmailValid()) return 'E-mail inválido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Observer(
            builder: (_) => CustomTextField(
              label: 'Senha',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: loginStore.obscurePassword,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                icon: Icon(
                  loginStore.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: CustomColors.midnight_slate.withOpacity(0.45),
                  size: 20,
                ),
                onPressed: loginStore.togglePasswordVisibility,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Informe a senha';
                return null;
              },
              onFieldSubmitted: (_) {
                if (!loginStore.loading) _handleSubmit();
              },
            ),
          ),
          Observer(
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (loginStore.errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: CustomColors.danger_surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFCCC7)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: CustomColors.danger_red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            loginStore.errorMessage!,
                            style: const TextStyle(
                              color: CustomColors.danger_red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                if (loginStore.loading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.copper_spice,
                      strokeWidth: 2.5,
                    ),
                  )
                else
                  CustomButton(
                    width: double.infinity,
                    color: CustomColors.copper_spice,
                    text: 'Entrar',
                    textColor: Colors.white,
                    borderRadius: 10,
                    function: _handleSubmit,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
