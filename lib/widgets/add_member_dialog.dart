import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' show min;
import '../models/group_member.dart';

class AddMemberDialog extends StatefulWidget {
  final Function(GroupMember) onMemberAdded;
  final List<String> existingMemberIds;

  const AddMemberDialog({
    Key? key,
    required this.onMemberAdded,
    required this.existingMemberIds,
  }) : super(key: key);

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final TextEditingController _searchController = TextEditingController();
  final List<GroupMember> _searchResults = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Populate with mock data initially
    _searchResults.addAll(_getMockContacts());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults.clear();
        _searchResults.addAll(_getMockContacts());
      });
      return;
    }

    final query = _searchController.text.toLowerCase();
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      // Filter mock data
      final filtered = _getMockContacts()
          .where((contact) => contact.name.toLowerCase().contains(query))
          .toList();

      setState(() {
        _searchResults.clear();
        _searchResults.addAll(filtered);
        _isLoading = false;
      });
    });
  }

  List<GroupMember> _getMockContacts() {
    // This would typically come from an API or contacts database
    return [
      GroupMember(id: '1', name: 'Alice Johnson'),
      GroupMember(id: '2', name: 'Bob Williams'),
      GroupMember(id: '3', name: 'Charlie Davis'),
      GroupMember(id: '4', name: 'Diana Miller'),
      GroupMember(id: '5', name: 'Edward Wilson'),
      GroupMember(id: '6', name: 'Fiona Garcia'),
      GroupMember(id: '7', name: 'George Martinez'),
    ].where((member) => !widget.existingMemberIds.contains(member.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive sizing
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 32,
          vertical: 24,
        ),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: screenSize.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[900]?.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use LayoutBuilder to get the actual available space
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(constraints),
                  _buildSearchInput(constraints),
                  Flexible(
                    child: _buildResultsList(constraints),
                  ),
                  _buildCloseButton(context, constraints),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    // Responsive font size based on container width
    final fontSize = constraints.maxWidth < 300 ? 18.0 : 20.0;

    return Padding(
      padding: EdgeInsets.all(constraints.maxHeight < 500 ? 12 : 16),
      child: Text(
        'Add Group Members',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildSearchInput(BoxConstraints constraints) {
    // Adjust padding based on available space
    final verticalPadding = constraints.maxHeight < 500 ? 4.0 : 8.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: constraints.maxWidth < 300 ? 14 : 16,
          ),
          decoration: InputDecoration(
            hintText: 'Search contacts...',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: constraints.maxWidth < 300 ? 14 : 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
              size: constraints.maxWidth < 300 ? 20 : 24,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: constraints.maxHeight < 500 ? 8 : 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(BoxConstraints parentConstraints) {
    // Calculate appropriate list height
    final listMaxHeight = parentConstraints.maxHeight * 0.6;

    if (_isLoading) {
      return SizedBox(
        height: 80,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'No contacts found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: parentConstraints.maxWidth < 300 ? 14 : 16,
            ),
          ),
        ),
      );
    }

    // Responsive list that adjusts to available space
    return Container(
      constraints: BoxConstraints(
        maxHeight: listMaxHeight,
        minHeight: min(80, listMaxHeight),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _searchResults.length,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemBuilder: (context, index) {
          final contact = _searchResults[index];
          // Adjust tile height based on available vertical space
          final isCompactMode = parentConstraints.maxHeight < 500;

          return ListTile(
            visualDensity: VisualDensity(
              horizontal: 0,
              vertical: isCompactMode ? -2 : 0,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: isCompactMode ? 0 : 4,
            ),
            leading: CircleAvatar(
              radius: isCompactMode ? 18 : 20,
              backgroundColor: Colors.blue[800]?.withOpacity(0.2),
              child: Text(
                contact.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isCompactMode ? 14 : 16,
                ),
              ),
            ),
            title: Text(
              contact.name,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: parentConstraints.maxWidth < 300 ? 14 : 16,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.blue[300],
                size: parentConstraints.maxWidth < 300 ? 20 : 24,
              ),
              onPressed: () {
                widget.onMemberAdded(contact);
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context, BoxConstraints constraints) {
    // Adjust button size based on container size
    final isCompactMode = constraints.maxHeight < 500;
    final horizontalPadding = isCompactMode ? 12.0 : 24.0;
    final verticalPadding = isCompactMode ? 8.0 : 12.0;

    return Padding(
      padding: EdgeInsets.all(isCompactMode ? 12 : 16),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[900]?.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.blue.withOpacity(0.3),
              width: 1,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: constraints.maxWidth < 300 ? 14 : 16,
          ),
        ),
      ),
    );
  }
}