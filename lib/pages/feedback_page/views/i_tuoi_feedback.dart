import 'package:flutter/material.dart';
import 'package:music/api/gestionale_api/feedback_api.dart';
import 'package:music/models/feedbacks.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/helpers.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';

import '../../common_widget/custom_shimmer.dart';
import '../../common_widget/error_page.dart';
import '../../common_widget/list_item.dart';

class ITuoiFeedback extends StatelessWidget {
  const ITuoiFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FeedbackApi.getUserFeedbacks(
          context.read<UserProvider>().currentUser!.id.toString(),
        ),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const ShimmerListView();
          }

          if (snap.hasError) {
            return const ErrorPage(
              error: "Errore nel mostrare i tuoi Feedback",
            );
          }

          final data = snap.data as List<Feedbacks>;
          if (data.isEmpty) {
            return const EmptyPage(title: "Non hai inviato alcun Feedback !");
          }

          return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListItem(
                  height: context
                          .read<SettingsProvider>()
                          .config
                          .safeBlockVertical *
                      15,
                  title: formatDateToString(data[index].creatoIl),
                  leadingTitle: "Feedback ${index + 1}",
                  subTitle: data[index].content,
                  thirdLine: "",
                  leadingIcon: Icon(
                    Icons.category_outlined,
                    size: Theme.of(context).iconTheme.size! + 16,
                  ),
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRouter.feedbackProfile,
                    arguments: [data[index], index + 1],
                  ),
                );
              });
        });
  }
}
