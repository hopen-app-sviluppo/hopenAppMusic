import 'package:flutter/material.dart';
import 'package:music/models/news_tutorial/news.dart';
import 'package:music/pages/common_widget/custom_expansion_tile.dart';
import 'package:music/pages/common_widget/custom_shimmer.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/pages/common_widget/list_item.dart';
import 'package:provider/provider.dart';

import '../../../api/gestionale_api/categorie_api.dart';
import '../../../models/news_tutorial/categoria.dart';
import '../../../theme.dart';
import 'helper/news_provider.dart';

//? trovare il modo di riciclarlo con tutorial_page => fanno stesse cose

//* pagina delle News
class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //* Pulsanti Per I fILTRI !
      _buildFiltersChip(),
      //* lista delle news
      Expanded(
        child: _buildNewsList(context),
      )
    ]);
  }

//* Chip per settare i filtri
  Widget _buildFiltersChip() => FutureBuilder(
        future: CategorieApi.getCategories(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (snap.hasError) {
            return const ErrorPage(
              error: "Errore nel Caricare i filtri",
            );
          }
          final data = snap.data as List<Categoria>;

          if (data.isEmpty) {
            return const EmptyPage(title: "Filtri non Disponibili");
          }
          return CustomExpansionTile(
            title: const Text('Filtra News per:'),
            children: data.map((categoria) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: ChoiceChip(
                  label: Text(categoria.name),
                  selectedColor: MainColor.secondaryColor,
                  selected: context.select<NewsProvider, bool>(
                    (value) => value.idCategorie.contains(categoria.id),
                  ),
                  onSelected: (isSelected) => context
                      .read<NewsProvider>()
                      .updateCategorie(categoria.id, isSelected),
                ),
              );
            }).toList(),
          );
        },
      );

  Widget _buildNewsList(BuildContext context) => FutureBuilder(
      future: context.read<NewsProvider>().getNews(),
      builder: (context, snap) {
        // * Mostro pagina di caricamento !
        if (snap.connectionState == ConnectionState.waiting) {
          return const ShimmerListView();
        }

        if (snap.hasError) {
          return const ErrorPage(
            error: "Errore nel Caricare le News",
          );
        }

        return Consumer<NewsProvider>(
          builder: (context, newsProv, _) {
            final List<News> newsFiltered = newsProv.filterNews();
            //* se non ho tutorial
            if (newsFiltered.isEmpty) {
              return const EmptyPage(
                title: "Non ci Sono News",
              );
            }
            return ListView.builder(
                itemCount: newsFiltered.length,
                itemBuilder: (context, index) {
                  final news = newsFiltered[index];
                  return ListItem(
                    height: MediaQuery.of(context).size.height * 0.2,
                    title: news.titolo,
                    leadingTitle: news.categoria.name,
                    subTitle: news.testo,
                    leadingIcon: CircleAvatar(
                      child: Image.network(news.copertina),
                    ),
                    onTap: null,
                  );
                  /* return Card(
                    child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(newsFiltered[index].titolo),
                                Text(newsFiltered[index].dateTime),
                              ],
                            ),
                            Text(
                              "categoria: ${newsFiltered[index].categoria.name}",
                            ),
                          ],
                        ),
                        subtitle: Text(newsFiltered[index].testo),
                        leading: CircleAvatar(
                          child: Image.network(newsFiltered[index].copertina),
                        )),
                  );*/
                });
          },
        );
      });
}
