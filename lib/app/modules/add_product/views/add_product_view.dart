import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController productCodeC = TextEditingController();
  final TextEditingController productNameC = TextEditingController();
  final TextEditingController productQuantityC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddProductView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: productCodeC,
            maxLength: 10,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  9,
                ),
              ),
              labelText: "Product Code",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: productNameC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  9,
                ),
              ),
              labelText: "Product Name",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            controller: productQuantityC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  9,
                ),
              ),
              labelText: "Product Quantity",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (productCodeC.text.isNotEmpty &&
                    productNameC.text.isNotEmpty &&
                    productQuantityC.text.isNotEmpty) {
                  controller.isLoading(true);

                  Map<String, dynamic> hasil = await controller.addProduct({
                    'code': productCodeC.text,
                    'name': productNameC.text,
                    'qty': int.tryParse(productQuantityC.text) ?? 0,
                  });

                  controller.isLoading(false);
                  Get.back();

                  Get.snackbar(hasil['error'] == true ? 'Error' : 'Succcess',
                      hasil['message']);
                } else {
                  Get.snackbar('Error', 'Semua data wajib diisi');
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(
                  controller.isLoading.isFalse ? 'ADD PRODUCT' : 'LOADING...'),
            ),
          ),
        ],
      ),
    );
  }
}
