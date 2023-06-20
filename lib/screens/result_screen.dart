import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.answerSet, required this.docs});

  final Map<String, dynamic> answerSet;
  final List<QueryDocumentSnapshot> docs;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    List totalCorrectAnswer = [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //
            // Text('Correct ' +
            //     totalCorrectAnswer.length.toString() +
            //     ' / ' +
            //     widget.answerSet.length.toString()),

            //
            Container(
              height: 40,
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    String questionNo = widget.docs[index].get('no').toString();
                    String correctAnswer = widget.docs[index].get('answer');
                    String selectedAnswer = widget.answerSet[questionNo];
                    print("$questionNo => $selectedAnswer");

                    if (selectedAnswer == correctAnswer) {
                      print("correct");
                      totalCorrectAnswer.add(questionNo);

                      print(totalCorrectAnswer);
                    } else {
                      print("wrong");
                    }

                    //
                    return Container(
                        decoration: BoxDecoration(
                          color: (selectedAnswer == correctAnswer)
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Text(questionNo.toString()));
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: widget.docs.length),
            ),
          ],
        ),
      ),
    );
  }
}
