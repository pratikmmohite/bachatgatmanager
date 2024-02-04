import 'package:flutter/material.dart';

typedef CustomOptionChangeFunc<T> = void Function(
    CustomDropDownOption<T> option);

class CustomDropDown<T> extends StatefulWidget {
  final String label;
  final String? value;
  final List<CustomDropDownOption<T>> options;
  final CustomOptionChangeFunc<T>? onChange;
  const CustomDropDown({
    super.key,
    required this.label,
    this.value,
    this.options = const [],
    this.onChange,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  CustomDropDownOption<T>? selectedOptionObject;
  Future<CustomDropDownOption<T>?> showOptions() async {
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
    return showDialog<CustomDropDownOption<T>?>(
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
  void initState() {
    var x = widget.options.where((op) => op.value == widget.value);
    selectedOptionObject = x.isNotEmpty ? x.first : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              var option = await showOptions();
              try {
                setState(() {
                  selectedOptionObject = option;
                });
                if (option != null && widget.onChange != null) {
                  widget.onChange!(option);
                }
              } catch (e) {
                print(e);
              }
            },
            child: selectedOptionObject != null
                ? Text(selectedOptionObject?.label ?? "")
                : Text(widget.label),
          ),
        ),
      ],
    );
  }
}

class CustomDropDownOption<T> {
  String label;
  String value;
  T valueObj;
  CustomDropDownOption(this.label, this.value, this.valueObj);
}
