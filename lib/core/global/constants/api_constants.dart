enum BaseEnvironment {
  development('http://192.168.0.131:3333');
  //production('https://');

  final String baseURL;

  const BaseEnvironment(this.baseURL);
}

final baseURL = BaseEnvironment.development.baseURL;

const jwtSecret = String.fromEnvironment('JWT_SECRET');

// LOGIN
const loginURL = '/sessions/';

// NEWS
const newsURL = '/news/';

// PUBLICATIONS
const publicationsURL = '/publications/';

// MEMBERS
const membersURL = '/members/';

// MEMBER ROLES
const memberRolesURL = '/member-roles/';

// PROJECTS
const projectsURL = '/projects/';

// PROJECT TYPES
const projectTypesURL = '/project-types/';

// PROJECT MEDIA
const projectMediaURL = '/project-media/';

// NEWS MEDIA
const newsMediaURL = '/news-media/';

// IMAGES UPLOAD
const imagesUploadURL = '/images/upload/';

// EVENTS
const eventsURL = '/events/';

// EVENT MEDIA
const eventMediaURL = '/event-media/';

// ADDRESSES
const addressesURL = '/addresses/';

// ARTICLES
const articlesURL = '/articles/';

// BOOK CHAPTERS
const bookChaptersURL = '/book-chapters/';

// BOOK
const booksURL = '/books/';

// ACADEMIC WORKS
const academicWorksURL = '/academic-works/';

// ACADEMIC WORK TYPES
const academicWorkTypesURL = '/academic-work-types/';

// RESEARCH AREAS
const researchAreasURL = '/research-areas/';

// CONTRIBUTORS
const contributorsURL = '/publication-contributors/';

// CONTRIBUTOR ROLES
const contributorRolesURL = '/contributor-role/';

// EXTERNAL AUTHORS
const externalAuthorsURL = '/external-authors/';

// ORGANIZATIONS
const organizationsURL = '/organizations/';
