enum BaseEnvironment {
  development('https://127.0.0.1:3308');
//  production('https://200.134.22.214:3000');

  final String baseURL;

  const BaseEnvironment(this.baseURL);
}

final baseURL = BaseEnvironment.development.baseURL;

// Publicações
const publicationsURL = '/publications/';

// LOGIN
const refresh = '/users/refresh_token';
const login = '/users/sessions/';
