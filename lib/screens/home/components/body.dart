import 'package:flutter/material.dart';
import 'package:plantapp/constants.dart';
import 'package:plantapp/screens/home/components/featured_plants.dart';
import 'package:plantapp/screens/home/components/header_with_serachbox.dart';
import 'package:plantapp/screens/home/components/recomended_plants.dart';
import 'package:plantapp/screens/home/components/title_with_more_btn.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWithSerachbox(size: size),
            TitleWithMoreBtn(title: "Recomended", press: () {}),
            RecomendedPlants(),
            TitleWithMoreBtn(title: "Featured Plants", press: () {}),
            FeaturedPlants(),
            SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
    );
  }
}
