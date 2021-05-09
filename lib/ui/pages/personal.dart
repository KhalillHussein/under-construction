import 'package:auto_size_text/auto_size_text.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mtusiapp/repositories/index.dart';
import 'package:row_collection/row_collection.dart';
import 'package:provider/provider.dart';

import '../widgets/index.dart';
import '../../util/index.dart';

class PersonalPage extends StatelessWidget {
  final String name;

  const PersonalPage(this.name);

  static const route = '/personal_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('О преподавателе'),
            pinned: true,
          ),
          SliverBar(
            height: 0.3,
            header: _buildLecturerHeader(context),
          ),
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildMainInfoCard(context),
                    Separator.spacer(),
                    _buildSpecialityCard(context),
                    Separator.spacer(),
                    _buildDisciplinesTaughtCard(context),
                    Separator.spacer(),
                    _buildTrainingsCard(context),
                    Separator.spacer(),
                    _buildScientificInterestsCard(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLecturerHeader(BuildContext context) {
    final info = context.read<LecturersRepository>().getByLecturer(name);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildLecturerAvatar(info.photo)),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKafedraBadge(context, kafedra: info.kafedra),
                Expanded(
                  flex: 2,
                  child: AutoSizeText(
                    info.fullName,
                    style: GoogleFonts.rubikTextTheme(
                      Theme.of(context).textTheme,
                    ).headline6,
                    textScaleFactor: 0.9,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                    child:
                        _buildLecturerInfo(context, 'Должность:', info.rank)),
                Expanded(
                  child: _buildLecturerInfo(
                      context, 'Ученая степень:', info.academicDegree),
                ),
                Expanded(
                    child: _buildLecturerInfo(
                        context, 'Ученое звание:', info.academicRank)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKafedraBadge(BuildContext context, {String kafedra}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor.withOpacity(0.1),
        border: Border.all(
          color: Theme.of(context).accentColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        kafedra,
        style: Theme.of(context).textTheme.caption.copyWith(
            color: Theme.of(context).accentColor, fontWeight: FontWeight.w500),
        textScaleFactor: 0.8,
      ).scalable(),
    );
  }

  Widget _buildLecturerAvatar(String photo) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: CacheImage.lecturer(
          photo,
        ),
      ),
    );
  }

  Widget _buildLecturerInfo(BuildContext context, section, String label) {
    return AutoSizeText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$section ',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          TextSpan(
              text: label,
              style: Theme.of(context).textTheme.caption.copyWith(height: 1.2)),
        ],
      ),
      // textScaleFactor: 0.92,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    final info = context.read<LecturersRepository>().getByLecturer(name);
    return CardCell.body(
      context,
      title: 'Основные сведения',
      child: RowLayout(children: <Widget>[
        RowText(
          'Образование',
          info.qualification.reduce((value, element) => '$value, $element'),
        ),
        Separator.divider(),
        RowText(
          'Общий стаж',
          'с ${info.totalLengthOfService.year} года',
        ),
        RowText(
          'Стаж работы по специальности',
          'с ${info.lengthWorkOfSpeciality.year} года',
        ),
      ]),
    );
  }

  Widget _buildSpecialityCard(BuildContext context) {
    final info = context.read<LecturersRepository>().getByLecturer(name);
    return CardCell.body(
      context,
      title: 'Специальность',
      child: RowLayout(children: <Widget>[
        for (int i = 0; i < info.specialty.length; i++)
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Text(
                    i > info.specialty.length - 1
                        ? info.specialty[info.specialty.length - 1]
                        : info.specialty[i],
                  ),
                ),
                TextSpan(
                    text: i > info.education.length - 1
                        ? ' (${info.education[info.education.length - 1]})'
                        : ' (${info.education[i]})',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 13, height: 1.4)),
              ],
            ),
          ).scalable(),
      ]),
    );
  }

  Widget _buildDisciplinesTaughtCard(BuildContext context) {
    final info = context.read<LecturersRepository>().getByLecturer(name);
    return CardCell.body(
      context,
      title: 'Преподаваемые дисциплины',
      child: ExpandText(
        info.disciplinesTaught.reduce((value, element) => '$value, $element'),
        collapsedHint: 'Развернуть',
        expandedHint: 'Свернуть',
        // style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
        maxLines: 4,
      ),
    );
  }

  Widget _buildTrainingsCard(BuildContext context) {
    final info = context.read<LecturersRepository>().getByLecturer(name);
    return CardCell.body(
      context,
      title: 'Повышение квалификации',
      child: ExpandText(
        info.trainings.reduce((value, element) => '$value\n$element'),
        maxLines: 4,
        // style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
        collapsedHint: 'Развернуть',
        expandedHint: 'Свернуть',
      ),
    );
  }

  Widget _buildScientificInterestsCard(BuildContext context) {
    final info = context.read<LecturersRepository>().getByLecturer(name);
    return CardCell.body(
      context,
      title: 'Научные интересы',
      child: ExpandText(
        info.scientificInterests.reduce((value, element) => '$value, $element'),
        // style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.4),
        maxLines: 4,
      ),
    );
  }
}