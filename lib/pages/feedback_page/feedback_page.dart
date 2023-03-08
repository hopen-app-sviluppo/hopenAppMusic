import 'package:flutter/material.dart';
import 'package:music/helpers.dart';
import 'package:music/pages/feedback_page/views/i_tuoi_feedback.dart';
import 'package:music/pages/feedback_page/views/invia_feedback.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(child: const Text("La tua opinione è importante ")),
        centerTitle: true,
        bottom: _buildTabBar(),
      ),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(controller: _tabController, tabs: const [
      Tab(
        icon: Icon(Icons.send_outlined),
        child: FittedBox(child: Text("Invia un Feedback")),
      ),
      Tab(
        icon: Icon(
          Icons.format_list_numbered_outlined,
        ),
        child: Text("I tuoi Feedback"),
      ),
    ]);
  }

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            GestureDetector(
              onTap: () => checkFocus(context),
              child: const InviaFeedback(),
            ),
            const ITuoiFeedback(),
          ],
        ),
      );
}
