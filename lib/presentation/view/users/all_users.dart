import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/routes.dart';
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
  int limit = 30;

  @override
  void initState() {
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    users = [];
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUsers();
    });

    super.initState();
  }

  void getUsers () async {
    users = await viewModel.getAllUsers(limit);
  }

  void _scrollListener() {
    if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      // viewModel.getAllUsers(limit);
      getUsers();
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
                    child: users.isNotEmpty
                        ? ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (index == users.length - 1 && !viewModel.isAllUsersLoaded) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Card(
                            surfaceTintColor: TsOneColor.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.asset("assets/images/placeholder_person.png"),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            users[index].name,
                                            style: tsOneTextTheme.titleMedium,
                                          ),
                                          Text(
                                            users[index].position,
                                            style: tsOneTextTheme.bodySmall,
                                          ),
                                          Text(
                                            users[index].staffNo,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    )
                        : const Center(child: CircularProgressIndicator())
                  ),
                ],
              )
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: TsOneColor.primary,
            onPressed: () {
              Navigator.pushNamed(context, NamedRoute.addUser);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}