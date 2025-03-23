import 'package:flutter/material.dart';
import 'dart:ui';
import '../../services/campfire/camp_session_model.dart'; // Updated import for the model
import '../../services/campfire/camp_session_service.dart'; // Added import for session service
import '../../services/campfire/camp_auth_service.dart'; // Added import for auth service
import '../../screens/virtual_campfire/home_page_camp.dart';

class CampfireMain extends StatefulWidget {
  const CampfireMain({super.key});

  @override
  State<CampfireMain> createState() => _CampfireState();
}

class _CampfireState extends State<CampfireMain> {
  late Future<List<CampSession>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = CampSessionService.fetchSessions();
  }

  void _showHostDetails(BuildContext context, CampHost host) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.2),
                    Colors.blue[900]!.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[700]!.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.blue[300]!.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[300]!.withOpacity(0.5),
                          Colors.blue[900]!.withOpacity(0.3),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue[700]!.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.12,
                      backgroundColor: Colors.transparent,
                      backgroundImage: host.imageUrl.isNotEmpty
                          ? NetworkImage(host.imageUrl)
                          : null,
                      child: host.imageUrl.isEmpty
                          ? Icon(Icons.person,
                          size: 60, color: Colors.white.withOpacity(0.9))
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    host.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(host.role,
                      style: TextStyle(
                          fontSize: 16, color: Colors.white.withOpacity(0.7))),
                  const SizedBox(height: 12),
                  if (host.bio != null)
                    Text(
                      host.bio!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.8)),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // Close the dialog first
                      Navigator.pop(context);

                      // Join the session through the API
                      final sessionId = host.name.replaceAll(' ', '_').toLowerCase() + "_session";
                      final result = await CampSessionService.joinSession(sessionId);

                      if (!mounted) return;

                      if (result['success'] == true) {
                        // Navigate to HomePage with the joined session ID
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return HomePage(prefilledSessionId: sessionId);
                          }),
                        );
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'] ?? 'Failed to join session'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Join"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1200
        ? 4
        : screenWidth > 800
        ? 3
        : 2;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to create a new session
          _showCreateSessionDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: FutureBuilder<List<CampSession>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined,
                      size: 80, color: Colors.white.withOpacity(0.6)),
                  const SizedBox(height: 16),
                  Text(
                    'No active sessions found',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      // Refresh the sessions
                      setState(() {
                        _sessionsFuture = CampSessionService.fetchSessions();
                      });
                    },
                    child: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return GestureDetector(
                  onTap: () => _showHostDetails(context, session.host),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withOpacity(0.2),
                              Colors.blue[900]!.withOpacity(0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue[700]!.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: Colors.blue[300]!.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(session.title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(session.category,
                                      style: TextStyle(
                                          color: Colors.blue[100],
                                          fontSize: 14)),
                                  const SizedBox(height: 4),
                                  Text(session.startTime,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.people_outline,
                                          color: Colors.white70,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${session.participantCount} participants',
                                        style: const TextStyle(
                                            color: Colors.white70, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.blue[300]!.withOpacity(0.5),
                                        Colors.blue[900]!.withOpacity(0.3),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                        Colors.blue[700]!.withOpacity(0.3),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: session
                                        .host.imageUrl.isNotEmpty
                                        ? NetworkImage(session.host.imageUrl)
                                        : null,
                                    child: session.host.imageUrl.isEmpty
                                        ? Icon(Icons.person,
                                        color:
                                        Colors.white.withOpacity(0.9))
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(session.host.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500)),
                                      Text(session.host.role,
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateSessionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue[900]!.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Create New Session',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Session Title',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (titleController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a session title'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          // First check if user info exists
                          final userInfo = await AuthService.getUserInfo();
                          if (userInfo == null) {
                            // Create mock user if no user exists
                            await AuthService.createMockUser('Host', 'host');
                          }

                          // Create the session
                          final result = await CampSessionService.createSession(
                            titleController.text.trim(),
                            categoryController.text.trim().isEmpty
                                ? 'General'
                                : categoryController.text.trim(),
                          );

                          if (!mounted) return;
                          Navigator.pop(context);

                          if (result['success'] == true) {
                            // Refresh sessions list
                            setState(() {
                              _sessionsFuture = CampSessionService.fetchSessions();
                            });

                            // Navigate to the session
                            if (result['sessionId'] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return HomePage(prefilledSessionId: result['sessionId']);
                                }),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result['message'] ?? 'Failed to create session'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}