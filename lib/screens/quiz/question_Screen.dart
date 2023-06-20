import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_quiz/screens/quiz/question_add_screen.dart';

import 'result_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen(
      {super.key, required this.title, required this.categoryId});

  final String title;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot> docs = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      // add category
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddQuestionsScreen(categoryId: categoryId)));
        },
        child: const Icon(Icons.add),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('quiz')
              .doc(categoryId)
              .collection('questions')
              .orderBy('questionNo')
              .snapshots(),
          builder: (context, snapshot) {
            //if not exist
            if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            //
            docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('No data found'));
            }

            // ui
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      //
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          //
                          QuizCard(docs: docs[index]),

                          //delete
                          IconButton(
                            onPressed: () async {
                              await deleteQuestion(
                                  categoryId: categoryId,
                                  questionId: docs[index].id);
                            },
                            icon: const Icon(Icons.delete_outline_outlined),
                          ),
                        ],
                      );
                    },
                  ),

                  //btn
                  Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    height: 48,
                    margin: const EdgeInsets.only(top: 32, bottom: 8),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                        answerSet: {},
                                        docs: docs,
                                      )));
                        },
                        child: Text('Submit Now'.toUpperCase())),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class QuizCard extends StatefulWidget {
  const QuizCard({super.key, required this.docs});
  final QueryDocumentSnapshot docs;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  String? selected = '';
  int total = 0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> options = widget.docs.get('options');

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title, total ques
            Text(
              '${widget.docs.get('questionNo')}. ${widget.docs.get('question')}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    // letterSpacing: .5,
                  ),
            ),

            const SizedBox(height: 8),

            // options
            ListView.separated(
              itemCount: options.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => RadioListTile<String>(
                title: Text(
                  options[index],
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                value: options[index],
                groupValue: selected,
                onChanged: (value) {
                  // print(value);
                  setState(() {
                    selected = value;

                    if (widget.docs.get('correctAnswer') + 1 ==
                        options.indexOf(options[index])) {
                      total += total;
                      print(total);
                    }
                  });
                },
                visualDensity: const VisualDensity(vertical: -3),
                dense: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// delete category
deleteQuestion({required String categoryId, required String questionId}) async {
  await FirebaseFirestore.instance
      .collection('quiz')
      .doc(categoryId)
      .collection('questions')
      .doc(questionId)
      .delete()
      .then((value) => Fluttertoast.showToast(msg: 'Delete successful'));
}
