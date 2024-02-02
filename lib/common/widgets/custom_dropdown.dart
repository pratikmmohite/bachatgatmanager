import 'package:flutter/material.dart';

typedef CustomOptionChangeFunc = void Function(CustomDropDownOption option);

class CustomDropDown extends StatefulWidget {
  final String label;
  final String? value;
  final List<CustomDropDownOption> options;
  final CustomOptionChangeFunc? onChange;
  const CustomDropDown({
    super.key,
    required this.label,
    this.value,
    this.options = const [],
    this.onChange,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  Future<CustomDropDownOption?> showOptions() async {
    List<Widget> optionsList = widget.options
        .map((e) => ListTile(
              leading: widget.value == e.value
                  ? const Icon(Icons.check_circle)
                  : null,
              onTap: () {
                Navigator.of(context).pop(e);
              },
              title: Text(e.label),
            ))
        .toList();
    return showDialog<CustomDropDownOption?>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.label),
          content: SingleChildScrollView(
            child: ListBody(
              children: optionsList,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        var option = await showOptions();
        if (widget.onChange != null && option != null) {
          widget.onChange!(option);
        }
      },
      child: Text(widget.label),
    );
  }
}

class CustomDropDownOption {
  String label;
  String value;
  CustomDropDownOption(this.label, this.value);
}
