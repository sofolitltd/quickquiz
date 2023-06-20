import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quick_quiz/screens/quiz/quiz_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // image. ,name
            Row(
              children: [
                //image
                Container(
                  height: 72,
                  width: 72,
                  decoration: BoxDecoration(
                      color: Colors.purple.shade100, shape: BoxShape.circle),
                ),

                const SizedBox(width: 16),

                // name, point
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //title
                      Text(
                        // docs[index].get('title').toString(),
                        'Name',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                      ),
                      const SizedBox(height: 6),
                      //point
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueGrey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          // docs[index].get('title').toString(),
                          'Student',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                    letterSpacing: .5,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // contact
            Column(
              children: [
                //
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.contact_page_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Contact'),
                  subtitle: const Text('user information'),
                ),

                //
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 2),

                      //
                      Text(
                        'email',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),

                      const Divider(),

                      //
                      Text(
                        'Phone',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 2),

                      //
                      Text(
                        "mobile",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            //log
            Column(
              children: [
                //
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.settings_applications_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Settings'),
                  subtitle: const Text('profile settings'),
                ),

                //
                GestureDetector(
                  onTap: () {
                    logOutDialog(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        // logout
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              //
                              Text(
                                'leave for now',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),

                              const SizedBox(height: 2),

                              //
                              Text(
                                'Log Out',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        //icon
                        const Icon(
                          Icons.login_outlined,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// logout dialog
logOutDialog(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Log out'),
      content: const Text('Are you sure to log out?'),
      actionsPadding: const EdgeInsets.only(
        right: 12,
        left: 12,
        bottom: 12,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        //
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'.toUpperCase()),
        ),

        //
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut().then(
              (value) {
                //todo: change later
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                    (route) => false);
              },
            );
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text('Log out'.toUpperCase())),
        ),
      ],
    ),
  );
}
