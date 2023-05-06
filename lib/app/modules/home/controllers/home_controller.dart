import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_qr_code/app/data/models/product_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxList<ProductsModel> allProducts = List<ProductsModel>.empty().obs;

  void downloadCatalog() async {
    final pdf = pw.Document();

    var getData = await firestore.collection('products').get();
    //reset all products
    allProducts([]);
    // isi data dari database
    for (var element in getData.docs) {
      allProducts.add(ProductsModel.fromJson(element.data()));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData = List.generate(
            allProducts.length,
            (index) {
              ProductsModel product = allProducts[index];
              return pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${index + 1}.',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${product.code}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${product.name}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.Text(
                      '${product.qty}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(20),
                    child: pw.BarcodeWidget(
                      color: PdfColors.black,
                      barcode: pw.Barcode.qrCode(),
                      data: '${product.code}',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              );
            },
          );

          return [
            pw.Center(
              child: pw.Text(
                'CATALOG PRODUCTS',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 24),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.black,
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        'No',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        'Product Code',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        'Product Name',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        'Quantity',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        'QR Code',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            )
          ];
        },
      ),
    );

    // simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di direktori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocument.pdf');

    //mamasukkan data bytes ke file kosong
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getProductByProductId(String codeBarang) async {
    try {
      var hasil = await firestore
          .collection('products')
          .where("code", isEqualTo: codeBarang)
          .get();
      // print('Hasil barcode : ${hasil.data()}');
      if (hasil.docs.isEmpty) {
        throw "error";
      }

      Map<String, dynamic> data = hasil.docs.first.data();

      return {
        "error": false,
        "message": "Berhasil mendapatkan detail product",
        "data": ProductsModel.fromJson(data),
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak mendapatkan detail product",
      };
    }
  }
}
