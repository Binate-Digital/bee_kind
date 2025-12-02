import 'package:bee_kind/controllers/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> deleteCardConfirmationDialog(
  BuildContext context,
  String cardId,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Delete Card",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              Text(
                "Are you sure you want to delete this card?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // CANCEL
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      minimumSize: Size(120, 40),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),

                  // DELETE → CALL API
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: Size(120, 40),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Close dialog first
                      await Get.find<StoreController>().deleteCard(
                        context,
                        cardId,
                      );
                    },
                    child: Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
