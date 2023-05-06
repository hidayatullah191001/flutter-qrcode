import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_qr_code/app/data/models/product_model.dart';
import 'package:get_qr_code/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUCTS'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamProducts(),
          builder: (context, snapProduts) {
            if (snapProduts.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapProduts.data!.docs.isEmpty) {
              return const Center(
                child: Text('No products'),
              );
            }

            List<ProductsModel> allProducts = [];

            for (var element in snapProduts.data!.docs) {
              allProducts.add(ProductsModel.fromJson(element.data()));
            }

            return ListView.builder(
              itemCount: allProducts.length,
              padding: const EdgeInsets.all(20),
              itemBuilder: (context, index) {
                ProductsModel product = allProducts[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.detailProduct, arguments: product);
                    },
                    borderRadius: BorderRadius.circular(9),
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.code,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(product.name),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('Jumlah : ${product.qty}'),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: QrImage(
                              data: product.code,
                              size: 200.0,
                              version: QrVersions.auto,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
