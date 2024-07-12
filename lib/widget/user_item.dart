import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserItem extends StatelessWidget {
  const UserItem({
    super.key,
    required this.name,
    required this.country,
    required this.city,
    required this.url,
    required this.onTap,
  });

  final String url;
  final String name;
  final String country;
  final String city;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  _renderProfileImage(context, url),
                  const SizedBox(width: 16.0),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      if (country.isNotEmpty || city.isNotEmpty)
                        Text(
                          '${country.isNotEmpty ? country : ''}${city.isNotEmpty ? ' - $city' : ''}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context).colorScheme.tertiary,
              indent: 85,
              endIndent: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderProfileImage(BuildContext context, String imageUrl) {
    if(url.isNotEmpty) {
      return   CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 40,
          backgroundColor: Colors.transparent,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[200],
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.error),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey[300],
        child: Icon(
          Icons.person,
          size: 40,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      );
    }
  }

}
