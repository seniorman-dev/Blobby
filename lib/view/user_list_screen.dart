import 'package:blobby/controller/user_provider.dart';
import 'package:blobby/view/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    Provider.of<UserProvider>(context, listen: false).searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    
    final userProvider = Provider.of<UserProvider>(context,);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            SizedBox(height: 20.h,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Focus(
                child: TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    
                  ),
                  onChanged: (val) {
                    setState(() {
                      _onSearchChanged(val);
                    });
                  },
                ),
              ),
            ),
        
            // User List / Loading / Error
            Expanded(
              child: userProvider.isLoading
                  ? const LoaderDark()
                  : userProvider.error.isNotEmpty
                      ?Center(
                        child: Text(
                          userProvider.error,
                          textAlign: TextAlign.center,
                        )
                      )
                      : userProvider.filteredUsers.isEmpty
                      ?Center(
                        child: Text(
                          "Couldn't find user",
                          textAlign: TextAlign.center,
                        )
                      )
                      : RefreshIndicator(
                          onRefresh: () => userProvider.fetchUsers(),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: userProvider.filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = userProvider.filteredUsers[index];
                              return ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(user['name']),
                                subtitle: Text(user['email']),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
