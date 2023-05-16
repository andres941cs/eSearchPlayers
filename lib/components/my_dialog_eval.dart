import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esearchplayers/data/user_data.dart';
import 'package:flutter/material.dart';

class EvaluateDialog extends StatefulWidget {
  final UserData teamMate;
  const EvaluateDialog({super.key, required this.teamMate});

  @override
  State<EvaluateDialog> createState() => _EvaluateDialogState();
}

final List<String> _options = ['Lower_Rank', 'Equal_Rank', 'Higher_Rank'];

class _EvaluateDialogState extends State<EvaluateDialog> {
  String selectedValue = _options[1];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.teamMate.username),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Is the player currently in the rank they should be in?'),
          RadioListTile(
            activeColor: Colors.red,
            title: const Text('Lower Rank'),
            value: _options[0],
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value.toString();
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.red,
            title: const Text('Equal Rank'),
            value: _options[1],
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value.toString();
              });
            },
          ),
          RadioListTile(
            activeColor: Colors.red,
            title: const Text('Higher Rank'),
            value: _options[2],
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value.toString();
              });
            },
          ),
        ],
      ),
      //El jugador se encuentra actualmente en el rango que debería estar?
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // background// foreground
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // background// foreground
            ),
            onPressed: () async {
              _sendEvaluation(widget.teamMate.email);
              Navigator.of(context).pop();
            },
            child: const Text('Send'))
      ],
    );
  }

  void _sendEvaluation(String email) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('rankSystem').doc(email);
    documentReference.set({
      'email': email,
      'evaluation': FieldValue.arrayUnion([selectedValue]),
    });
  }
}
