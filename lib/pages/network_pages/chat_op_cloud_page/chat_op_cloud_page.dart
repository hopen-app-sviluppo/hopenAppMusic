import 'package:flutter/material.dart';
import 'package:music/api/social_api/social_api.dart';
import 'package:music/models/social_models/chat.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../models/social_models/follower.dart';
import '../../../provider/user_provider.dart';

class ChatOpCloudPage extends StatefulWidget {
  final Follower destinatarioChat;
  const ChatOpCloudPage({
    Key? key,
    required this.destinatarioChat,
  }) : super(key: key);

  @override
  State<ChatOpCloudPage> createState() => _ChatOpCloudPageState();
}

class _ChatOpCloudPageState extends State<ChatOpCloudPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _builAppBar(context),
      body: _buildBody(context),
      bottomSheet: _buildNavBar(),
    );
  }

  PreferredSizeWidget _builAppBar(BuildContext context) => AppBar(
        title: Row(children: [
          CircleAvatar(
            foregroundImage: NetworkImage(widget.destinatarioChat.avatar),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.destinatarioChat.username),
          ),
        ]),
      );

  Widget _buildBody(BuildContext context) => FutureBuilder(
      future: SocialApi.getChat(
        context.read<UserProvider>().currentUser!.internalAccount.token,
        context.read<UserProvider>().currentUser!.id.toString(),
        widget.destinatarioChat.userId,
      ),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snap.hasError) return const ErrorPage(error: "Errore Indesiderato");

        List<Chat> data = snap.data as List<Chat>;
        if (data.isEmpty) return const EmptyPage(title: "Invia un messaggio !");

        data = data.reversed.toList();
        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Row(
                children: [
                  if (data[i].position == "right") const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 10.0),
                    constraints: BoxConstraints(
                      minWidth: context
                              .read<SettingsProvider>()
                              .config
                              .safeBlockHorizontal *
                          15,
                      maxWidth: context
                              .read<SettingsProvider>()
                              .config
                              .safeBlockHorizontal *
                          80,
                    ),
                    decoration: BoxDecoration(
                      color: data[i].position == "right"
                          ? MainColor.secondaryColor
                          : Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(25),
                        bottomLeft: const Radius.circular(25),
                        bottomRight: data[i].position == "right"
                            ? Radius.zero
                            : const Radius.circular(25),
                        topLeft: data[i].position == "right"
                            ? const Radius.circular(25)
                            : Radius.zero,
                      ),
                      border:
                          Border.all(width: 1, color: MainColor.secondaryColor),
                    ),
                    child: Text(
                      data[i].text,
                      maxLines: 5,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  if (data[i].position == "left") const Spacer(),
                ],
              );
            });
      });

  Widget _buildNavBar() => Container(
        height: context.read<SettingsProvider>().config.safeBlockVertical * 7,
        width: double.infinity,
        margin: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 2, color: MainColor.secondaryColor),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                      hintText: "Inserisci un messaggio. . .",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 10),
                      isDense: false,
                      icon: Icon(Icons.photo_camera),
                      suffixIcon: Icon(Icons.photo)),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: CircleAvatar(
                backgroundColor: MainColor.secondaryColor,
                child: Icon(
                  Icons.send,
                  color: MainColor.primaryColor,
                ),
              ),
            ),
          ],
        ),
      );
}
