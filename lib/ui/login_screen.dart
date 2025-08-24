import 'package:flutter/material.dart';
import 'package:marworx_flutter_task/Services/firebase_auth_services.dart';
import 'package:marworx_flutter_task/Ui/admin_dashboard.dart';
import 'package:marworx_flutter_task/Widget/toglebutton.dart';
import 'package:marworx_flutter_task/ui/employ_dashboard.dart';
import 'package:marworx_flutter_task/widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // toggle flag button
  bool _flag = true;

  // Controllers
  final TextEditingController _adminLoginController = TextEditingController();
  final TextEditingController _adminPassController = TextEditingController();
  final TextEditingController _employeeLoginController = TextEditingController();
  final TextEditingController _employeePassController = TextEditingController();

  //login as admin

  void _login() {
    final email = _adminLoginController.text.trim();
    final pass = _adminPassController.text.trim();

    if (email == "admin@gmail.com" && pass == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid credentials")));
    }
  }

  // create employ
  Future<void> _registerEmployee(String email, String pass) async {
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email & password")),
      );
      return;
    }

    try {
      final user = await _authService.registerEmployee(email, pass);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee Registered Successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  //login  employ sathi

  final AuthService _authService = AuthService();

  Future<void> _loginEmployee() async {
    final email = _employeeLoginController.text.trim();
    final pass = _employeePassController.text.trim();

    try {
      final user = await _authService.loginEmployee(email, pass);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee Login Successful")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmployDashboard()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  //new employ sathi
  void _showRegisterDialog() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create New Employee"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  hintText: "PassWord >5 char",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                final pass = passController.text.trim();
                Navigator.pop(context);
                _registerEmployee(email, pass);
              },
              child: const Text("Register"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: size.width * 0.85,
            height: size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleButton(
                      title: "Admin",
                      isSelected: _flag,
                      onTap: () {
                        setState(() => _flag = true);
                      },
                    ),
                    const SizedBox(width: 20),
                    ToggleButton(
                      title: "Employee",
                      isSelected: !_flag,
                      onTap: () {
                        setState(() => _flag = false);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: _flag ? _adminLoginController : _employeeLoginController,
                  labelText: _flag ? "Admin Username" : "Employee Username",
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _flag ? _adminPassController : _employeePassController,
                  labelText: _flag ? "Admin Password" : "Employee PassWord",
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                // Login button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55), // full width
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  onPressed: () {
                    if (_flag) {
                      _login();
                    } else {
                      _loginEmployee();
                    }
                  },
                  child: const Text(
                    "Login ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                !_flag
                    ? GestureDetector(
                        onTap: _showRegisterDialog,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "Create New Employee",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
