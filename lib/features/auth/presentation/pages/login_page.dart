import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_input_screen.dart';
import '../widgets/otp_screen.dart';

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

  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
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
      if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
        setState(() {
          _errorMessage = 'يرجى إدخال بريد إلكتروني صحيح.';
        });
        return;
      }
      if (_passwordController.text.isEmpty || _passwordController.text.length < 6) {
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
      if (_phoneController.text.isEmpty || _phoneController.text.length < 8 || !RegExp(r'^\d+$').hasMatch(_phoneController.text)) {
        setState(() {
          _errorMessage = 'يرجى إدخال رقم جوال صحيح (أرقام فقط، 8 خانات على الأقل).';
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

  void _handleToggleLoginType(bool isPhone) {
    setState(() {
      _isPhoneLogin = isPhone;
      _errorMessage = null;
    });
  }

  void _handleBackFromOtp() {
    setState(() {
      _isOtpStep = false;
      _errorMessage = null;
      for (var controller in _otpControllers) {
        controller.clear();
      }
    });
  }

  void _handleCountryCodeChanged(String code) {
    setState(() {
      _selectedCountryCode = code;
    });
  }

  void _handleOtpChanged(String? value) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F5), // zinc-100
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('مرحباً بك ${state.user.name}')),
            );
            // Navigate to home page
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
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _isOtpStep 
                ? OtpScreen(
                    onBack: _handleBackFromOtp,
                    selectedCountryCode: _selectedCountryCode,
                    phoneNumber: _phoneController.text,
                    errorMessage: _errorMessage,
                    onVerify: _handleVerifyOtp,
                    otpControllers: _otpControllers,
                    otpFocusNodes: _otpFocusNodes,
                    onOtpChanged: _handleOtpChanged,
                  ) 
                : LoginInputScreen(
                    isPhoneLogin: _isPhoneLogin,
                    onToggleLoginType: _handleToggleLoginType,
                    errorMessage: _errorMessage,
                    onLogin: _handleLogin,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    phoneController: _phoneController,
                    selectedCountryCode: _selectedCountryCode,
                    countryCodes: _countryCodes,
                    onCountryCodeChanged: _handleCountryCodeChanged,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
