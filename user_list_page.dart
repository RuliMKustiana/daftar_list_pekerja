import 'package:flutter/material.dart';
import 'package:daftar_nama_pengguna/pages/user_detail_page.dart';
import 'package:daftar_nama_pengguna/pages/add_user_page.dart';
import 'package:daftar_nama_pengguna/services/api_service.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = ApiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Nama Pengguna'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  title: Text(user['first_name'] + ' ' + user['last_name']),
                  subtitle: Text(user['email']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserDetailsPage(userId: user['id']),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No users found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}