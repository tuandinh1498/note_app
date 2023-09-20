import 'package:flutter/material.dart';
import 'package:note_app/core/configs/them_data.dart';
import 'package:note_app/core/const/images_name.dart';
import 'package:note_app/main.dart';

import '../../core/configs/sizes.dart';
import '../main_page/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future<void> navigateToHomePage() async {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    navigateToHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              ImageName.iconApp,
              height: SizeConfig.displaySizeByWidth(context, 100),
              width: SizeConfig.displaySizeByWidth(context, 100),
            )),
            const SizedBox(height: 20,),
            Text("Quick Notes",
                style: Theme.of(context).textTheme.displayLarge),
            SizedBox(
              height: SizeConfig.displaySizeByHeight(context, 50),
            ),
            Text("Ghi chú dễ dàng, nhanh chóng",
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20,),
            Text("Ghi chú mọi lúc, mọi nơi",
                style: Theme.of(context).textTheme.displayMedium),
          ],
        ),
      ),
    );
  }
}
