import 'package:flutter/material.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({Key? key}) : super(key: key);

  @override
  State<QueueScreen> createState() => QueueScreenState();
}

class QueueScreenState extends State<QueueScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [const Text("Queue"), Text("24")],
            ),
            Expanded(
              child: Container(
                color: Colors.amber,
                child: DraggableScrollableSheet(
                    expand: true,
                    maxChildSize: 0.9,
                    minChildSize: 0.4,
                    initialChildSize: 0.9,
                    builder: (context, snapshot) {
                      return ListView.builder(itemBuilder: ((context, index) {
                        return ListTile();
                      }));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
