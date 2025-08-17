import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:spin_piece/pages/wheel_page.dart';
import 'package:spin_piece/providers/wheel_data_provider.dart';

class GoBack extends StatelessWidget {
  final String message;
  final VoidCallback onReset;

  const GoBack({super.key, required this.message, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(top: 12, bottom: 12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    height: 50,
                    width: 100,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    height: 50,
                    width: 100,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 2),
                      ),
                      onPressed: () {
                        Provider.of<WheelDataProvider>(
                          context,
                          listen: false,
                        ).resetWheel();
                        onReset();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => WheelPage(onReset: onReset),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
                        'yes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
