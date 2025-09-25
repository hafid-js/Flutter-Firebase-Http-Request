import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../pages/detail_player_page.dart';
import '../pages/add_player_page.dart';

import '../providers/players.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Players>(context).initialData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isInit = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allPlayerProvider = Provider.of<Players>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("ALL PLAYERS"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddPlayer.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () {
              allPlayerProvider.initialData().then((value) {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: (allPlayerProvider.jumlahPlayer == 0)
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Data",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddPlayer.routeName);
                    },
                    child: Text(
                      "Add Player",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allPlayerProvider.jumlahPlayer,
              itemBuilder: (context, index) {
                var id = allPlayerProvider.allPlayer[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailPlayer.routeName,
                      arguments: id,
                    );
                  },
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //     allPlayerProvider.allPlayer[index].imageUrl,
                  //   ),
                  // ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: allPlayerProvider.allPlayer[index].imageUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          child: Image.network(
                              "https://digitalhealthskills.com/wp-content/uploads/2022/11/3da39-no-user-image-icon-27.png"),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    allPlayerProvider.allPlayer[index].name,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd()
                        .format(allPlayerProvider.allPlayer[index].createdAt),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allPlayerProvider.deletePlayer(id).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil dihapus"),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}
