import 'package:flutter/material.dart';
import 'package:lettutor/l10n/app_localizations.dart';

class InfoPageScheduleComponent extends StatelessWidget {
  const InfoPageScheduleComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildImage(),
          SizedBox(height: 16),
          _buildTitleText(context),
          SizedBox(height: 16),
          _buildSubTitle(context),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Image.asset('lib/assets/images/calendar.png', height: 120),
    );
  }

  Widget _buildTitleText(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        AppLocalizations.of(context)!.schedule,
        style: TextStyle(
          color: Colors.black,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubTitle(BuildContext context) {
    return Container(
      child: Text(
        AppLocalizations.of(context)!.hereIsAList,
        style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
      ),
    );
  }
}
