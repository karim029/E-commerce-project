import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/notifiers/registration_notifer.dart';
import 'package:e_commerce/providers/route_provider.dart';

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationNotifier =
        ref.read(registrationNotifierProvider.notifier);
    final registrationState = ref.read(registrationNotifierProvider);
    final routeNotifier = ref.read(routeNotifierProvider.notifier);

    // Listening to isVerified state to navigate if true
    ref.listen<RegistrationState>(registrationNotifierProvider,
        (previous, next) {
      if (next.isVerified == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User verified successfuly'),
          ),
        );
        routeNotifier.goTo(AppRoute.logIn); // Navigate to login
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: Text(
          'Email verification',
        ),
        leadingWidth: 300,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_email_unread_outlined,
              color: Colors.grey,
              size: 100,
            ),
            Text(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
              'Registration successful! \n Please check your inbox for a verification email and follow the link to activate your account.',
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    registrationNotifier.verifyUser();
                  },
                  child: Text('Already verified ?'),
                ),
                SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: ref
                          .watch(registrationNotifierProvider)
                          .canResendEmail
                      ? () async {
                          await registrationNotifier.resendVerification();
                          ScaffoldMessenger.of(context).clearSnackBars();
                          final message =
                              ref.watch(registrationNotifierProvider).message;
                          if (message != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                          }
                        }
                      : null,
                  child: Text(ref
                          .watch(registrationNotifierProvider)
                          .canResendEmail
                      ? 'Resend email'
                      : 'Wait ${ref.watch(registrationNotifierProvider).remainingTime} sec'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
