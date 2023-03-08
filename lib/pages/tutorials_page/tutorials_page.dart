import 'package:flutter/material.dart';
import 'package:music/api/gestionale_api/categorie_api.dart';
import 'package:music/models/news_tutorial/categoria.dart';
import 'package:music/models/news_tutorial/tutorial.dart';
import 'package:music/pages/common_widget/custom_expansion_tile.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/helpers.dart';
import 'package:music/pages/common_widget/list_item.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../common_widget/custom_shimmer.dart';
import 'helper/tutorial_provider.dart';

//? trovare il modo di riciclarlo con tutorial_page => fanno stesse cose

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: riciclare con la pagina delle news
    return Column(children: [
      //* Pulsanti Per I fILTRI !
      _buildFiltersChip(),
      //* Lista dei Tutorial !
      Expanded(
        child: _buildTutorialList(context),
      ),
    ]);
  }

//* pulsanti per i filtri
  Widget _buildFiltersChip() => FutureBuilder(
        future: CategorieApi.getCategories(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SizedBox(height: 50.0);
          }
          if (snap.hasError) {
            return const Center(
              child: Text("Errore nel Caricare i filtri"),
            );
          }
          final data = snap.data as List<Categoria>;

          if (data.isEmpty) {
            return const EmptyPage(title: "Filtri non disponibili");
          }

          return CustomExpansionTile(
            title: const Text('Filtra Tutorial per:'),
            //subtitle: Text('Trailing expansion arrow icon'),
            children: data.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: ChoiceChip(
                  label: Text(e.name),
                  selectedColor: MainColor.secondaryColor,
                  selected: context.select<TutorialProvider, bool>(
                    (value) => value.idCategorie.contains(e.id),
                  ),
                  onSelected: (isSelected) => context
                      .read<TutorialProvider>()
                      .updateCategorie(e.id, isSelected),
                ),
              );
            }).toList(),
          );
        },
      );

  Widget _buildTutorialList(BuildContext context) => FutureBuilder(
      future: context.read<TutorialProvider>().getTutorials(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const ShimmerListView();
        }

        if (snap.hasError) {
          return const ErrorPage(
            error: "Errore nel Caricare i video Tutorial",
          );
        }

        return Consumer<TutorialProvider>(
          builder: (context, tutorialsProv, _) {
            final List<Tutorial> tutorialFiltered =
                tutorialsProv.filterTutorial();
            //* se non ho tutorial
            if (tutorialFiltered.isEmpty) {
              return const EmptyPage(
                title: "Non ci Sono Tutorial",
              );
            }
            //* ho elementi in lista, li mostro !
            return ListView.builder(
                itemCount: tutorialFiltered.length,
                itemBuilder: (context, index) {
                  return ListItem(
                    height: MediaQuery.of(context).size.height * 0.2,
                    title: tutorialFiltered[index].titolo,
                    leadingTitle: tutorialFiltered[index].categoria.name,
                    subTitle: tutorialFiltered[index].dateTime,
                    thirdLine: tutorialFiltered[index].desc,
                    leadingIcon: Icon(
                      Icons.category_outlined,
                    ),
                    onTap: () async {
                      //aproUrl
                      try {
                        await goToUrl(tutorialFiltered[index].url);
                      } catch (e) {
                        showSnackBar(context, "Errore nell'aprire il Video !");
                      }
                    },
                  );
                });
          },
        );
      });
}
