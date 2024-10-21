import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/providers/route_provider.dart';
import 'package:e_commerce/notifiers/sign_in_notifier.dart';

class PasswordCodeScreen extends ConsumerWidget {
  PasswordCodeScreen({super.key});
  final List<TextEditingController> controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInNotifier = ref.read(signInNotifierProvider.notifier);
    final signInState = ref.watch(signInNotifierProvider);
    final goRouteNotifier = ref.read(routeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter verification code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock Icon
            Icon(
              Icons.lock_reset_rounded,
              size: 150,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),

            // Informative Text
            const Text(
              'An email has been sent to your email address with instructions to reset your password. Enter the verification code below:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 30),

            // Code Input Field
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 50,
                  child: TextField(
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    controller: controllers[index],
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 40),

            // Verify Button
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () async {
                  String verificationCode = controllers.map(
                    (controller) {
                      return controller.text;
                    },
                  ).join('');

                  // Call the verifyResetCode method
                  bool success = await signInNotifier.verifyResetCode(
                    signInState.email,
                    verificationCode,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification successful!'),
                      ),
                    );
                    goRouteNotifier.goTo(AppRoute.passwordChange);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(signInState.errorMessage ??
                            'Verification failed. Please try again.'),
                      ),
                    );
                  }
                },
                child: signInState.isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Verify'),
              ),
            ),

            const SizedBox(height: 10),

            // Resend Code Button
            TextButton(
              onPressed: () async {
                if (!signInState.isLoading) {
                  await signInNotifier.requestCode(signInState.email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(signInState.errorMessage ??
                          'Verification code resent.'),
                    ),
                  );
                }
              },
              child: const Text(
                'Resend Code',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
