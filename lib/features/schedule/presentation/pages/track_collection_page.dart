import 'package:flutter/material.dart';
import 'package:recycla_bin/core/widgets/user_scaffold.dart';

class TrackCollectionPage extends StatefulWidget {
  const TrackCollectionPage({super.key});

  @override
  State<TrackCollectionPage> createState() => _TrackCollectionPageState();
}

class _TrackCollectionPageState extends State<TrackCollectionPage> {
  @override
  Widget build(BuildContext context) {
    return UserScaffold(
        body: Text('track'),
        title: 'Track Collection'
    );
  }
}
