import 'package:flutter/material.dart';
import 'package:todolist/auth/signup_page.dart';
import 'package:todolist/services/auth_service.dart';
import 'package:todolist/todo_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool loading = false;

  final authservice = AuthService();

  Future<void> login() async {
    setState(() {
      loading = true;
    });
    try {
      final user = await authservice.loginWithEmail(
        email: emailController.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      if (user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TodoList()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
              color: Colors.yellow,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  Text("Welcome Back", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 29),),

                  const SizedBox(height:20),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(),),
                  ),

                  const SizedBox(height: 25,),
                      
                  TextField(
                    controller: passwordcontroller,
                    decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                  ),
                      
                  const SizedBox(height: 45),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: loading ? null : login,
                    child: loading
                        ? CircularProgressIndicator()
                        : const Text("Login"),
                  ),
                      
                  SizedBox(height: 20,),
                      
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SignupPage()),
                      );
                    },
                    child: const Text("Create a new accounnt"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
