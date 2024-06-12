import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/data/graphql/graphql_service.dart';
import 'package:rick_and_morty/data/repositories/character_repository.dart';
import 'package:rick_and_morty/domain/repositories/character_repository.dart';
import 'package:rick_and_morty/presentation/blocs/character/character_bloc.dart';
import 'package:rick_and_morty/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:rick_and_morty/presentation/screens/all_cast_screen.dart';
import 'package:rick_and_morty/presentation/screens/cast_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/screens/navigation_screen.dart';
import 'package:rick_and_morty/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink('https://rickandmortyapi.com/graphql');

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  );

  final GraphQLService graphqlService = GraphQLService(client);
  final CharacterRepository characterRepository =
      CharacterRepositoryImpl(graphqlService);

  runApp(MyApp(client: client, characterRepository: characterRepository));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;
  final CharacterRepository characterRepository;

  const MyApp(
      {Key? key, required this.client, required this.characterRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: ValueNotifier(client),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CharacterBloc(characterRepository),
          ),
          BlocProvider(
            create: (context) => NavigationBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rick and Morty App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(),
          routes: {
            '/home': (context) => NavigationScreen(),
            '/castDetails': (context) {
              final args = ModalRoute.of(context)!.settings.arguments;
              if (args != null) {
                return CastDetailsScreen(characterId: args as String);
              } else {
                return const CastDetailsScreen(characterId: null);
              }
            },
          },
        ),
      ),
    );
  }
}
