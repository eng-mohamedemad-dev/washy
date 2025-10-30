import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/password/password_state.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart';
import 'package:wash_flutter/features/auth/domain/usecases/send_verification_code.dart';
import 'package:wash_flutter/injection_container.dart' as di;
import 'package:wash_flutter/features/auth/presentation/pages/email_page.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';

/// PasswordPage - Replicates Java PasswordActivity 100%
class PasswordPage extends StatefulWidget {
  final User user;
  final bool isNewUser;

  const PasswordPage({
    super.key,
    required this.user,
    this.isNewUser = false,
  });

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void _onContinuePressed() {
    final state = context.read<PasswordBloc>().state as PasswordInitial;
    
    if (state.isNewUser) {
      context.read<PasswordBloc>().add(
        SetPasswordPressed(
          password: _passwordController.text,
          user: widget.user,
        ),
      );
    } else {
      context.read<PasswordBloc>().add(
        LoginWithPasswordPressed(
          password: _passwordController.text,
          user: widget.user,
        ),
      );
    }
  }

  void _onForgetPasswordPressed() {
    context.read<PasswordBloc>().add(
      ForgetPasswordPressed(user: widget.user),
    );
  }

  void _onTogglePasswordVisibility() {
    context.read<PasswordBloc>().add(TogglePasswordVisibility());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordBloc(
        // نأخذ الـ UseCase مباشرةً من getIt بدلاً من Provider لتجنب ProviderNotFound
        sendVerificationCode: di.getIt<SendVerificationCode>(),
        user: widget.user,
        isNewUser: widget.isNewUser,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<PasswordBloc, PasswordState>(
          listener: (context, state) {
            if (state is PasswordLoading) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
            } else {
              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              if (state is PasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            }
          },
          builder: (context, state) {
            final passwordValue = _passwordController.text;
            final bool canContinue = passwordValue.length >= 6;
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // زر السهم أعلى اليمين
                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 0, end: 8, top: 18, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward, size: 30, color: Color(0xFF455869)),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider(
                                          create: (_) => di.getIt<EmailBloc>(),
                                          child: const EmailPage(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          // العناوين
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: const [
                                Text(
                                  'أهلاً و سهلاً من جديد!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 29,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF455869),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'سجل الدخول للمتابعة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Color(0xFF455869),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // صورة القفل (استبدلها بصورة جافا إذا توفرت)
                          Center(
                            child: Container(
                              width: 150,
                              height: 135,
                              padding: const EdgeInsets.all(10),
                              child: Icon(Icons.lock_outline, size: 100, color: Color(0xFF41d99e)),
                            ),
                          ),
                          const SizedBox(height: 34),
                          // حقل كلمة السر
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: BlocBuilder<PasswordBloc, PasswordState>(
                              builder: (context, state) {
                                final bool obscure = state is PasswordInitial ? !state.isPasswordVisible : true;
                                final String? validationMessage = state is PasswordInitial ? state.validationMessage : null;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocusNode,
                                      obscureText: obscure,
                                      style: const TextStyle(fontSize: 19),
                                      onChanged: (val) {
                                        context.read<PasswordBloc>().add(PasswordChanged(password: val));
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'كلمة السر',
                                        hintStyle: const TextStyle(color: Color(0xFFBFC0C8), fontSize: 17, fontWeight: FontWeight.w500),
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF41d99e), width: 2.2),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF41d99e), width: 3.0),
                                        ),
                                        border: const UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFF41d99e)),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscure ? Icons.visibility : Icons.visibility_off,
                                            color: const Color(0xFFA1AAB3),
                                          ),
                                          onPressed: () {
                                            context.read<PasswordBloc>().add(TogglePasswordVisibility());
                                          },
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    if (validationMessage != null) ...[
                                      const SizedBox(height: 13),
                                      Text(
                                        validationMessage,
                                        style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    const SizedBox(height: 18),
                                    // زر السهم المتابعة أسفل الحقل، وليس بالمنتصف!
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: canContinue
                                              ? () {
                                                  final passwordState = state as PasswordInitial;
                                                  context.read<PasswordBloc>().add(
                                                        LoginWithPasswordPressed(
                                                            password: _passwordController.text, user: passwordState.user),
                                                      );
                                                }
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            elevation: 0,
                                            backgroundColor: canContinue
                                                ? const Color(0xFF92e068)
                                                : const Color(0xFF92e068).withOpacity(0.3),
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: const Icon(Icons.arrow_back, size: 26, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 34),
                                    GestureDetector(
                                      onTap: () {
                                        final passwordState = state as PasswordInitial;
                                        context.read<PasswordBloc>().add(ForgetPasswordPressed(user: passwordState.user));
                                      },
                                      child: const Text(
                                        'نسيت كلمة السر',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF345869),
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
