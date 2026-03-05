import 'dart:io';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/MenuItemRequest.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/SessionRequest.dart';
import 'package:toasttab/main.dart';

class RoomController extends GetxController {
  String restaurantID = "";
  Socket socket = io(
    "https://your-api-domain.com",
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().setAuth({
      'token': authToken,
    }).build(),
  );

  void connect(String token) {
    socket = socket.connect();

    socket.onConnect((_) {});

    socket.onDisconnect((_) {});

    socket.on('batch:created', (data) {});

    socket.on('session:opened', (data) {});

    socket.on('bill:generated', (data) {});

    socket.on('bill:paid', (data) {});

    socket.on('item:status:changed', (data) {});
  }

  joinRoom() {
    socket.emit("join:billing", {"restaurantId": "${restaurantID}"});
  }

  void createNewSession(String tableID, int guestCount) {
    socket.emit("session:create", {
      "restaurantId": restaurantID,
      "tableId": tableID,
      "channel": "DINE_IN",
      "guestCount": guestCount,
    });
  }

  void createBatch(String sessionID, List<MenuItemRequest> menuList) {
    socket.emit("batch:create", {
      "restaurantId": restaurantID,
      "sessionId": sessionID,
      "items": [menuList.map((it) => it.toJson()).toList()],
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
}
