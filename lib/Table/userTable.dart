import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String userType;

  User({
    required this.name,
    required this.email,
    required this.userType,
  });
}

class UserTableController extends GetxController {
  var sWidth = Get.width;
  RxInt rowCount = 0.obs;
  RxList<User> userList = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("users").get();
      userList.assignAll(
        querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return User(
            name: data['username'] ?? '',
            email: data['email'] ?? '',
            userType: data['user_type'] ?? 'normal',
          );
        }).toList(),
      );
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}

class UserTable extends StatelessWidget {
  UserTable({super.key});

  final UserTableController controller = Get.put(UserTableController());

  @override
  Widget build(BuildContext context) {
    controller.fetchUserData();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          columnSpacing: 10,
          horizontalMargin: 10,
          header: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "User Table",
                  style: GoogleFonts.arsenal(
                    textStyle: TextStyle(
                      fontSize: controller.sWidth * 0.06,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          source: UserDataTableSource(controller.userList),
          columns: [
            DataColumn(
              label: Center(
                child: Text(
                  'Name',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arsenal(
                    textStyle: TextStyle(
                      fontSize: controller.sWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  'Email',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arsenal(
                    textStyle: TextStyle(
                      fontSize: controller.sWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  'User type',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arsenal(
                    textStyle: TextStyle(
                      fontSize: controller.sWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            DataColumn(
              label: Center(
                child: Text(
                  'Action',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.arsenal(
                    textStyle: TextStyle(
                      fontSize: controller.sWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
          rowsPerPage: 10,
          availableRowsPerPage: [10, 20, 50],
          onRowsPerPageChanged: (int? newRowsPerPage) {
            if (newRowsPerPage != null) {
              controller.rowCount.value = newRowsPerPage;
            }
          },
        ),
      ),
    );
  }
}

class UserDataTableSource extends DataTableSource {
  final List<User> userList;

  UserDataTableSource(this.userList);

  @override
  DataRow getRow(int index) {
    User user = userList[index];
    return DataRow(cells: [
      DataCell(
        Center(
          child: Text(
            user.name,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                  fontSize: Get.find<UserTableController>().sWidth * 0.03),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            user.email,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                  fontSize: Get.find<UserTableController>().sWidth * 0.03),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Text(
            user.userType,
            style: GoogleFonts.arsenal(
              textStyle: TextStyle(
                  fontSize: Get.find<UserTableController>().sWidth * 0.03),
            ),
          ),
        ),
      ),
      DataCell(
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  size: Get.find<UserTableController>().sWidth * 0.04,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.delete,
                  size: Get.find<UserTableController>().sWidth * 0.04,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userList.length;

  @override
  int get selectedRowCount => 0;
}
