import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/notifiers/registration_notifer.dart';
import 'package:e_commerce/providers/route_provider.dart';

final _formKey = GlobalKey<FormState>();

class RegisterWidget extends ConsumerWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // manage registration state isregisted or isloading
    final registrationState = ref.watch(registrationNotifierProvider);

    // consume the class instance responsible for the interaction with the repository (contains also data validation)
    final registrationNotifier =
        ref.read(registrationNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Adjust the size of the column to fit the content
            children: [
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
              ),
              Text(
                'Fill the details to sign up',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your Name',
                  labelText: 'Name',
                  icon: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onChanged: (value) => registrationNotifier.updateName(value),
              ),
              const SizedBox(height: 25),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email required";
                  }
                  if (!value.contains('@')) {
                    return 'please enter a correct email';
                  }

                  return null;
                },
                onChanged: (value) => registrationNotifier.updateEmail(value),
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password required';
                  }
                  if (value.length < 8) {
                    return 'Password must be 8 characters minimum';
                  }
                  return null;
                },
                onChanged: (value) =>
                    registrationNotifier.updatePassword(value),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password required';
                  }

                  return null;
                },
                onChanged: (value) =>
                    registrationNotifier.updateConfirmPassword(value),
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm your password',
                  labelText: 'Confirm Password',
                  icon: Icon(
                    Icons.lock_outline_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              if (registrationState.isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await registrationNotifier.registerUser();

                      if (ref.read(registrationNotifierProvider).isRegistered) {
                        ref
                            .read(routeNotifierProvider.notifier)
                            .goTo(AppRoute.verification);
                      } else if (registrationState.message != null) {
                        // check if snackbar is already visible

                        // show error message
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              registrationState.message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(routeNotifierProvider.notifier)
                          .goTo(AppRoute.logIn);
                    },
                    child: Text(
                      'Log in',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
