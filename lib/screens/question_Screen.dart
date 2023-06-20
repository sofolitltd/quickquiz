import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_quiz/screens/question_add_screen.dart';

import 'result_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> answerSet = {};
    List<QueryDocumentSnapshot> docs = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
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
              .orderBy('no')
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
                      Map<String, dynamic> options = docs[index].get('options');

                      //
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          //
                          QuizCard(
                            docs: docs[index],
                            answerSet: answerSet,
                          ),

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
                          print(answerSet);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                        answerSet: answerSet,
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

class QuizCard extends StatelessWidget {
  const QuizCard({super.key, required this.docs, required this.answerSet});

  final QueryDocumentSnapshot docs;
  final Map<String, dynamic> answerSet;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> options = docs.get('options');

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
              '${docs.get('no')}. ${docs.get('question')}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    // letterSpacing: .5,
                  ),
            ),

            const SizedBox(height: 8),

            // options
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: options.keys
                  .map(
                    (String key) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SelectedOptionCard(
                        docs: docs,
                        answerSet: answerSet,
                        options: options,
                        optionKey: key,
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class SelectedOptionCard extends StatefulWidget {
  const SelectedOptionCard(
      {super.key,
      required this.docs,
      required this.answerSet,
      required this.options,
      required this.optionKey});

  final QueryDocumentSnapshot docs;
  final Map<String, dynamic> answerSet;
  final Map<String, dynamic> options;
  final String optionKey;

  @override
  State<SelectedOptionCard> createState() => _SelectedOptionCardState();
}

class _SelectedOptionCardState extends State<SelectedOptionCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.options);
        if (widget.options.containsKey(widget.optionKey)) {
          setState(() {
            _isSelected = !_isSelected;
          });

          // remove if already exist
          widget.answerSet.remove(widget.docs.get('no'));

          // add
          widget.answerSet.putIfAbsent(
              widget.docs.get('no').toString(), () => widget.optionKey);

          print(widget.answerSet);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: _isSelected ? Colors.green.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: _isSelected ? Colors.green : Colors.blueGrey, width: .4),
        ),
        child:
            Text('(${widget.optionKey}) ${widget.options[widget.optionKey]}'),
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
