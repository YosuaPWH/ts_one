import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';

class AllUsersView extends StatefulWidget {
  const AllUsersView({Key? key}) : super(key: key);

  @override
  State<AllUsersView> createState() => _AllUsersViewState();
}

class _AllUsersViewState extends State<AllUsersView> {
  late UserViewModel viewModel;
  late List<UserModel> users;
  late ScrollController _scrollController;
  int limit = 10;

  @override
  void initState() {
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    users = [];
    getUsers();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void getUsers () async {
    users = await viewModel.getAllUsers(limit);
  }

  void _scrollListener() {
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      viewModel.getAllUsers(limit);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Users"),
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (index < users.length) {
                            return Card(
                              surfaceTintColor: TsOneColor.surface,
                              child: ListTile(
                                title: Text(users[index].name),
                                subtitle: Text(users[index].email),
                              ),
                            );
                          }
                          else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    )
                  ),
                ],
              )
          ),
        );
      },
    );
  }
}