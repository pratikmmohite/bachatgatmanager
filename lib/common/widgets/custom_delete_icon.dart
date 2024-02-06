import 'package:flutter/material.dart';

typedef CustomDeleteIconChangeFunc<T> = void Function(T option);

class CustomDeleteIcon<T> extends StatefulWidget {
  final T item;
  final Widget? content;
  final CustomDeleteIconChangeFunc<T>? onAccept;
  final CustomDeleteIconChangeFunc<T>? onCancel;
  const CustomDeleteIcon(
      {super.key,
      required this.onAccept,
      this.onCancel,
      required this.item,
      this.content});

  @override
  State<CustomDeleteIcon<T>> createState() => _CustomDeleteIconState<T>();
}

class _CustomDeleteIconState<T> extends State<CustomDeleteIcon<T>> {
  Future<void> showDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure to delete this?'),
          content: widget.content,
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                if (widget.onCancel != null) {
                  widget.onCancel!(widget.item);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
              ),
              onPressed: () {
                try {
                  if (widget.onAccept != null) {
                    widget.onAccept!(widget.item);
                  }
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDeleteDialog();
      },
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
    );
  }
}
