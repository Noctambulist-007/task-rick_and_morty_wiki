import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty/presentation/blocs/navigation/navigation_bloc.dart';
import 'package:rick_and_morty/presentation/screens/all_cast_screen.dart';
import 'package:rick_and_morty/presentation/screens/cast_details_screen.dart';
import 'package:rick_and_morty/utils/colors.dart';

class NavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navigationBloc = NavigationBloc();

    return BlocProvider(
      create: (context) => navigationBloc,
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (state is TabChanged) {
          return _widgetOptions[state.index];
        } else if (state is CastDetailsView) {
          return CastDetailsScreen(characterId: state.characterId);
        }
        return _widgetOptions[0];
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is TabChanged) {
          currentIndex = state.index;
        } else if (state is CastDetailsView) {
          currentIndex = 1;
        }

        return BottomNavigationBar(
          backgroundColor: Color(0xFF193840),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: 'Cast',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: AppColors.RNMGreen,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            if (index == 1) {
              context.read<NavigationBloc>().add(const GoToCastTab());
            } else {
              context.read<NavigationBloc>().add(TabSelected(index));
            }
          },
        );
      },
    );
  }

  static final List<Widget> _widgetOptions = <Widget>[
    AllCastScreen(),
    CastDetailsScreen(characterId: ''),
  ];
}
