import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mtusiapp/ui/screens/news_edit.dart';
import 'package:mtusiapp/ui/screens/settings.dart';

import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:row_collection/row_collection.dart';

import '../../repositories/index.dart';
import '../../util/index.dart';
import '../pages/index.dart';
import '../widgets/index.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (ctx, userData, _) => SimpleTab<AuthRepository>(
        title: userData.user.userName,
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              MdiIcons.bell,
              size: 25,
            ),
            color: Theme.of(context).primaryIconTheme.color,
            onPressed: null,
          ),
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              MdiIcons.email,
              size: 25,
            ),
            onPressed: null,
          ),
          PopupMenuButton<String>(
              tooltip: 'Еще',
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'Выход',
                        child: Row(
                          children: [
                            const Icon(Icons.exit_to_app),
                            Separator.spacer(),
                            const Text('Выход').scalable(),
                          ],
                        )),
                    PopupMenuItem(
                        value: 'Настройки',
                        child: Row(
                          children: [
                            const Icon(Icons.settings_outlined),
                            Separator.spacer(),
                            const Text('Настройки').scalable(),
                          ],
                        )),
                  ],
              onSelected: (text) {
                switch (text) {
                  case 'Выход':
                    _showDialog(context, userData);
                    break;
                  case 'Настройки':
                    Navigator.pushNamed(context, SettingsScreen.route);
                    break;
                }
              }),
        ],
        body: userData.getUserPosition() == Positions.student
            ? _Student()
            : userData.getUserPosition() == Positions.lecturer
                ? _Lecturer()
                : userData.getUserPosition() == Positions.admin
                    ? _Master()
                    : SizedBox(),
      ),
    );
  }

  void _showDialog(BuildContext context, AuthRepository userData) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appBarTheme.color,
        content: const Text(
          'Вы действительно хотите выйти?',
        ).scalable(),
        actions: <Widget>[
          TextButton(
            style:
                TextButton.styleFrom(primary: Theme.of(context).disabledColor),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'ОТМЕНА',
            ).scalable(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(userData.logout());
            },
            child: const Text(
              'ОК',
            ).scalable(),
          ),
        ],
      ),
    );
  }
}

class _Student extends StatelessWidget {
  List<Map<String, dynamic>> _tabs(BuildContext context) {
    return [
      // {
      //   'tab': 'РАСПИСАНИЕ',
      //   'page': Schedule('ДИ-11'),
      // },
      {
        'tab': 'УСПЕВАЕМОСТЬ',
        'page': Progress(),
      },
      {
        'tab': 'ЗАЧЕТКА',
        'page': RecordBookPage(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              labelColor: Theme.of(context).accentColor,
              unselectedLabelColor: Theme.of(context).textTheme.caption.color,
              tabs: <Widget>[
                for (final item in _tabs(context))
                  Tab(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item['tab'],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                for (final item in _tabs(context))
                  Tab(
                    child: item['page'],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Master extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15),
      children: [
        _buildCardSection(
          context,
          title: 'Новости',
          subtitle: 'Добавление новости',
          icon: MdiIcons.newspaperVariantMultipleOutline,
          onTap: () => Navigator.pushNamed(context, CreateNewsScreen.route),
        ),
        _buildCardSection(
          context,
          title: 'Расписание',
          subtitle: 'Управление расписанием',
          icon: MdiIcons.archiveAlertOutline,
        ),
        _buildCardSection(
          context,
          title: 'Преподаватели',
          subtitle: 'Просмотр преподавателей',
          icon: MdiIcons.accountTie,
        ),
        _buildCardSection(
          context,
          title: 'Аккаунты',
          subtitle: 'Управление аккаунтами',
          icon: MdiIcons.accountGroupOutline,
        ),
      ],
    );
  }

  Widget _buildCardSection(
    BuildContext context, {
    @required String title,
    @required String subtitle,
    @required IconData icon,
    VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(3.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.rubikTextTheme(
                        Theme.of(context).textTheme,
                      ).headline5.copyWith(
                            color: onTap != null
                                ? Theme.of(context).textTheme.headline5.color
                                : Theme.of(context).disabledColor,
                          ),
                    ).scalable(),
                    Separator.spacer(space: 3),
                    Text(
                      subtitle,
                      style: GoogleFonts.rubikTextTheme(
                        Theme.of(context).textTheme,
                      ).caption.copyWith(
                            height: 1.2,
                            letterSpacing: 0.3,
                            color: onTap != null
                                ? Theme.of(context).textTheme.caption.color
                                : Theme.of(context).disabledColor,
                          ),
                      textScaleFactor: 1.1,
                    ).scalable(),
                  ],
                ),
              ),
              Icon(
                icon,
                size: 45,
                color: onTap != null
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).disabledColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lecturer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Container(
        color: Theme.of(context).cardTheme.color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TabBar(
                tabs: <Widget>[
                  Tab(
                    child: const Text(
                      'РАСПИСАНИЕ ЗАНЯТИЙ',
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ).scalable(),
                  ),
                  Tab(
                    child: Text('МРС').scalable(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Schedule('Ткачук Е.О.'),
                  Center(child: Text('МРС').scalable()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class Schedule extends StatelessWidget {
//   final String keyword;
//
//   const Schedule(this.keyword);
//
//   static const route = '/timetable';
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TimetableRepository>(
//       builder: (ctx, model, _) => _buildListView(
//         context,
//         model.getBy(keyword),
//       ),
//     );
//   }
//
//   Widget _buildListView(BuildContext context, List<Timetable> timetable) {
//     return GroupedListView<Timetable, DateTime>(
//       floatingHeader: true,
//       addAutomaticKeepAlives: false,
//       elements: timetable,
//       separator: Separator.spacer(space: 6),
//       groupBy: (element) =>
//           DateTime(element.date.year, element.date.month, element.date.day),
//       groupSeparatorBuilder: (groupByValue) =>
//           _buildSeparator(context, groupByValue),
//       shrinkWrap: true,
//       indexedItemBuilder: (context, schedule, index) => TimetableCard(
//         lessonNumber: schedule.lesson,
//         title: schedule.subject,
//         subjectType: schedule.subjectType,
//         trailing: schedule.name,
//         subtitle: schedule.aud,
//         header: schedule.cafedra,
//       ),
//     );
//   }
//
//   Widget _buildSeparator(BuildContext context, DateTime date) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//       child: Row(children: <Widget>[
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(left: 10.0, right: 20.0),
//             child: Separator.divider(),
//           ),
//         ),
//         Text(
//           '${toBeginningOfSentenceCase(DateFormat.EEEE('Ru').format(date))}, ${DateFormat.MMMMd('Ru').format(date)}',
//           textAlign: TextAlign.center,
//           style: GoogleFonts.rubikTextTheme(
//             Theme.of(context).textTheme,
//           ).caption,
//           textScaleFactor: 1.2,
//         ).scalable(),
//         Expanded(
//           child: Container(
//             margin: const EdgeInsets.only(left: 20.0, right: 10.0),
//             child: Separator.divider(),
//           ),
//         ),
//       ]),
//     );
//   }
// }