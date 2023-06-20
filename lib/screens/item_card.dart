import 'package:flutter/material.dart';
import 'package:quick_quiz/screens/scale_model.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({
    Key? key,
    required this.index,
    required this.testScale,
    required this.testAnswer,
  }) : super(key: key);
  final int index;
  final List testScale;
  final Map testAnswer;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  ScaleModel? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey.shade300,
          child: Column(
            children: widget.testScale
                .map(
                  (option) => RadioListTile<ScaleModel>(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    value: option,
                    groupValue: _selectedOption,
                    onChanged: (value) {
                      print(value!.id);
                      setState(() {
                        _selectedOption = value;

                        //
                        // widget.testAnswer
                        //     .remove(widget.testItems[widget.index].id);
                        // widget.testAnswer.putIfAbsent(
                        //     widget.testItems[widget.index].id, () => value.id);
                        // print(widget.testAnswer);
                      });
                    },
                    visualDensity: const VisualDensity(vertical: -3),
                    dense: true,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
