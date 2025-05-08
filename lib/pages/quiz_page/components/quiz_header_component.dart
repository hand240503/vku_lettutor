import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 180,
            padding: const EdgeInsets.only(
              top: 20,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/images/quiz_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Play",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "And be the first!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Consumer<AuthProvider>(
                  builder: (
                    BuildContext context,
                    AuthProvider authProvider,
                    Widget? child,
                  ) {
                    final user = authProvider.currentUser;
                    return CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        user?.avatar ??
                            "https://randomuser.me/api/portraits/men/75.jpg",
                      ),
                      // backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      // child: Text(
                      //   "LS",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: Theme.of(context).colorScheme.onSecondaryContainer,
                      //   ),
                      // ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
