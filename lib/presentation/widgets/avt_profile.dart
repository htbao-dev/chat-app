import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarProfile extends StatelessWidget {
  final String avatarUrl;
  const AvatarProfile(
    this.avatarUrl, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        imageUrl: avatarUrl,
        width: 150,
        height: 150,
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
        size: 100,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
