String title = 'Projects';
String description = 'Things I\'ve built so far';

// Academic Projects
List<Map<String, dynamic>> academicProjects = [
  {
    'title': 'Service Pro',
    'description':
        'A comprehensive service management application developed as part of academic curriculum. Features user-friendly interface for service booking and management.',
    'img': [],
    'tech': 'Flutter, Dart, Node.js, MongoDB',
    'videoUrl':
        'https://drive.google.com/file/d/1bALe9K7hYmfys1QklSvxkoltZ2oCIunh/view?usp=drive_link',
    'gitLink': 'https://github.com/lgic-project/Service_Pro_User',
    'hasDemo': true,
  },
  {
    'title': 'Anime Archive',
    'description':
        'A web-based anime management system developed during academic studies. Features comprehensive anime database with user ratings and reviews.',
    'img': [],
    'tech': 'HTML, CSS, JavaScript, PHP, MySQL',
    'gitLink': 'https://github.com/0Ankit0/anime-archive',
    'hasDemo': false,
  },
  {
    'title': 'Game Hub',
    'description':
        'A desktop gaming platform developed as final year project. Provides centralized gaming experience with multiple game categories.',
    'img': [],
    'tech': '.NET, MySQL',
    'gitLink': 'https://github.com/m0dern6/Game_Hub',
    'hasDemo': false,
  },
  {
    'title': 'Hook',
    'description':
        'A C++ based application developed during programming fundamentals course. Demonstrates advanced programming concepts and data structures.',
    'img': [
      'assets/project_images/hook/hook.png',
      'assets/project_images/hook/hook1.png',
      'assets/project_images/hook/hook2.png',
      'assets/project_images/hook/hook3.png',
    ],
    'tech': 'C++',
    'gitLink': 'https://github.com/m0dern6/Hook',
    'hasDemo': false,
  },
];

// Company/Organization Projects
List<Map<String, dynamic>> companyProjects = [
  {
    'title': 'Investynn',
    'description':
        'A professional investment management application developed during internship. Features portfolio tracking, market analysis, and investment recommendations.',
    'img': [
      'assets/investynn_img/investynn_thumbnail.png',
      'assets/investynn_img/Screenshot 2025-05-13 090614.png',
    ],
    'tech': 'Flutter, Dart, UI/UX, Go Router, REST APIs',
    'gitLink': '',
    'hasDemo': false,
  },
  {
    'title': 'Programming Learning App (LUA)',
    'description':
        'An interactive programming learning platform developed for educational purposes. Features coding challenges, tutorials, and progress tracking.',
    'img': [
      'assets/lua_img/lua_thumbnail.png',
      'assets/lua_img/2.png',
      'assets/lua_img/4.png',
      'assets/lua_img/6.png',
      'assets/lua_img/8.png',
      'assets/lua_img/14.png',
      'assets/lua_img/16.png',
      'assets/lua_img/18.png',
      'assets/lua_img/19.png',
    ],
    'tech': 'Flutter, Dart, API Integration',
    'gitLink': '',
    'hasDemo': false,
  },
];

// UI/UX Design Projects
List<Map<String, dynamic>> uiuxProjects = [
  {
    'title': 'Food Delivery App UI',
    'description':
        'Modern and intuitive food delivery application UI design. Features clean interface, smooth user experience, and appealing visual design.',
    'img': [
      'assets/food_app_img/food_app_thumbnail.png',
      'assets/food_app_img/Screenshot_20250702-112452_food_app-portrait.png',
      'assets/food_app_img/Screenshot_20250702-112628_food_app-portrait.png',
      'assets/food_app_img/Screenshot_20250702-112651_food_app-portrait.png',
      'assets/food_app_img/Screenshot_20250702-112708_food_app-portrait.png',
    ],
    'tech': 'Flutter, Dart, UI/UX Design',
    'gitLink': '',
    'hasDemo': false,
  },
];

// Legacy projects list for backward compatibility
List<Map<String, dynamic>> projects = academicProjects;
