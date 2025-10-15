import 'package:bee_kind/common/new_address_screen.dart';
import 'package:bee_kind/widgets/address_type.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Address",
      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNewAddressScreen()),
          ),
          text: "Add New Address",
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddNewAddressScreen(isEdit: true)),
            ),
            child: AddressType(
              isChecked: false,
              hasCheckBox: false,
              type: "Home",
              onChanged: (value) {},
            ),
          ),
          AddressType(
            isChecked: false,
            hasCheckBox: false,
            type: "Office",
            onChanged: (value) {},
          ),
          AddressType(
            isChecked: false,
            hasCheckBox: false,
            type: "Apartment",
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
