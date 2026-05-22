enum BaseEnvironment {
  development('http://127.0.0.1:3308');
  //production('https://');

  final String baseURL;

  const BaseEnvironment(this.baseURL);
}

final baseURL = BaseEnvironment.development.baseURL;

const jwtSecret = String.fromEnvironment('JWT_SECRET');

// LOGIN
const loginURL = '/sessions';

// NEWS
const newsURL = '/news';

// PUBLICATIONS
const publicationsURL = '/publications';

// MEMBERS
const membersURL = '/members';

// PROJECTS
const projectsURL = '/projects';

// PROJECT MEDIA
const projectMediaURL = '/project-media';

// NEWS MEDIA
const newsMediaURL = '/news-media';
