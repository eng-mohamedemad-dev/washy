import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_flutter/core/constants/app_colors.dart';
import 'package:wash_flutter/core/utils/email_validator.dart';
import 'package:wash_flutter/features/auth/domain/entities/user.dart' show User, AccountStatus, LoginType;
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_bloc.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_event.dart';
import 'package:wash_flutter/features/auth/presentation/bloc/email/email_state.dart';
import 'package:wash_flutter/features/auth/presentation/pages/verification_page.dart';
import 'package:wash_flutter/features/auth/presentation/pages/password_page.dart';

/// EmailPage - Exactly matches Java activity_email.xml
class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isEmailValid = false;
  String? _validationMessage;
  // إدارة إظهار/إخفاء حوار التحميل لتجنب الرجوع غير المقصود للصفحة
  // تم استبداله بطبقة تحميل داخلية
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _emailFocusNode.requestFocus();
      }
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _isEmailValid = false;
        _validationMessage = null;
      } else if (EmailValidator.isValidEmail(email)) {
        _isEmailValid = true;
        _validationMessage = null;
      } else {
        _isEmailValid = false;
        _validationMessage = 'البريد الإلكتروني غير صحيح';
      }
    });
  }

  void _onSendCodePressed() {
    if (_isEmailValid) {
      // أولاً نفحص الإيميل لمعرفة حالة الحساب كما في الجافا
      context.read<EmailBloc>().add(
            CheckEmailEvent(email: _emailController.text),
          );
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<EmailBloc, EmailState>(
        listener: (context, state) {
          // إدارة حالة التحميل بطبقة داخلية بدل showDialog لتفادي تراكُم الحوارات
          if (state is EmailLoading) {
            if (!_isLoading) {
              setState(() => _isLoading = true);
              print('[EmailPage] Showing inline loading overlay');
            }
          } else if (state is! NavigateToPassword && state is! EmailCodeSent) {
            if (_isLoading) {
              setState(() => _isLoading = false);
              print('[EmailPage] Hiding inline loading overlay');
            }
          }

          // Handle specific states بعد إدارة التحميل
          if (state is EmailChecked) {
            final status = state.user.accountStatus;
            print('[EmailPage] EmailChecked with status: ${status.name}');
            if (status.name == 'newCustomer') {
              // أرسل كود التحقق للمستخدم الجديد
              context.read<EmailBloc>().add(
                    SendEmailCodeEvent(email: _emailController.text),
                  );
            } else if (status.name == 'notVerifiedCustomer') {
              // مستخدم غير مفعّل: أرسل الكود
              context.read<EmailBloc>().add(
                    SendEmailCodeEvent(email: _emailController.text),
                  );
            } else if (status.name == 'enterPassword' || status.name == 'verifiedCustomer') {
              // مستخدم موجود: انتقل لصفحة كلمة المرور
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PasswordPage(
                    user: state.user,
                    isNewUser: false,
                  ),
                ),
              );
            }
          } else if (state is EmailCodeSent) {
            // الانتقال إلى صفحة التحقق
            print('[EmailPage] Code sent, navigating to verification page');
            if (_isLoading) setState(() => _isLoading = false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VerificationPage(
                    identifier: state.email,
                    isPhone: false,
                  ),
                ),
              );
            });
          } else if (state is NavigateToPassword) {
            // fallback للانتقال إلى كلمة السر
            if (_isLoading) setState(() => _isLoading = false);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              final mockUser = User(
                id: 'temp',
                name: '',
                email: state.email,
                phoneNumber: '',
                token: '',
                accountStatus: AccountStatus.verifiedCustomer,
                loginType: LoginType.email,
              );
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => PasswordPage(user: mockUser, isNewUser: false),
                ),
                (route) => false,
              );
            });
          } else if (state is EmailError) {
            print('[EmailPage] Error: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.colorRedError),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Column(
            children: [
              // Back button at top (from layout_back_icon_black)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _goBack,
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Main Content (from LinearLayout starting at line 9)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        // Welcome Text (line 15-29)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Text(
                            'أهلاً و سهلأ! أدخل الايميل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.colorTitleBlack,
                              height: 1.3,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Email Icon (line 31-36)
                        Image.asset(
                          'assets/images/email_icon.png',
                          width: 161,
                          height: 85,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 161,
                              height: 85,
                              decoration: const BoxDecoration(
                                color: AppColors.washyBlue,
                                shape: BoxShape.rectangle,
                              ),
                              child: const Icon(
                                Icons.email_outlined,
                                size: 60,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // Email Input Section (RelativeLayout 38-83)
                        Stack(
                          children: [
                            // Email TextField (line 46-63)
                            Center(
                              child: Container(
                                width: double.infinity,
                                constraints:
                                    const BoxConstraints(maxWidth: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'الايميل ',
                                    hintStyle: TextStyle(
                                      color: AppColors.colorLoginText,
                                      fontSize: 16,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            // Clear button (X) should be above the left arrow like Java (left side)
                            if (_emailController.text.isNotEmpty)
                              Positioned(
                                left: 30,
                                top: 15,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _emailController.clear();
                                    });
                                  },
                                  child: Image.asset(
                                    'assets/images/ic_cancel.png',
                                    width: 13,
                                    height: 13,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.close,
                                        size: 13,
                                        color: Colors.black54,
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Separator, Validation, and Continue Button (RelativeLayout 85-122)
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _emailController,
                          builder: (context, value, child) {
                            return Column(
                              children: [
                                // Separator line (line 90-96)
                                Container(
                                  width: 250,
                                  height: 1,
                                  color: AppColors.colorViewSeparators,
                                ),

                                const SizedBox(height: 8),

                                // Validation message (line 98-108)
                                if (_validationMessage != null)
                                  Text(
                                    _validationMessage!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.colorRedError,
                                    ),
                                  )
                                else
                                  const SizedBox(height: 0),

                                const SizedBox(height: 6),

                                // زر السهم الأخضر: يظهر عند التركيز أو وجود كتابة، والتفعيل فقط عند صحة الإيميل
                                if (_emailFocusNode.hasFocus ||
                                    value.text.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        width: 56,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: _isEmailValid
                                              ? _onSendCodePressed
                                              : null,
                                          style: ButtonStyle(
                                            shape:
                                                const MaterialStatePropertyAll(
                                                    CircleBorder()),
                                            elevation:
                                                const MaterialStatePropertyAll(
                                                    0),
                                            padding:
                                                const MaterialStatePropertyAll(
                                                    EdgeInsets.zero),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) {
                                              final isDisabled =
                                                  states.contains(
                                                      MaterialState.disabled);
                                              return isDisabled
                                                  ? AppColors.washyGreen
                                                      .withOpacity(0.5)
                                                  : AppColors.washyGreen;
                                            }),
                                            foregroundColor:
                                                MaterialStateProperty
                                                    .resolveWith((states) {
                                              final isDisabled =
                                                  states.contains(
                                                      MaterialState.disabled);
                                              return isDisabled
                                                  ? Colors.white70
                                                  : Colors.white;
                                            }),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_back,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
              if (_isLoading) ...[
                const ModalBarrier(dismissible: false, color: Colors.black26),
                const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.washyBlue),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }
}
