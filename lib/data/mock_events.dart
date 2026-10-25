import '../models/event.dart';

final List<Event> initialEvents = [
  Event(
    id: 'e1',
    title: 'ESTÜ AI & Robotics Hackathon 2026',
    category: 'Technology',
    dateTime: DateTime(2026, 11, 14, 10, 0),
    venue: 'ESTÜ Faculty of Engineering, Block B',
    description:
        'A 24-hour innovation challenge for campus students to build autonomous agents, robotics solutions, and computer vision models using modern frameworks. Free snacks and mentorship will be provided.',
    imagePath: 'assets/images/tech_event.png',
    totalCapacity: 50,
    availablePlaces: 12,
  ),
  Event(
    id: 'e2',
    title: 'Modern Art & Ceramic Workshop',
    category: 'Arts',
    dateTime: DateTime(2026, 11, 18, 14, 30),
    venue: 'Faculty of Architecture and Design Studios',
    description:
        'A hands-on interactive workshop introducing traditional ceramics and modern campus sculptures. All required materials and pottery wheels are included.',
    imagePath: 'assets/images/art_event.png',
    totalCapacity: 15,
    availablePlaces: 1, // Only 1 place available
  ),
  Event(
    id: 'e3',
    title: 'Inter-Faculty Football Cup Final',
    category: 'Sports',
    dateTime: DateTime(2026, 11, 22, 17, 0),
    venue: 'ESTÜ Grand Stadium',
    description:
        'The championship match between Computer Engineering and Mechanical Engineering faculties. Stadium capacity is fully booked; registration is closed.',
    imagePath: 'assets/images/sports_event.png',
    totalCapacity: 200,
    availablePlaces: 0, // Fully booked event
  ),
  Event(
    id: 'e4',
    title: 'Defense Tech Career Fair & Networking',
    category: 'Career',
    dateTime: DateTime(2026, 11, 26, 11, 0),
    venue: 'ESTÜ Congress & Cultural Center',
    description:
        'Meet senior engineering recruiters and technical teams from leading aerospace and defense industry partners. Bring your English CV for direct portfolio reviews.',
    imagePath: 'assets/images/career_event.png',
    totalCapacity: 120,
    availablePlaces: 45,
  ),
  Event(
    id: 'e5',
    title: 'Autumn Acoustic Campus Concert',
    category: 'Music',
    dateTime: DateTime(2026, 11, 29, 19, 30),
    venue: 'Campus Open Air Amphitheater',
    description:
        'An unplugged live concert featuring student bands performing alternative rock, classical acoustic melodies, and jazz improvisations under the autumn stars.',
    imagePath: 'assets/images/music_event.png',
    totalCapacity: 80,
    availablePlaces: 28,
  ),
  Event(
    id: 'e6',
    title: 'Cloud Native & Docker Sandbox Workshop',
    category: 'Technology',
    dateTime: DateTime(2026, 12, 5, 13, 0),
    venue: 'Computer Engineering Department Lab 3',
    description:
        'Learn practical containerization workflows, multi-container deployments, and cloud debugging using Docker and Linux terminal environments.',
    imagePath: 'assets/images/workshop_event.png',
    totalCapacity: 30,
    availablePlaces: 8,
  ),
];
