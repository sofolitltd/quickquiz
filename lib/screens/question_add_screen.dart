import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final TextEditingController questionTEController = TextEditingController();
  final TextEditingController answerTEController = TextEditingController();
  final TextEditingController noTEController = TextEditingController();
  final TextEditingController optionAController = TextEditingController();
  final TextEditingController optionBController = TextEditingController();
  final TextEditingController optionCController = TextEditingController();
  final TextEditingController optionDController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
      ),
      body: Form(
        key: globalKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            //ques
            TextFormField(
              minLines: 3,
              maxLines: 5,
              controller: questionTEController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Question',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) => val!.isNotEmpty ? null : 'Enter question',
            ),

            const SizedBox(height: 24),

            Text(
              'Options:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            //opt A
            TextFormField(
              controller: optionAController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Option A'),
                hintText: 'Option A',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) => val!.isNotEmpty ? null : 'Enter option A',
            ),
            const SizedBox(height: 16),

            //opt B
            TextFormField(
              controller: optionBController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Option B'),
                hintText: 'Option B',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) => val!.isNotEmpty ? null : 'Enter option B',
            ),
            const SizedBox(height: 16),

            //opt C
            TextFormField(
              controller: optionCController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Option C'),
                hintText: 'Option C',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) => val!.isNotEmpty ? null : 'Enter option C',
            ),
            const SizedBox(height: 16),

            //opt D
            TextFormField(
              controller: optionDController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Option D'),
                hintText: 'Option D',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                border: OutlineInputBorder(),
              ),
              validator: (val) => val!.isNotEmpty ? null : 'Enter option D',
            ),

            const SizedBox(height: 16),

            // ans & no
            Row(
              children: [
                // ans
                Expanded(
                  child: TextFormField(
                    controller: answerTEController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      label: Text('Answer'),
                      hintText: 'Answer',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isNotEmpty ? null : 'Enter answer',
                  ),
                ),

                const SizedBox(width: 16),

                // ques no
                Expanded(
                  child: TextFormField(
                    controller: noTEController,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      label: Text('Question no'),
                      hintText: 'Question no',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) =>
                        val!.isNotEmpty ? null : 'Enter question no',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            // add
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (globalKey.currentState!.validate()) {
                        Map<String, dynamic> question = {
                          'no': int.parse(noTEController.text.trim()),
                          'question': questionTEController.text.trim(),
                          'answer':
                              answerTEController.text.trim().toLowerCase(),
                          'options': {
                            'a': optionAController.text.trim(),
                            'b': optionBController.text.trim(),
                            'c': optionCController.text.trim(),
                            'd': optionDController.text.trim(),
                          },
                        };

                        setState(() => _isLoading = true);
                        //
                        await FirebaseFirestore.instance
                            .collection('quiz')
                            .doc(widget.categoryId)
                            .collection('questions')
                            .doc()
                            .set(question)
                            .then((value) {
                          Navigator.pop(context);
                        });
                        setState(() => _isLoading = false);
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    )
                  : Text('Add Now'.toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
