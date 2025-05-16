import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutterotica/env/colors.dart';
import 'package:flutterotica/env/global.dart';
import 'package:flutterotica/models/author.dart';
import 'package:flutterotica/screens/authors_stories.dart';
import 'package:flutterotica/screens/widgets/lit_chip.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthorScreen extends StatefulWidget {
  const AuthorScreen({super.key, required this.author});

  final Author author;

  @override
  State<AuthorScreen> createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  bool _isExpanded = false;

  late Author author;

  @override
  void initState() {
    author = widget.author;
    super.initState();
    if (author.homepage == null) {
      api.getAuthor(author.userid).then((value) {
        setState(() {
          author = value;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(author.username),
      ),
      body: SafeArea(
        child: body(),
      ),
    );
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  String formatNumber(int num) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    } else {
      return num.toString();
    }
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          authorInfo(),
          const SizedBox(height: 10),
          SizedBox(
            height: 600,
            child: AuthorsStoriesScreen(
              author: widget.author,
              listOnly: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget authorInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(author.username, style: const TextStyle(fontSize: 25)),
          if (author.location != null && author.location!.isNotEmpty)
            Text('Location: ${author.location}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                )),
          if (author.lastUpdateApprox.isNotEmpty)
            Text('Updated: ${author.lastUpdateApprox}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                )),
          if (author.joindateApprox.isNotEmpty)
            Text('Joined: ${author.joindateApprox}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                )),
          const SizedBox(height: 10),
          Wrap(
            runSpacing: 5,
            spacing: 5,
            children: [
              LitChip(label: "Followers", text: formatNumber(author.followersCount)),
              LitChip(label: "Comments", text: formatNumber(author.commentsCount)),
              LitChip(label: "Series", text: formatNumber(author.seriesCount)),
              LitChip(label: "Stories", text: formatNumber(author.storiesCount)),
              LitChip(label: "Poems", text: formatNumber(author.poemsCount)),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Bio',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Column(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                constraints: BoxConstraints(
                  maxHeight: _isExpanded ? double.maxFinite : 100,
                ),
                child: Linkify(
                  onOpen: (link) async {
                    await _launchInBrowser(Uri.parse(link.url));
                  },
                  text: author.biography ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                  linkStyle: const TextStyle(color: kRed, decoration: TextDecoration.none),
                ),
              ),
              if (author.biography != null && author.biography!.isNotEmpty)
                TextButton(
                  child: Text(_isExpanded ? "Show Less" : "Show More"),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget litLabelTextRow(String title, {double fontSize = 18, String? value, Widget? trailing, double height = 1.6}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          "$title: ",
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        if (trailing != null) Flexible(child: trailing),
        if (trailing == null && value != null)
          Text(
            value,
            style: TextStyle(
              height: height,
              fontSize: fontSize,
              color: kRed,
            ),
          ),
      ],
    );
  }

  OutlinedButton litButton(String text, Function() onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: kRed,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.black),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
