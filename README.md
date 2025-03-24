# EYEDRA - Mental Wellbeing Social Media Application

EYEDRA is a social media platform dedicated to mental wellbeing. It provides a safe space for users to connect, share, and support each other through community-driven content, video call therapy sessions, and dedicated mental health support.  

## 🚀 Key Features

- **Video Call Therapy Sessions**: Real-time video calls with certified listeners (counselors) for mental health support.
- **Community Chat Groups**: Listener-exclusive access to create safe and moderated communities.
- **Content Sharing**: Post thoughts, experiences, and insights related to mental health and wellbeing.
- **Reactions and Engagement**: Users can react to posts and comments to express their support.
- **Notifications**: Get real-time updates about community activities, new posts, and session invitations.
- **Secure Authentication and Authorization**: Role-based JWT authentication for `user`, `listener`, and `admin`.

## 🧑‍💻 Technologies Used

### Frontend
- **Framework**: Flutter
- **State Management**: Provider / Riverpod
- **Video Call Integration**: [Specify library used, e.g., Agora, Jitsi Meet]
- **Real-time Messaging**: WebSockets / Firebase
- **REST API Integration**: HTTP Package
- **Authentication**: JWT Token-based

### Backend (Microservices Architecture)
- **Framework**: Spring Boot
- **Service Discovery**: Eureka Server
- **API Gateway**: Zuul / Spring Cloud Gateway
- **Microservices**:
  - **User Service**: Authentication and authorization
  - **Community Service**: Chat groups and communities
  - **Post Service**: Content sharing and management
  - **Reaction Service**: Post reactions and interactions
  - **Notification Service**: Real-time notifications
- **Database**: MongoDB
- **Communication**: Websockets/ Socket.io / REST

## 🔧 Project Structure

eyedra-frontend/
├── lib/
│   ├── models/           # Data models
│   ├── providers/        # State management files
│   ├── services/         # API calls and backend interaction
│   ├── screens/          # UI screens
│   ├── widgets/          # Reusable UI components
│   └── utils/            # Utility functions and helpers
├── assets/               # Images, icons, and other assets
├── pubspec.yaml          # Dependencies and packages
└── README.md             # Project documentation
pgsql
Copy
Edit



## 🛠️ Getting Started

### Prerequisites
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android Studio / Visual Studio Code
- Backend Microservices Running
