import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isPhoneLogin = false;
  bool _isOtpStep = false;
  String _selectedCountryCode = '+966';
  String? _errorMessage;

  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  final List<Map<String, String>> _countryCodes = [
    {'code': '+966', 'flag': '🇸🇦'},
    {'code': '+971', 'flag': '🇦🇪'},
    {'code': '+20', 'flag': '🇪🇬'},
    {'code': '+965', 'flag': '🇰🇼'},
    {'code': '+974', 'flag': '🇶🇦'},
    {'code': '+973', 'flag': '🇧🇭'},
    {'code': '+968', 'flag': '🇴🇲'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _errorMessage = null;
    });

    if (!_isPhoneLogin) {
      if (_emailController.text.isEmpty ||
          !_emailController.text.contains('@')) {
        setState(() {
          _errorMessage = 'يرجى إدخال بريد إلكتروني صحيح.';
        });
        return;
      }
      if (_passwordController.text.isEmpty ||
          _passwordController.text.length < 6) {
        setState(() {
          _errorMessage = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل.';
        });
        return;
      }
      context.read<AuthBloc>().add(
            LoginWithEmailEvent(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    } else {
      if (_phoneController.text.isEmpty ||
          _phoneController.text.length < 8 ||
          !RegExp(r'^\d+$').hasMatch(_phoneController.text)) {
        setState(() {
          _errorMessage =
              'يرجى إدخال رقم جوال صحيح (أرقام فقط، 8 خانات على الأقل).';
        });
        return;
      }
      setState(() {
        _isOtpStep = true;
      });
    }
  }

  void _handleVerifyOtp() {
    setState(() {
      _errorMessage = null;
    });

    String otp = _otpControllers.map((c) => c.text).join();
    if (otp == '0000') {
      context.read<AuthBloc>().add(
            LoginWithPhoneEvent(
              phone: '$_selectedCountryCode${_phoneController.text}',
            ),
          );
    } else {
      setState(() {
        _errorMessage = 'كود التحقق غير صحيح (استخدم 0000).';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // zinc-50
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('مرحباً بك ${state.user.name}')),
            );
            // هنا يتم الانتقال للصفحة الرئيسية
          } else if (state is AuthError) {
            setState(() {
              _errorMessage = state.message;
            });
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isOtpStep ? _buildOtpScreen() : _buildInputScreen(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputScreen() {
    return Container(
      key: const ValueKey('input_screen'),
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF18181B), // zinc-900
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18181B).withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(LucideIcons.shoppingBag,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'مرحباً بك',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18181B)),
          ),
          const SizedBox(height: 8),
          const Text(
            'سجل دخولك للمتابعة في متجر النخبة',
            style:
                TextStyle(color: Color(0xFF71717A), fontSize: 16), // zinc-500
          ),
          const SizedBox(height: 40),

          // Toggle Switch
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F5), // zinc-100
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPhoneLogin = false;
                        _errorMessage = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            !_isPhoneLogin ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: !_isPhoneLogin
                            ? [
                                const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1))
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          'البريد الإلكتروني',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: !_isPhoneLogin
                                ? const Color(0xFF18181B)
                                : const Color(0xFF71717A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPhoneLogin = true;
                        _errorMessage = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            _isPhoneLogin ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _isPhoneLogin
                            ? [
                                const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 2,
                                    offset: Offset(0, 1))
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          'رقم الجوال',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _isPhoneLogin
                                ? const Color(0xFF18181B)
                                : const Color(0xFF71717A),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2), // red-50
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFEE2E2)), // red-100
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500), // red-500
                textAlign: TextAlign.center,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Forms
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isPhoneLogin ? _buildPhoneForm() : _buildEmailForm(),
          ),

          const SizedBox(height: 24),

          // Login Button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state is AuthLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18181B), // zinc-900
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: state is AuthLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          _isPhoneLogin ? 'إرسال كود التحقق' : 'تسجيل الدخول',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpScreen() {
    return Container(
      key: const ValueKey('otp_screen'),
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!.withOpacity(0.5),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isOtpStep = false;
                  _errorMessage = null;
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(LucideIcons.arrowRight,
                      size: 20, color: Color(0xFF71717A)),
                  SizedBox(width: 8),
                  Text('رجوع',
                      style: TextStyle(color: Color(0xFF71717A), fontSize: 16)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF18181B),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF18181B).withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(LucideIcons.shoppingBag,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 24),
          const Text(
            'تأكيد الرقم',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18181B)),
          ),
          const SizedBox(height: 8),
          Text(
            'أدخل الكود المرسل إلى : $_selectedCountryCode $_phoneController.text',
            style: const TextStyle(color: Color(0xFF71717A), fontSize: 16),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
          const SizedBox(height: 40),

          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
          ],

          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 56,
                  height: 64,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _otpFocusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: const Color(0xFFFAFAFA),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[200]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF18181B), width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _otpFocusNodes[index + 1].requestFocus();
                      }
                      if (_errorMessage != null) {
                        setState(() {
                          _errorMessage = null;
                        });
                      }
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 40),

          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state is AuthLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18181B),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: state is AuthLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('تحقق',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              );
            },
          ),

          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('لم يصلك الكود؟ ',
                  style: TextStyle(color: Color(0xFF71717A), fontSize: 14)),
              GestureDetector(
                onTap: () {},
                child: const Text('إعادة إرسال',
                    style: TextStyle(
                        color: Color(0xFF18181B),
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneForm() {
    return Container(
      key: const ValueKey('phone_form'),
      child: Row(
        children: [
          Container(
            width: 110,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                icon: const Icon(LucideIcons.chevronDown,
                    color: Color(0xFFA1A1AA), size: 16),
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: _countryCodes.map((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Text('${country['flag']} ${country['code']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountryCode = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  hintText: '5X XXX XXXX',
                  hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
                  prefixIcon: const Icon(LucideIcons.phone,
                      color: Color(0xFFA1A1AA), size: 20),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      key: const ValueKey('email_form'),
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'البريد الإلكتروني',
              hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
              prefixIcon: const Icon(LucideIcons.mail,
                  color: Color(0xFFA1A1AA), size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'كلمة المرور',
              hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
              prefixIcon: const Icon(LucideIcons.lock,
                  color: Color(0xFFA1A1AA), size: 20),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
