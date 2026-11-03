/// A simple user object returned after sign-in.
class AppUser {
  const AppUser({required this.name, required this.email});

  final String name;
  final String email;

  String get firstName => name.split(' ').first;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _Account {
  const _Account({required this.name, required this.password});

  final String name;
  final String password;
}

/// A fake, in-memory authentication service.
///
/// It behaves like a real backend (async calls, errors, duplicate emails)
/// so the UI can be built and demonstrated properly.
/// To go "real", replace the bodies of [register] and [login] with calls to
/// Firebase Authentication or your own REST API. The screens will not need
/// to change.
///
/// NOTE: a real app must never keep plain-text passwords. This is demo-only.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final Map<String, _Account> _accounts = {};

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final key = email.trim().toLowerCase();
    if (_accounts.containsKey(key)) {
      throw const AuthException('An account with this email already exists.');
    }
    _accounts[key] = _Account(name: name.trim(), password: password);
    return AppUser(name: name.trim(), email: key);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    final key = email.trim().toLowerCase();
    final account = _accounts[key];
    if (account == null) {
      throw const AuthException(
        'No account found for this email. Please sign up first.',
      );
    }
    if (account.password != password) {
      throw const AuthException('Incorrect password. Please try again.');
    }
    return AppUser(name: account.name, email: key);
  }
}
