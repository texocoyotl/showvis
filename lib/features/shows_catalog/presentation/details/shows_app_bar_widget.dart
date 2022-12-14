import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowsAppBarWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final bool centerTitle;
  final Widget ratingsIcon;
  final Function(int) onTabChange;
  final bool isFavorite;
  final Function() toggleFavorite;

  const ShowsAppBarWidget({
    super.key,
    required this.text,
    required this.imagePath,
    required this.ratingsIcon,
    this.centerTitle = false,
    required this.onTabChange,
    required this.isFavorite,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        text,
        style: const TextStyle(
          //fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      expandedHeight: 600, //TODO Make it relative to screen size
      pinned: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: isFavorite
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_outline),
          tooltip: isFavorite ? 'Unmark as Favorite' : 'Mark as Favorite',
          onPressed: toggleFavorite,
        ),
        ratingsIcon,
      ],
      bottom: TabBar(
        //isScrollable: true,
        labelPadding: const EdgeInsets.all(8),
        onTap: onTabChange,
        tabs: const [
          Tab(
            height: 36,
            child: Text('About'),
          ),
          Tab(
            child: Text('Episodes'),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Padding(
            padding: const EdgeInsets.only(top: 76.0, bottom: 48),
            child: Hero(
              tag: text,
              child: imagePath.isEmpty
                  ? const Image(image: AssetImage('assets/no_image.png'))
                  : CachedNetworkImage(
                      imageUrl: imagePath,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              const CupertinoActivityIndicator(
                        radius: 50,
                        //value: downloadProgress.progress,
                        color: Colors.black87,
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
