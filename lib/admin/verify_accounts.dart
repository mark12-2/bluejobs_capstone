import 'package:bluejobs_capstone/admin/employer_acc.dart';
import 'package:bluejobs_capstone/default_screens/view_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bluejobs_capstone/styles/custom_theme.dart';

class Verifications extends StatefulWidget {
  const Verifications({super.key});

  @override
  State<Verifications> createState() => _VerificationsState();
}

class _VerificationsState extends State<Verifications> {
  final TextEditingController _userSearchController = TextEditingController();
  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _userSearchController.dispose();

    super.dispose();
  }

  void _fetchUsers() async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final usersSnapshot = await usersRef.get();
    List<Map<String, dynamic>> allUsers = usersSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'firstName': doc.get('firstName') ?? '',
        'middleName': doc.get('middleName') ?? '',
        'lastName': doc.get('lastName') ?? '',
        'suffix': doc.get('suffix') ?? '',
        'profilePic': doc.get('profilePic') ?? '',
        'role': doc.get('role') ?? '',
        'uid': doc.get('uid') ?? '',
      };
    }).toList();

    List<Map<String, dynamic>> filteredUsers =
        allUsers.where((user) => user['role'] == 'Employer').toList();

    setState(() {
      _allUsers = filteredUsers;
      _filteredUsers = filteredUsers;
    });
  }

  void _filterUsers(String query) {
    query = query.toLowerCase();
    List<Map<String, dynamic>> filteredUsers = _allUsers.where((user) {
      String fullName =
          '${user['firstName']} ${user['middleName']} ${user['lastName']}';
      return fullName.toLowerCase().contains(query) ||
          user['role'].toLowerCase().contains(query);
    }).toList();
    setState(() {
      _filteredUsers = filteredUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Verification Management'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _userSearchController,
                decoration: customInputDecoration('Search users...').copyWith(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _filterUsers(_userSearchController.text);
                    },
                  ),
                ),
                onChanged: (value) {
                  _filterUsers(value);
                },
              ),
            ),
            Expanded(
              child: _filteredUsers.isEmpty
                  ? const Center(
                      child: Text(
                        'No users available',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        var user = _filteredUsers[index];
                        String fullName =
                            '${user['firstName']} ${user['middleName']} ${user['lastName']} ${user['suffix']}';
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['profilePic']),
                          ),
                          title: Text(fullName),
                          subtitle: Text(user['role']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                   EmployerVerify(userId: user['uid']),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ));
  }
}
