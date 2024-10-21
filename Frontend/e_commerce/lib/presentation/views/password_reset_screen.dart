import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/providers/route_provider.dart';
import 'package:e_commerce/notifiers/sign_in_notifier.dart';

class PasswordResetScreen extends ConsumerWidget {
  PasswordResetScreen({super.key});

  final _formKey = GlobalKey<FormState>(); // Key to manage form state
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email input

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouteNotifier = ref.read(routeNotifierProvider.notifier);
    final signInNotifier = ref.read(signInNotifierProvider.notifier);
    final signInState = ref.watch(signInNotifierProvider);

    return Scaffold(
      body: SingleChildScrollView(
        // Enables scrolling
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 40,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Password Reset',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
              ),
              Text(
                'Enter your email to receive the reset code',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(
                height: 50,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        labelText: 'Email',
                        icon: Icon(
                          Icons.mail_outline_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 40),
                ),
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState?.validate() ?? false) {
                    final email = _emailController.text;
                    signInNotifier.updateEmail(email);

                    try {
                      // Make the backend call to check if the email exists
                      final response = await signInNotifier.requestCode(email);

                      if (response) {
                        // Email exists, proceed with the reset code logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reset code sent to $email',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                            ),
                          ),
                        );
                        goRouteNotifier.goTo(AppRoute.passwordcode);
                      } else {
                        // Email does not exist, show error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              signInState.errorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                  ),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      // Handle any other errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'An error occurred. Please try again.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red,
                                ),
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Send Code'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  goRouteNotifier.goTo(AppRoute.logIn);
                },
                child: Text(
                  'Back to Login',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
