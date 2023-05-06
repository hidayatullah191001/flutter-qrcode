import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_qr_code/app/data/models/product_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);
  final ProductsModel product = Get.arguments;

  final TextEditingController productCodeC = TextEditingController();
  final TextEditingController productNameC = TextEditingController();
  final TextEditingController productQuantityC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    productCodeC.text = product.code;
    productNameC.text = product.name;
    productQuantityC.text = "${product.qty}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('DETAIL PRODUCT'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImage(
                  data: product.code,
                  size: 200.0,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            autocorrect: false,
            controller: productCodeC,
            keyboardType: TextInputType.emailAddress,
            readOnly: true,
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
              if (controller.isLoadingUpdate.isFalse) {
                if (productNameC.text.isNotEmpty &&
                    productQuantityC.text.isNotEmpty) {
                  controller.isLoadingUpdate(true);

                  Map<String, dynamic> hasil = await controller.updateProduct({
                    'id': product.productId,
                    'name': productNameC.text,
                    'qty': int.tryParse(productQuantityC.text) ?? 0,
                  });

                  controller.isLoadingUpdate(false);

                  Get.snackbar(hasil['error'] == true ? 'Error' : 'Succcess',
                      hasil['message']);
                } else {
                  Get.snackbar(
                    'Error',
                    'Semua data wajib diisi',
                    duration: const Duration(
                      seconds: 2,
                    ),
                  );
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
              () => Text(controller.isLoadingUpdate.isFalse
                  ? 'UPDATE PRODUCT'
                  : 'LOADING...'),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Delete product",
                middleText: "Are you sure to delete this product?",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      controller.isLoadingDelete(true);
                      Map<String, dynamic> hasil =
                          await controller.deleteProduct(product.productId);
                      Get.back(); //Tutup dialog
                      Get.back(); //Balik Ke page all product
                      Get.snackbar(
                          hasil['error'] == true ? 'Error' : 'Succcess',
                          hasil['message']);
                      controller.isLoadingDelete(false);
                    },
                    child: Obx(
                      () => controller.isLoadingDelete.isFalse
                          ? const Text('DELETE PRODUCT')
                          : Container(
                              width: 15,
                              height: 15,
                              padding: const EdgeInsets.all(1),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
            child: Text(
              'Delete Product',
              style: TextStyle(color: Colors.red.shade900),
            ),
          ),
        ],
      ),
    );
  }
}
