import 'package:bee_kind/common/new_address_screen.dart';
import 'package:bee_kind/controllers/store_controller.dart';
import 'package:bee_kind/models/data_models/address_data_model.dart';
import 'package:bee_kind/widgets/address_type.dart';
import 'package:bee_kind/widgets/custom_app_bar.dart';
import 'package:bee_kind/widgets/custom_button.dart';
import 'package:bee_kind/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final controller = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBaseView(
      title: "Address",

      button: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SizedBox(
          height: 60.h,
          child: CustomButton(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddNewAddressScreen(isEdit: false),
                ),
              );
              await controller.fetchUserAddresses();
            },
            text: "Add New Address",
          ),
        ),
      ),

      // 🔥 FIX: Use GetBuilder for instant UI updates
      body: GetBuilder<StoreController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }

          final addresses = controller.userAddresses.value?.data;

          if (addresses == null || addresses.isEmpty) {
            return Center(
              child: CustomText(
                text: "No addresses found.\nAdd one to continue.",
                fontSize: 18.sp,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.only(top: 20.h, bottom: 80.h),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: addresses.length,
            itemBuilder: (_, index) {
              final addr = addresses[index];
              final isSelected = controller.selectedAddressIndex.value == index;

              return GestureDetector(
                onTap: () => controller.selectAddress(index),
                child: AddressType(
                  isChecked: isSelected,
                  isEdit: true,
                  isDefault: addr.isDefault == true,
                  type: addr.addressName ?? "Not Specified",
                  address: addr.address ?? "Not Specified",

                  onEditTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddNewAddressScreen(
                          isEdit: true,
                          address: AddressDataModel(
                            addressId: addr.id,
                            addressName: addr.addressName,
                            apartmentNumber: addr.apartmentNumber,
                            floorNumber: addr.floorNumber,
                            isDefault: addr.isDefault,
                          ),
                        ),
                      ),
                    );

                    await controller.fetchUserAddresses();
                  },

                  onChanged: (_) => controller.selectAddress(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
