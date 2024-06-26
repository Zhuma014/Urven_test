// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:urven/data/bloc/org_optimize_bloc.dart';
import 'package:urven/data/models/chat/chat_room.dart';
import 'package:urven/ui/screens/chat/chat_screen.dart';
import 'package:urven/ui/widgets/chat_room_list_item.dart';
import 'package:urven/ui/widgets/toolbar.dart';
import 'package:urven/utils/screen_size_configs.dart';
import 'package:urven/utils/lu.dart';


class ChatRoomsScreen extends StatefulWidget {
  final int clubId;

  const ChatRoomsScreen({super.key, required this.clubId});

  @override
  _ChatRoomsScreenState createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  @override
  void initState() {
    super.initState();
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
              isBackButtonVisible: true, 
              title: 'Chat Rooms',
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ChatRoom>>(
              stream: ooBloc.getChatRoomsSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(LU.of(context).no_chat_rooms));
                }

                List<ChatRoom> chatRooms = snapshot.data!
                    .where((chatRoom) => chatRoom.clubId == widget.clubId)
                    .toList();

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    ChatRoom chatRoom = chatRooms[index];

                    return ChatRoomListItem(
                      chatRoom: chatRoom,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoomId: chatRoom.id!),
                          ),
                        ).then((_) => ooBloc.getChatRooms()).then((_) => ooBloc.getChatRoomMessages(chatRoom.id!));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }


}



