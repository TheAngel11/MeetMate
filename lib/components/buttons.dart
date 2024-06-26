import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
    final VoidCallback onPressed;
    final String text;

    const MainButton({Key? key, required this.onPressed,
        required this.text}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: const EdgeInsets.all(15),
            width: 300,
            height: 50,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                    ),
                ),
                onPressed: () {
                    onPressed();
                },
                child: Text(
                    text,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff6c6265)
                    )
                ),
            ),
        );
    }
}

class NoBackgroundButton extends StatelessWidget {
    final VoidCallback onPressed;
    final String text;

    const NoBackgroundButton({
        Key? key,
        required this.onPressed,
        required this.text,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return TextButton(
            onPressed: onPressed,
            child: Text(
                text,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                ),
            ),
        );
    }
}

class ImageButton extends StatelessWidget {
    final VoidCallback onPressed;

    const ImageButton({
        Key? key,
        required this.onPressed,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            width: 200,
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.transparent,
                ),
                child: const Text('Pick Image'),
            ),
        );
    }
}


