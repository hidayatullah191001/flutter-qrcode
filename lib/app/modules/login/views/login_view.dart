import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_qr_code/app/controllers/auth_controller.dart';
import 'package:get_qr_code/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC =
      TextEditingController(text: 'admin@gmail.com');
  final TextEditingController passwordC =
      TextEditingController(text: 'admin1234');
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              labelText: "Email",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => TextField(
              autocorrect: false,
              obscureText: controller.isHidden.value,
              controller: passwordC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isHidden.toggle();
                  },
                  icon: Icon(
                    controller.isHidden.value == false
                        ? Icons.remove_red_eye
                        : Icons.remove_red_eye_outlined,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                labelText: "Password",
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                controller.isLoading(true);
                if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
                  Map<String, dynamic> hasil =
                      await authController.login(emailC.text, passwordC.text);
                  if (hasil['error'] == true) {
                    Get.snackbar('Error', hasil['message']);
                  } else {
                    Get.offAllNamed(Routes.home);
                  }
                } else {
                  Get.snackbar("Error", "Email dan password wajib diisi");
                }
                controller.isLoading(false);
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(controller.isLoading.isFalse ? 'Login' : 'Loading...'),
            ),
          ),
        ],
      ),
    );
  }
}
