import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarChat extends StatelessWidget {
  final String avatarUrl;
  const AvatarChat(
    this.avatarUrl, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: avatarUrl,
        cacheKey: avatarUrl,
        width: 50,
        height: 50,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
        placeholder: (context, url) => const ErrAvtProfile(),
        errorWidget: (context, url, error) => const ErrAvtProfile());
  }
}

class ErrAvtProfile extends StatelessWidget {
  const ErrAvtProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Icon(
        Icons.person,
        size: 30,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
