import 'package:flutter/material.dart';
import 'dart:ui';
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
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxWidth: 400),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildSearchInput(),
              _buildResultsList(),
              _buildCloseButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Add Group Members',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
          decoration: InputDecoration(
            hintText: 'Search contacts...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            'No contacts found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final contact = _searchResults[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[800]?.withOpacity(0.2),
              child: Text(
                contact.name.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            title: Text(
              contact.name,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.blue[300],
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

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
        child: Text(
          'Cancel',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}