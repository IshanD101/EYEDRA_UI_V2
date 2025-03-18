import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/campfire_listener_data.dart';

class CampfireMain extends StatefulWidget {
  const CampfireMain({super.key});

  @override
  State<CampfireMain> createState() => _CampfireState();
}

class _CampfireState extends State<CampfireMain> {
  late Future<List<Session>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = SessionService.fetchSessions();
  }

  void _showHostDetails(BuildContext context, Host host) {
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
                    onPressed: () {}, // Placeholder for join functionality
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
      body: FutureBuilder<List<Session>>(
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

          final sessions = snapshot.data!;

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
}
