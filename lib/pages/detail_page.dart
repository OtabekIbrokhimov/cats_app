import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  String? imageId;
  String? url;
  DetailPage({Key? key, this.url, this.imageId}) : super(key: key);
static const String id = "DetailPage";
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag:  widget.imageId!,
      child: InteractiveViewer(
        child: CachedNetworkImage(
          imageUrl: widget.url!,
          placeholder: (context, text) => Container(color: Colors.grey,),
        ),
      ),

    );
  }
}
