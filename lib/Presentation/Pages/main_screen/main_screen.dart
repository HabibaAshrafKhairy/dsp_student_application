import 'package:dsp_student_application/Logic/search/search_cubit.dart';
import 'package:dsp_student_application/Logic/urgent_bar_cubit/urgentbarcubit_cubit.dart';
import 'package:dsp_student_application/Presentation/Pages/main_screen/components/urgent_bar.dart';
import 'package:dsp_student_application/Presentation/translations/locale_keys.g.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dsp_student_application/Presentation/Theme/theme.dart';
import 'package:dsp_student_application/Logic/load_file/loadfile_cubit.dart';
import 'package:dsp_student_application/Presentation/Global_components/ArabicImage.dart';
import 'package:dsp_student_application/Logic/internet_connection/internetconnection_cubit.dart';
import 'package:dsp_student_application/Presentation/Pages/main_screen/components/gradientOutline.dart';
import 'package:dsp_student_application/Presentation/Pages/main_screen/components/create_text_field.dart';
import 'package:dsp_student_application/Presentation/Global_components/LightPageSnackBar.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBody();
  }
}

class ScreenBody extends StatefulWidget {
  @override
  _ScreenBodyState createState() => _ScreenBodyState();
}

class _ScreenBodyState extends State<ScreenBody> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(alignment: Alignment.bottomCenter, children: [
        //Screen Backgroud
        ArabicImage(
          size: size.height / 1.5,
          top: -size.height / 3,
          right: -size.height / 3,
          blendMode: BlendMode.srcATop,
          opacity: 0.05,
        ),

        //Screen content
        SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(bottom: 72),
              height: size.height - 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu bar
                  Padding(
                    padding: const EdgeInsets.only(top: 72),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 32,
                            color: AppColors.cDarkGrey,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(LocaleKeys.MainScreen.tr(),
                            style: AppFonts.heading5.copyWith(
                              color: AppColors.cDarkGrey,
                            )),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SearchBar(size: size),
                        QueryField(size: size),
                        UploadButton(size: size),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadfileCubit, LoadfileState>(builder: (context, state) {
      return Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.cDarkGrey, width: 2)),
            width: 0.8 * size.width,
            child: OutlinedButton(
              onPressed: () {
                context.read<LoadfileCubit>().onButtonClick();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.upload.tr(),
                      style: AppFonts.bodyText1,
                    ),
                    Icon(
                      Icons.add_circle_outline,
                      size: 32,
                      color: AppColors.cGreen,
                    ),
                  ],
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(AppColors.cDarkGrey),
                shadowColor: MaterialStateProperty.all(AppColors.cDarkGrey),
                overlayColor: MaterialStateProperty.all(AppColors.cLightGrey),
                backgroundColor: MaterialStateProperty.all(AppColors.cWhite),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 8),

          /// The Disclaimer
          Center(
            child: AutoSizeText(
              LocaleKeys.disclaimer.tr(),
              style: AppFonts.captionText,
              maxLines: 1,
            ),
          ),
        ],
      );
    });
  }
}

class QueryField extends StatelessWidget {
  QueryField({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;
  final TextEditingController sentenceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GradientOutline(
      size: size,
      radius: 32,
      child: Column(
        children: [
          BlocBuilder<InternetconnectionCubit, InternetconnectionState>(
            builder: (context, state) {
              return TextFieldCreation(
                  controller: sentenceController,
                  size: size,
                  hintText: state.isConnected
                      ? LocaleKeys.write_new_query.tr()
                      : "No internet connection",
                  maximumLines: (size.height * 0.3 / 22).floor(),
                  border: false);
            },
          ),
          UrgentBar(controller: sentenceController),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(),
      child: BlocBuilder<InternetconnectionCubit, InternetconnectionState>(
        builder: (context, state) {
          return Container(
            width: size.width * 0.8,
            height: 52,
            child: TextField(
              onChanged: (value) {
                context.read<SearchCubit>().getSearchResults(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: AppColors.cDarkGrey)),
                hintStyle: AppFonts.bodyText1,
                hintText: LocaleKeys.search.tr(),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 24,
                    color: AppColors.cDarkGrey,
                  ),
                  onPressed: () {
                    if (state.isConnected)
                      print(LocaleKeys.search.tr());
                    else
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
