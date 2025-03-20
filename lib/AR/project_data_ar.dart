class Project {
  final int id;
  final String name;
  final String url;
  final String? description;

  Project({
    required this.id,
    required this.name,
    required this.url,
    this.description,
  });
}

class ProjectData {
  static List<Project> projects = [
    Project(
      name: "Cab Game",
      url: "https://designium.8thwall.app/face-drawing/",
      id: 1,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 2",
      url: "https://sanjulalakshan.8thwall.app/cactus/",
      id: 2,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 3",
      url: "https://toolofnorthamerica.8thwall.app/pizza-hut-pacman/?f=1",
      id: 3,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 4",
      url: "https://prakria.8thwall.app/vocabularyquiz/",
      id: 4,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 5",
      url: "https://dunktechnologies.8thwall.app/drag-and-drop/",
      id: 5,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 6",
      url: "https://aestar.8thwall.app/life-journey/",
      id: 6,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 7",
      url: "https://360fabriek.8thwall.app/ar-games/",
      id: 7,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 8",
      url: "https://pablo.8thwall.app/diskdropgame/",
      id: 8,
      description: 'Try fun AR face filters',
    ),
    Project(
      name: "Project 9",
      url: "https://aestar.8thwall.app/cats/",
      id: 9,
      description: 'Try fun AR face filters',
    ),
  ];
}