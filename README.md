# Orbit: Login and Register Pages (Flutter)

A Flutter app with a login page and a register page, built as Assignment 1 by Travis, a student at Bingham University. It was developed in Android Studio and demonstrated in Chrome using Flutter web.

## What it does

- **Login page:** email and password fields, a show/hide password button, a "Remember me" checkbox, a "Forgot password?" dialog, and a loading spinner on the Sign in button.
- **Register page:** full name, email, password and confirm password fields, a live password-strength bar, and a Terms checkbox that has to be ticked before the account can be created.
- **Form validation:** every field is checked and shows a clear message when something is wrong, for example an invalid email, a password that is too short, or passwords that do not match.
- **Error handling:** wrong passwords, unknown emails and duplicate accounts show a red message above the button.
- **Navigation:** after registering, the app opens the login page with the email already filled in. After signing in, a welcome screen greets the user by first name, with a sign out button.
- **Responsive design:** on a wide screen such as a browser, the page splits into a colourful brand panel and the form. On a narrow window or a phone, it shows just the form.

## Running the project

You need Flutter installed. Chrome is enough to run it, so no emulator is needed.

```
flutter pub get
flutter run -d chrome
```

To run the tests:

```
flutter test
```

## Project structure

```
lib/
  main.dart            app entry point
  screens/             login, register and home screens
  widgets/             reusable pieces (text field, button, layout, password meter)
  services/            auth_service.dart, a simple stand-in for a backend
  theme/               colours and app theme
  utils/               validators, constants and page transitions
test/
  widget_test.dart     validator tests and a register-then-login test
```

I split the code this way so each file has one job. The validation rules sit in their own file, and the text field and button are written once and reused on both pages.

## Things to know

- There is no real backend. `AuthService` keeps accounts in memory, so they are lost when the app restarts or the browser page is refreshed.
- "Remember me" and "Forgot password?" are interface only for now and do not do anything behind the scenes.
- A real app should never store plain-text passwords. This project does it only because it is a demo.

## Possible improvements

- Connect `AuthService` to Firebase Authentication or a REST API.
- Save sessions on the device so users stay signed in.
- Add email verification and a working password reset.