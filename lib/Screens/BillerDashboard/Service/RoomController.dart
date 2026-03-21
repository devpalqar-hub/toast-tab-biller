import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/MenuItemRequest.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Request/SessionRequest.dart';
import 'package:toasttab/Screens/BillerDashboard/Models/Response/MenuModel.dart';
import 'package:toasttab/Screens/BillerDashboard/Service/DashBoardContoller.dart';
import 'package:toasttab/main.dart';

class RoomController extends GetxController {
  Socket socket = io(
    'https://api.pos.palqar.cloud/orders',
    OptionBuilder()
        .setTransports(['websocket'])
        .setExtraHeaders({'authorization': 'Bearer $authToken'})
        .setAuth({'token': 'Bearer $authToken'})
        .disableAutoConnect()
        .build(),
  );

  void connect(String token) {
    socket = socket.connect();

    socket.emit('join:restaurant', {'restaurantId': restaurantId});
    //socket.emit('join:kitchen', {'restaurantId': restaurantId});
    socket.emit('join:billing', {'restaurantId': restaurantId});

    socket.onConnect((_) {
      print("connected");
    });

    socket.onDisconnect((__) {
      print(__);
    });

    socket.on('batch:created', (data) {});

    socket.on('session:opened', (data) {});

    socket.on('bill:generated', (data) {});

    socket.on('bill:paid', (data) {});

    socket.on('item:status:changed', (data) {});

    socket.on('menuItem:stock:changed', (data) {
      print(data);
      DashboardController ctrl = Get.put(DashboardController());

      for (var menu in ctrl.menus) {
        print(menu.id);
        print(data["menuItemId"]);
        if (menu.id == data["menuItemId"]) {
          menu.stockCount = data["stockCount"];
          menu.itemType = data["itemType"];
          menu.isOutOfStock = data["isOutOfStock"];
          update();
          ctrl.update();
          break;
        }
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    connect(authToken);
  }
}
