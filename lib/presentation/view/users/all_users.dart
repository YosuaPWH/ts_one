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

  @override
  void initState() {
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    users = [];

    super.initState();
  }

  Stream<List<UserModel>> _getUsers() async* {
    yield await viewModel.getAllUsers();
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
                    child: StreamBuilder<List<UserModel>>(
                        stream: _getUsers(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    surfaceTintColor: TsOneColor.surface,
                                    child: ListTile(
                                      title: Text(snapshot.data![index].name),
                                      subtitle: Text(snapshot.data![index].email),
                                    ),
                                  );
                                }
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        }
                    ),
                  ),
                ],
              )
          ),
        );
      },
    );
  }
}