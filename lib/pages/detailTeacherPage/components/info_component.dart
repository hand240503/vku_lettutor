import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:lettutor/data/model/tutor/tutor.dart';
import 'package:lettutor/l10n/app_localizations.dart';
import 'package:lettutor/providers/tutor_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class InfoComponent extends StatefulWidget {
  const InfoComponent({super.key, required this.tutor, required this.index});
  final Tutor tutor;
  final int index;

  @override
  State<InfoComponent> createState() => _InfoComponentState();
}

class _InfoComponentState extends State<InfoComponent> {
  late bool isFavorite = false;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    final tutorProvider = context.read<TutorProvider>();
    print(widget.tutor.toString());

    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.tutor.bioUrl!),
      )
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildMainInfo(),
          const SizedBox(height: 10),
          _buildTextDescription(),
          const SizedBox(height: 10),
          _buildVideoPlayer(),
          const SizedBox(height: 20),
          _buildOtherInfo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMainInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: ClipOval(
            child: CachedNetworkImage(
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: widget.tutor.avatar!,
              progressIndicatorBuilder:
                  (context, url, downloadProgress) => Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
              errorWidget:
                  (context, url, error) => Image.network(
                    "https://scontent.fdad1-4.fna.fbcdn.net/v/t39.30808-6/487782711_2181510392265807_3269429498123799716_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeEcXovXA4AcNKYFLMO8NpmiMIJ1fLUmWzIwgnV8tSZbMuzhl_cmwFNml3bUiEC9LAOadvuxXRw3UrkndS-CZkYG&_nc_ohc=MebKWznknrMQ7kNvwHcloWs&_nc_oc=Adne-lWUNE3rnwjc0SeE6IKT1Ceqirt3DOoW6dJ7mmcq8m6syDZcfDnVRK9hCYXfcJppz6GxsEm88DKvO7-WBpnK&_nc_zt=23&_nc_ht=scontent.fdad1-4.fna&_nc_gid=gA113-up5MfSwwikxRtezA&oh=00_AfFdgh-fZvJugOeisPpGgsY9a89_RW7AdCG1q_zV2sda6w&oe=681681FD",
                  ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Thông tin chính
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.tutor.name ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  for (int i = 0; i < (widget.tutor.rating ?? 0).floor(); i++)
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                  if (((widget.tutor.rating ?? 0) -
                          (widget.tutor.rating ?? 0).floor()) >=
                      0.5)
                    const Icon(Icons.star_half, color: Colors.yellow, size: 16),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.tutor.country ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      child: ExpandableText(
        widget.tutor.bio!,
        expandText: "More",
        collapseText: "Less",
        textAlign: TextAlign.justify,
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          height: 1.3,
        ),
        linkColor: Colors.blue,
      ),
    );
  }

  List<String>? convertStringToSpecialties(String? inputString) {
    List<String>? labels = inputString?.split(',');

    // Một mapping giữa các từ khóa trong chuỗi và nhãn tương ứng
    Map<String, String> keywordToLabel = {
      'business-english': 'English for Business',
      'conversational-english': 'Conversational',
      'english-for-kids': 'English for Kids',
      'ielts': 'IELTS',
      'starters': 'STARTERS',
      'movers': 'MOVERS',
      'flyers': 'FLYERS',
      'ket': 'KET',
      'pet': 'PET',
      'toefl': 'TOEFL',
      'toeic': 'TOEIC',
    };

    List<String>? filterLabels =
        labels?.map((label) {
          return keywordToLabel[label] ?? label;
        }).toList();

    return filterLabels;
  }

  List<String>? convertStringToLanguages(String? inputString) {
    List<String>? labels = inputString?.split(' ');

    return labels;
  }

  // Video Player Widget using Chewie
  Widget _buildVideoPlayer() {
    return _controller.value.isInitialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Chewie(controller: _chewieController),
        )
        : Container(
          height: 200,
          color: Colors.grey[200],
          child: Center(child: CircularProgressIndicator()),
        );
  }

  Widget _buildOtherInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.education,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.tutor.education ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.languages,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8.0,
                    children:
                        convertStringToLanguages(
                          widget.tutor.language ?? "",
                        )!.map((label) {
                          return FilterChip(
                            backgroundColor: Colors.lightBlue.shade100,
                            label: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onSelected: (bool selected) {
                              // Handle filter selection (if needed)
                            },
                            selected: false,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.specialities,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8.0,
                    children:
                        convertStringToSpecialties(
                          widget.tutor.speciality,
                        )!.map((label) {
                          return FilterChip(
                            backgroundColor: Colors.lightBlue.shade100,
                            label: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            onSelected: (bool selected) {
                              // Handle filter selection (if needed)
                            },
                            selected: false,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.interests,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.tutor.interests ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.teachingExperience,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.tutor.experience ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
