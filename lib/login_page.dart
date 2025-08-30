import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme.dart';
import 'onboarding_page.dart';
import 'tasks_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  // Visibility flags
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _loginPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // refresh UI when switching tabs
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDF0FE),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 50),

            /// Logo
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/todo_blue.jpg',
                width: 300,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            /// Tabs + Forms in CENTERED container
            Expanded(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.black,
                        unselectedLabelColor: AppColors.grey,
                        labelStyle: AppTextStyles.headline,
                        unselectedLabelStyle: AppTextStyles.headline,
                        indicatorColor: Colors.transparent,
                        tabs: const [
                          Tab(text: "Sign Up"),
                          Tab(text: "Login"),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Forms
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            /// ------- SIGN UP -------
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: AppInputDecoration.textField(hint: "Email"),
                                    style: AppTextStyles.body,
                                    validator: (val) =>
                                    val == null || val.isEmpty ? "Enter email" : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: !_passwordVisible,
                                    decoration: AppInputDecoration.textField(
                                      hint: "Password",
                                      showPasswordToggle: true,
                                      passwordVisible: _passwordVisible,
                                      onTogglePassword: () {
                                        setState(() => _passwordVisible = !_passwordVisible);
                                      },
                                    ),
                                    style: AppTextStyles.body,
                                    validator: (val) =>
                                    val != null && val.length < 6 ? "Password too short" : null,
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: !_confirmPasswordVisible,
                                    decoration: AppInputDecoration.textField(
                                      hint: "Confirm Password",
                                      showPasswordToggle: true,
                                      passwordVisible: _confirmPasswordVisible,
                                      onTogglePassword: () {
                                        setState(() =>
                                        _confirmPasswordVisible = !_confirmPasswordVisible);
                                      },
                                    ),
                                    style: AppTextStyles.body,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Confirm your password";
                                      }
                                      if (val != _passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),

                            /// ------- LOGIN -------
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: _loginEmailController,
                                  decoration: AppInputDecoration.textField(
                                    hint: "Email",
                                    suffix: _loginEmailController.text.isNotEmpty
                                        ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppColors.grey),
                                      onPressed: () {
                                        _loginEmailController.clear();
                                        setState(() {});
                                      },
                                    )
                                        : null,
                                  ),
                                  style: AppTextStyles.body,
                                  validator: (val) =>
                                  val == null || val.isEmpty ? "Enter email" : null,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _loginPasswordController,
                                  obscureText: !_loginPasswordVisible,
                                  decoration: AppInputDecoration.textField(
                                    hint: "Password",
                                    showPasswordToggle: true,
                                    passwordVisible: _loginPasswordVisible,
                                    onTogglePassword: () {
                                      setState(() =>
                                      _loginPasswordVisible = !_loginPasswordVisible);
                                    },
                                  ),
                                  style: AppTextStyles.body.copyWith(fontSize: 20),
                                  validator: (val) =>
                                  val == null || val.isEmpty ? "Enter password" : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ------- Button -------
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _tabController.index == 1
                      ? AppColors.loginGreen
                      : AppColors.signupGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: const BorderSide(color: AppColors.black),
                  ),
                  elevation: 0,
                ),
                onPressed: _handleAuth,
                child: Text(
                  _tabController.index == 1 ? "Login" : "Sign Up",
                  style: GoogleFonts.interTight(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (_tabController.index == 1) {
      // LOGIN
      final email = _loginEmailController.text.trim();
      final pass = _loginPasswordController.text.trim();

      if (email.isEmpty || pass.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")),
        );
        return;
      }

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TasksPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Login failed")),
        );
      }
    } else {
      // SIGN UP
      if (!_formKey.currentState!.validate()) return;

      final email = _emailController.text.trim();
      final pass = _passwordController.text.trim();
      final confirm = _confirmPasswordController.text.trim();

      if (pass != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords don't match")),
        );
        return;
      }

      try {
        final userCred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass);

        await FirebaseFirestore.instance.collection("users").doc(userCred.user!.uid).set({
          "email": email,
          "createdTime": FieldValue.serverTimestamp(),
        });

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingPage()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Sign up failed")),
        );
      }
    }
  }
}




