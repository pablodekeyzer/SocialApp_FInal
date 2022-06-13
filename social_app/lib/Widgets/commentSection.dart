import 'package:flutter/material.dart';

import '../constants.dart';

class CommentSection extends StatefulWidget {
  List comments;

  CommentSection({Key? key, required this.comments}) : super(key: key);

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  @override
  Widget build(BuildContext context) {
    //list of comments
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.comments.length,
        itemBuilder: (context, index) {
          return Center(
            child: Container(
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(width: 1, color: lightGrey),
                  ),
                ),
                constraints: const BoxConstraints(maxWidth: 500),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(
                                  widget.comments[index]['user']?['img'])),
                          //widget.postdata['user']['img'] ?? ''
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.comments[index]['user']?['displayname'],
                              style: userText,
                            ),
                            Text(
                              widget.comments[index]['timeAgo'],
                              style: descText,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.comments[index]['text'],
                              style: mainText,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
