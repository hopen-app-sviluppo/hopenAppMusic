import 'package:music/models/feedbacks.dart';
import 'package:music/models/social_models/follower.dart';
import 'package:music/models/social_models/post.dart';
import 'package:music/pages/assistito_pages/assistito_forms_page/assistito_forms_page.dart';
import 'package:music/pages/credenziali_page/credenziali_page.dart';
import 'package:music/pages/feedback_page/views/feedback_profile.dart';
import 'package:music/pages/forms_pages/list_compilazioni_page/list_compilazioni_page.dart';
import 'package:music/pages/grafici_pages/dettaglio_grafico.dart';
import 'package:music/pages/grafici_pages/helpers/grafici_client_provider.dart';
import 'package:music/pages/grafici_pages/grafici_page.dart';
import 'package:music/pages/network_pages/chat_op_cloud_page/chat_op_cloud_page.dart';
import 'package:music/pages/network_pages/follower_following_page.dart/follower_page.dart';
import 'package:music/pages/network_pages/social_feed_page/lista_commenti_page/helper/lista_comment_provider.dart';
import 'package:music/pages/network_pages/social_feed_page/lista_commenti_page/lista_commenti_page.dart';
import 'pages/assistito_pages/crea_assistito_page/crea_assistito.dart';
import 'pages/assistito_pages/crea_assistito_page/helpers/crea_assistito_provider.dart';
import 'pages/assistito_pages/profilo_assistito_page/profilo_assistito_page.dart';
import 'pages/feedback_page/feedback_page.dart';
import 'pages/forms_pages/scelta_form_page/scelta_form_page.dart';
import 'pages/initial_pages/authentication/authentication_page.dart';
import 'pages/initial_pages/authentication/helper/auth_validator.dart';
import 'pages/initial_pages/main_page/main_page.dart';
import 'pages/initial_pages/splash_page.dart';
import 'pages/launch_page.dart';

import 'models/cliente.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//gestione del Routing all'interno dell'app
class AppRouter {
  static const initialPage = "initial";
  static const splash = "splash";
  static const auth = "auth";
  static const creaAssistito = "crea_assistito";
  static const listaAssistiti = "lista_assistiti";
  static const profiloAssistito = "profilo_assistito";
  static const profiloUtente = "profilo_utente";
  static const feedbackPage = "feed";
  static const tutorialPage = "tutorial";
  static const newtorkPage = "network";
  //pagina che mostra la lista dei form => o compilati dall'utente oppure compilati per l'assistito
  static const formListPage = "list_form";
  static const sceltaFormPage = "scelta_form";
  static const formCompilato = "compilato_form";
  static const grafici = "grafici";
  static const credenziali = "credenziali";
  static const feedbackProfile = "feed_profile";
  static const followerPage = "follower";
  static const dettaglioGrafico = "grafico";
  static const commentiPostSocial = "commenti";
  static const socialChat = "chat";

  static Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {

      //* pagina iniziale (si avvia quando viene lanciata l'app)
      case initialPage:
        return MaterialPageRoute<void>(
          builder: (_) => const LaunchPage(),
        );

      //* pagina di caricamento (viene lanciata quando controllo se utente è gia loggato oppure no)
      case splash:
        return MaterialPageRoute<void>(
          builder: (_) => const SplashPage(),
        );

      //* pagina di autenticazione (login-signup)
      case auth:
        return MaterialPageRoute<void>(
          builder: (_) => ChangeNotifierProvider<AuthValidator>(
            create: (context) => AuthValidator(),
            child: const AuthenticationPage(),
          ),
        );
//* pagina profilo utente
      case profiloUtente:
        return MaterialPageRoute<void>(
          builder: (_) => const MainPage(),
        );
      //*pagina Network
      case newtorkPage:
        return MaterialPageRoute<void>(
          builder: (_) => const MainPage(
            index: 1,
          ),
        );

      //* pagina dei tutorial
      case tutorialPage:
        return MaterialPageRoute<void>(
          builder: (_) => const MainPage(
            index: 2,
          ),
        );
      //* pagina che mostra la lista degli assistiti di quell'utente
      case listaAssistiti:
        return MaterialPageRoute<void>(
          builder: (_) => const MainPage(
            index: 3,
          ),
        );

      //* pagina dei feedback
      case feedbackPage:
        return MaterialPageRoute<void>(
          builder: (_) => const FeedbackPage(),
        );

      //* pagina creazione assistito
      case creaAssistito:
        return MaterialPageRoute<void>(
          builder: (context) => ChangeNotifierProvider<CreaAssistitoProvider>(
            create: (_) => CreaAssistitoProvider(),
            child: const CreaAssistito(),
          ),
        );

      //* pagina che mostra il profilo dell'assistito
      case profiloAssistito:
        return MaterialPageRoute<void>(
          builder: (_) => ProfiloAssistitoPage(
            assistito: routeSettings.arguments as Cliente,
          ),
        );

//* pagina che mostra la lista dei form da scegliere per la compilazione
      case sceltaFormPage:
        return MaterialPageRoute<void>(
          builder: (_) => SceltaFormPage(
            cliente: routeSettings.arguments as Cliente?,
          ),
        );

//* Pagina che mostra la lista dei Form compilati dall'utente (ci si accede quando utente vuole creare una nuova compilazione)
      case formListPage:
        return MaterialPageRoute<void>(
          builder: (_) => ListCompilazioniPage(
            cliente: routeSettings.arguments as Cliente?,
          ),
        );

//* pagina che mostra la lista dei form compilati per l'assistito (ci si accede dal profilo assistito)
      case formCompilato:
        return MaterialPageRoute<void>(
          builder: (_) => const AssistitoFormsPage(),
        );

//* pagina che mostra i grafici dell'assistito
      case grafici:
        {
          //posso accedere a sta pagina o da profilo assistito, o da profilo terapista
          //parametri passati => [true/false, cliente/listaClienti, compilazioni]
          final List<dynamic> parameters = routeSettings.arguments as List;
          //se accedo dalla pagina profilo assistito è true
          final bool isAssistitoProfilePage = parameters[0];
          return MaterialPageRoute<void>(builder: (_) {
            return ChangeNotifierProvider<GraficiClientProvider>(
              create: (context) => GraficiClientProvider(
                clients: isAssistitoProfilePage ? null : parameters[1],
                client: isAssistitoProfilePage ? parameters[1] : null,
                compilazioni: isAssistitoProfilePage ? parameters[2] : null,
              ),
              child: const GraficiPage(),
            );
          });
        }

      //* pagina delle credenziali
      case credenziali:
        return MaterialPageRoute<void>(
          builder: (_) => CredenzialiPage(
            currentClient: routeSettings.arguments != null
                ? routeSettings.arguments as Cliente
                : null,
          ),
        );

      //* Pagina che mostra nel dettaglio il singolo feedback che l'utente ha inviato
      case feedbackProfile:
        final arguments = routeSettings.arguments as List;
        return MaterialPageRoute<void>(
          builder: (context) => FeedbackProfile(
            currentFeed: arguments[0] as Feedbacks,
            feedIndex: arguments[1] as int,
          ),
        );

      //* pagina dei follower
      case followerPage:
        final showFollower = routeSettings.arguments as bool;
        return MaterialPageRoute<void>(
          builder: (_) => FollowerPage(showFollower: showFollower),
        );

      //* pagina che mostra il grafico nel dettaglio
      case dettaglioGrafico:
        final arguments = routeSettings.arguments as List;
        return MaterialPageRoute<void>(
          builder: (_) => DettaglioGrafico(
            currentGraphic: arguments[0],
            appBarTitle: arguments[1],
          ),
        );

      //* pagina che mostra la chat tra due utenti
      case socialChat:
        return MaterialPageRoute<void>(
          builder: (_) => ChatOpCloudPage(
            destinatarioChat: routeSettings.arguments as Follower,
          ),
        );

      //* pagina che mostra i commenti di un post
      case commentiPostSocial:
        final currentPost = routeSettings.arguments;
        return MaterialPageRoute<void>(
          builder: (_) => ChangeNotifierProvider<ListaCommentiProvider>(
            create: (context) => ListaCommentiProvider(),
            child: ListaCommentiPage(
              currentPost: currentPost as Post,
            ),
          ),
        );

      //* di default (magari ci sono stati errori) mando pagina di autenticazione
      default:
        return MaterialPageRoute<void>(
          builder: (_) => ChangeNotifierProvider<AuthValidator>(
            create: (context) => AuthValidator(),
            child: const AuthenticationPage(),
          ),
        );
    }
  }
}
