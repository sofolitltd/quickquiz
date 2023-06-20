import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_quiz/screens/question_Screen.dart';

import 'category_add_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quiz'),
      ),

      // add category
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddCategoryScreen()));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('quiz')
              .orderBy('title')
              .snapshots(),
          builder: (context, snapshot) {
            //if not exist
            if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('Welcome'));
            }

            // ui
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionScreen(categoryId: docs[index].id),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              //image
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    shape: BoxShape.circle),
                              ),

                              const SizedBox(width: 16),

                              // title, total ques
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //title
                                    Text(
                                      docs[index].get('title').toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .5,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    //total ques
                                    TotalQuestions(id: docs[index].id),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //delete
                      IconButton(
                        onPressed: () async {
                          await deleteCategory(id: docs[index].id);
                        },
                        icon: const Icon(Icons.delete_outline_outlined),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
    );
  }
}

//total
class TotalQuestions extends StatelessWidget {
  const TotalQuestions({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('quiz')
            .doc(id)
            .collection('questions')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('');
          }
          return Text(
            '${snapshot.data!.size} questions',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
          );
        });
  }
}

// delete category
deleteCategory({required String id}) async {
  await FirebaseFirestore.instance
      .collection('quiz')
      .doc(id)
      .delete()
      .then((value) => Fluttertoast.showToast(msg: 'Delete successful'));
}
