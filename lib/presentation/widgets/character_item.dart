import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_and_morty/data/models/character_model.dart';
import 'package:rick_and_morty/domain/entities/character.dart';
import 'package:rick_and_morty/utils/colors.dart';

class CharacterItem extends StatelessWidget {
  final CharacterModel characterModel;

  const CharacterItem({Key? key, required this.characterModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final character = _convertToCharacter();
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.RNMGreen,
                  AppColors.RNMBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Container(
            width: 198,
            height: 240,
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: AppColors.RNMBlack,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    character.image,
                    width: 157.63,
                    height: 131.97,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  character.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Character _convertToCharacter() {
    return Character(
      id: characterModel.id,
      name: characterModel.name,
      image: characterModel.image,
    );
  }
}
