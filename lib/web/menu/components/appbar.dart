import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../shared/colors.dart';
import '../../../shared/custom_text.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return AppBar(
      backgroundColor: vert(),
      iconTheme: const IconThemeData(color: Colors.white),
      title: isMobile? Row(
        children: [
          CustomText('TrashApp Admin', tex: 1.5, fontWeight: FontWeight.w700,),
        ],
      ):
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/logos/logo1.png'),
            ),
          ),
          CustomText('TrashApp Admin', tex: 1.5, fontWeight: FontWeight.w700,),
        ],
      ),
      centerTitle: false,
      elevation: 4,
      actions: [
        CustomText('admin',),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PopupMenuButton<void>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: CustomText('se deconnecter', color: noir(), ),
                onTap: () {
                  // Sign out logic
                },
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                'assets/icons/person.svg',
                height: 25,
                width: 25,
                semanticsLabel: 'person',
              ),
            ),
          ),
        ),
        const Gap(8),
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
