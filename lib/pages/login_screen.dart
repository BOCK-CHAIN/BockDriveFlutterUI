import 'package:flutter/material.dart';
import 'desktop_drive.dart';
import 'mobile_drive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Dark Purple Theme Colors
  static const Color primaryPurple = Color(0xFF6A1B9A);
  static const Color darkPurple = Color(0xFF4A148C);
  static const Color lightPurple = Color(0xFF8E24AA);
  static const Color accentPurple = Color(0xFFAB47BC);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color borderColor = Color(0xFF3C3C3C);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Simple validation without Firebase
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Simple validation - you can customize this logic
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isLogin) {
        // For demo: accept any valid email/password combination
        if (_isValidEmail(email) && _isValidPassword(password)) {
          _navigateToAppropriateScreen();
        } else {
          throw Exception('Invalid email or password');
        }
      } else {
        // For sign up: just check if email is valid and password is strong enough
        if (_isValidEmail(email) && _isValidPassword(password)) {
          _navigateToAppropriateScreen();
        } else {
          throw Exception('Please check your email and password requirements');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToAppropriateScreen() {
    if (mounted) {
      final screenWidth = MediaQuery.of(context).size.width;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => screenWidth >= 768 
              ? const DesktopDrive() 
              : const MobileDrive(),
        ),
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email address first.';
      });
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset link sent to ${_emailController.text.trim()}'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _errorMessage = null;
    });
    
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 768;
    
    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 24),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 400 : double.infinity,
                  ),
                  child: Card(
                    color: cardDark,
                    elevation: 8,
                    shadowColor: primaryPurple.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 32),
                          _buildForm(),
                          const SizedBox(height: 24),
                          _buildActionButton(),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            _buildErrorMessage(),
                          ],
                          const SizedBox(height: 24),
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple, lightPurple, accentPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryPurple.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.cloud_outlined,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'BockDrive',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isLogin ? 'Welcome back!' : 'Join BockDrive today',
          style: TextStyle(
            fontSize: 16,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          if (_isLogin) ...[
            const SizedBox(height: 8),
            _buildForgotPasswordButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(Icons.email_outlined, color: textSecondary),
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!_isValidEmail(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: textSecondary),
        prefixIcon: Icon(Icons.lock_outline, color: textSecondary),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: textSecondary,
          ),
        ),
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (!_isLogin && !_isValidPassword(value)) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: accentPurple,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: primaryPurple.withOpacity(0.6),
        ),
        child: _isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                _isLogin ? 'Sign In to BockDrive' : 'Create BockDrive Account',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: borderColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(color: textSecondary),
              ),
            ),
            Expanded(child: Divider(color: borderColor)),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _toggleMode,
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: textSecondary, fontSize: 14),
              children: [
                TextSpan(
                  text: _isLogin 
                      ? "New to BockDrive? " 
                      : "Already have a BockDrive account? ",
                ),
                TextSpan(
                  text: _isLogin ? 'Sign Up' : 'Sign In',
                  style: TextStyle(
                    color: accentPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}