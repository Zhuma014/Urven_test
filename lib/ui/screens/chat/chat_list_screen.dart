// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:urven/data/bloc/org_optimize_bloc.dart';
import 'package:urven/data/models/chat/chat_room.dart';
import 'package:urven/data/models/club/club.dart';
import 'package:urven/ui/screens/chat/chat_rooms_screen.dart';
import 'package:urven/ui/screens/chat/chat_screen.dart';
import 'package:urven/ui/screens/navigation.dart';
import 'package:urven/ui/theme/palette.dart';
import 'package:urven/ui/widgets/toolbar.dart';
import 'package:urven/utils/screen_size_configs.dart';
import 'package:flutter/gestures.dart';
import 'package:urven/utils/lu.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    ooBloc.getUserProfile();
    ooBloc.getChatRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: SSC.p10),
            child: Toolbar(
              isBackButtonVisible: false,
              title: 'Chats',
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SSC.p10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.group, color: Colors.purple),
                          SizedBox(width: 8.0),
                          Text(
                            LU.of(context).club_chats,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.DARK_BLUE,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<List<Club>>(
                          stream: ooBloc.getUserClubsSubject,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          LU.of(context).you_are_not_member),
                                      const SizedBox(height: SSC.p12),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Palette.MAIN,
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, Navigation.ALLCLUBS);
                                        },
                                        child: Text(
                                          LU.of(context).join_clubs,
                                          style: TextStyle(
                                              color: Palette.BACKGROUND),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            List<Club> clubs = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: clubs.map((club) {
                                return ClubListItem(
                                  club: club,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatRoomsScreen(clubId: club.id!),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.groups, color: Colors.purple),
                          SizedBox(width: 8.0),
                          Text(
                            LU.of(context).group_chats,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Palette.DARK_BLUE,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<List<ChatRoom>>(
                          stream: ooBloc.getChatRoomsSubject.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: LU.of(context).no_group_chats,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: LU.of(context).start_messaging,
                                              style: const TextStyle(
                                                color: Palette.MAIN,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showMessageBottomSheet(
                                                      context);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: LU.of(context).no_group_chats,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: LU.of(context).start_messaging,
                                              style: const TextStyle(
                                                color: Palette.MAIN,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showMessageBottomSheet(
                                                      context);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            List<ChatRoom> chatRooms = snapshot.data ?? [];

                            List<ChatRoom> groupChats = chatRooms
                                .where((chatRoom) => chatRoom.type == 'group')
                                .toList();
                            if (groupChats.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: LU.of(context).no_group_chats,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: LU.of(context).start_messaging,
                                              style: const TextStyle(
                                                color: Palette.MAIN,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showMessageBottomSheet(
                                                      context);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: groupChats.map((chatRoom) {
                                  return ListTile(
                                    title: Text(
                                      chatRoom.name ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        getLastMessageText(context,
                                            chatRoom.lastMessage),
                                        style: const TextStyle(
                                            color: Palette.MAIN)),
                                    trailing:
                                        const Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                              chatRoomId: chatRoom.id!),
                                        ),
                                      ).then((_) => ooBloc.getChatRooms());
                                    },
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.purple),
                              SizedBox(width: 8.0),
                              Text(
                                LU.of(context).private_chats,
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.DARK_BLUE,
                                ),
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<List<ChatRoom>>(
                          stream: ooBloc.getChatRoomsSubject,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: LU.of(context).no_private_chats,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: LU.of(context).start_messaging,
                                              style: const TextStyle(
                                                color: Palette.MAIN,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showMessageBottomSheet(
                                                      context);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: LU.of(context).no_private_chats,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: LU.of(context).start_messaging,
                                              style: const TextStyle(
                                                color: Palette.MAIN,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showMessageBottomSheet(
                                                      context);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            List<ChatRoom> chatRooms = snapshot.data ?? [];
                            List<ChatRoom> privateChats = chatRooms
                                .where((chatRoom) => chatRoom.type == 'private')
                                .toList();
                            if (privateChats.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.all(SSC.p15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text: LU.of(context).no_private_chats,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                            TextSpan(
                                              text: LU.of(context).start_messaging,
                                              style: const TextStyle(
                                                color: Palette.MAIN,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  showMessageBottomSheet(
                                                      context);
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: privateChats.map((chatRoom) {
    List<String> memberNames = chatRoom.name?.split(':') ?? [];
    memberNames.removeWhere((name) => name.trim().isEmpty);

    String? neighborName;
    if (ooBloc.userProfileSubject.value?.fullName == memberNames[0]) {
      neighborName = memberNames[1];
    } else if (ooBloc.userProfileSubject.value?.fullName == memberNames[1]) {
      neighborName = memberNames[0];
    }

    return Builder(
      builder: (context) => Dismissible(
          key: Key(chatRoom.id.toString()),
          direction: DismissDirection.startToEnd,
          confirmDismiss: (_) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Chat Room'),
                content: const Text(
                    'Are you sure you want to delete this chat room? Please change the owner'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel',style: TextStyle(color:Colors.grey),),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Delete anyway',style: TextStyle(color: Colors.red),),
                  ),
                ],
              ),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
         onDismissed: (direction) async {
          await ooBloc.deleteChatRoom(chatRoom.id!);
          ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat room deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
              // Remove the Dismissible widget from the tree
              setState(() {
                    privateChats.remove(chatRoom);
              });
            },

          child: Builder(
            builder: (context) {
              return ListTile(
                title: Text(
                  neighborName!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  getLastMessageText(context,chatRoom.lastMessage),
                  style: const TextStyle(color: Palette.MAIN),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatRoomId: chatRoom.id!),
                    ),
                  ).then((_) => ooBloc.getChatRooms()).then(
                        (_) => ooBloc.getChatRoomMessages(chatRoom.id!),
                      );
                },
              );
            }
          ),
        ),
      
    );
  }).toList(),
);


                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    ooBloc.dispose();
  }
}

String getLastMessageText(BuildContext context, String? lastMessage) {
  final currentUserId = ooBloc.userProfileSubject.value?.id.toString();
  print(currentUserId);

  if (lastMessage == null || lastMessage.isEmpty) {
    return LU.of(context).no_messages;
  }

  final parts = lastMessage.split(':');

  if (parts.length >= 3) {
    final name = parts[0];
    final id = parts[1].trim();
    final message = parts.sublist(2).join(':');

    if (id == currentUserId) {
      return 'You: $message';
    }

    return '$name: $message';
  }

  return lastMessage;
}

class ClubListItem extends StatelessWidget {
  final Club club;
  final VoidCallback onTap;

  const ClubListItem({super.key, required this.club, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: SSC.p16, vertical: SSC.p8),
      title: Text(
        club.name ?? LU.of(context).unknown_club,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        club.description ?? '',
        style: const TextStyle(color: Palette.MAIN),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
