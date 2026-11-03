import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:auth_app/main.dart';
import 'package:auth_app/utils/validators.dart';

void main() {
  group('Validators', () {
    test('email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('jane@example.com'), isNull);
    });

    test('new password rules', () {
      expect(Validators.newPassword('short'), isNotNull);
      expect(Validators.newPassword('alllowercase1'), isNotNull);
      expect(Validators.newPassword('Valid1234'), isNull);
    });

    test('confirm password', () {
      expect(Validators.confirmPassword('abc', 'xyz'), isNotNull);
      expect(Validators.confirmPassword('Valid1234', 'Valid1234'), isNull);
    });
  });

  testWidgets('Login page shows errors when submitted empty', (tester) async {
    await tester.pumpWidget(const AuthApp());

    expect(find.text('Welcome back'), findsOneWidget);

    final signIn = find.widgetWithText(FilledButton, 'Sign in');
    await tester.ensureVisible(signIn);
    await tester.tap(signIn);
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Register then sign in works end to end', (tester) async {
    await tester.pumpWidget(const AuthApp());

    // Go to the register page.
    final signUp = find.text('Sign up');
    await tester.ensureVisible(signUp);
    await tester.tap(signUp);
    await tester.pumpAndSettle();
    expect(find.text('Create your account'), findsOneWidget);

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Jane Doe');
    await tester.enterText(fields.at(1), 'jane@example.com');
    await tester.enterText(fields.at(2), 'Valid1234');
    await tester.enterText(fields.at(3), 'Valid1234');

    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final create = find.widgetWithText(FilledButton, 'Create account');
    await tester.ensureVisible(create);
    await tester.tap(create);
    await tester.pumpAndSettle();

    // We land on the login page with the email pre-filled.
    expect(find.text('Welcome back'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(1), 'Valid1234');
    final signIn = find.widgetWithText(FilledButton, 'Sign in');
    await tester.ensureVisible(signIn);
    await tester.tap(signIn);
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Jane!'), findsOneWidget);
  });
}
