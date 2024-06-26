// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:urven/ui/theme/palette.dart';
import 'package:urven/ui/widgets/sign_in_card.dart';
import 'package:urven/ui/widgets/sign_up_card.dart';
import 'package:urven/utils/lu.dart';
import 'package:urven/utils/screen_size_configs.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SSC().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: SSC.p120),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   LU.of(context).app_name,
                //   style: const TextStyle(
                //     fontSize: SSC.p30,
                //     fontWeight: FontWeight.w700,
                //     color: Palette.MAIN,
                //   ),
                // ),
                Image.asset(
                  'assets/images/logo.png',
                  width: SSC.p130,
                  height: SSC.p130,
                  fit: BoxFit.contain,
                ),
                // const SizedBox(
                //   height: SSC.p20,
                // ),
                // Text(
                //   LU.of(context).login_or_create_account,
                //   style: const TextStyle(
                //     fontSize: SSC.p17,
                //     fontWeight: FontWeight.w500,
                //     color: Colors.grey,
                //   ),
                // )
              ],
            ),
            const SizedBox(height: SSC.p36),
            Center(
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: SSC.p240),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SSC.p25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TabBar(
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      indicator: BoxDecoration(
                        color: Palette.MAIN,
                        borderRadius: BorderRadius.circular(SSC.p25),
                      ),
                      indicatorPadding: const EdgeInsets.all(SSC.p5),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      labelStyle: const TextStyle(
                        fontSize: SSC.p14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: SSC.p14,
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              LU.of(context).login,
                              style: const TextStyle(
                                fontSize: SSC.p14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              LU.of(context).registration,
                              style: const TextStyle(
                                fontSize: SSC.p14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SSC.p31),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  SignInCard(),
                  SignUpCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
