import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_app/Widgets/postpage.dart';
import 'package:social_app/Widgets/profilePage.dart';
import 'package:social_app/constants.dart';

import '../Services/google_signin.dart';

// ignore: must_be_immutable
class Post extends StatefulWidget {
  Map<String, dynamic> postdata;
  VoidCallback? refetchCallBack;

  bool openComments = false;
  bool disableRoute = false;
  Post(
      {Key? key,
      required this.postdata,
      required this.refetchCallBack,
      this.openComments = false,
      this.disableRoute = false})
      : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  GoogleSignInAccount? user = GoogleSignApi().getUser;
  String addLike = r'''
  mutation AddLike($id: ID!, $input: AddLike!) {
    addLike(id: $id, input: $input) {
      likes
      likeCount
    }
  }
''';
  String addComment = r'''
  mutation AddComment($input: AddComment!) {
    addComment(input: $input) {
      id
    }
  }
''';

  late List likes;
  late int likeCount;
  late int commentCount;

  late bool showCommentInput;
  TextEditingController postTextController = TextEditingController();

  late Uint8List imagedata;
  late String id;
  @override
  void initState() {
    id = widget.postdata['_id'];
    imagedata = Uint8List.fromList(widget.postdata['img'].codeUnits);
    showCommentInput = widget.openComments;
    likeCount = widget.postdata['likeCount'];
    likes = widget.postdata['likes'];
    commentCount = widget.postdata['commentCount'];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Post oldWidget) {
    if (id != widget.postdata['_id']) {
      id = widget.postdata['_id'];
      imagedata = Uint8List.fromList(widget.postdata['img'].codeUnits);
      showCommentInput = widget.openComments;
      likeCount = widget.postdata['likeCount'];
      likes = widget.postdata['likes'];
      commentCount = widget.postdata['commentCount'];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          if (!widget.disableRoute) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostPage(
                          postdata: widget.postdata,
                          refetchCallBack: widget.refetchCallBack,
                        )));
          }
        },
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                  userid: widget.postdata['user']['id'],
                                )));
                  },
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.postdata['user']['img']))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.postdata['user']['displayname'] ?? '',
                            style: userText,
                          ),
                          Text(
                            widget.postdata['timeAgo'],
                            style: descText,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.postdata['text'],
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
                widget.postdata['img'].isEmpty
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          //show larger image in a modal
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    insetPadding: const EdgeInsets.all(5),
                                    contentPadding: const EdgeInsets.all(5),
                                    content: FittedBox(
                                        child: Image.memory(imagedata),
                                        fit: BoxFit.fill),
                                    actions: const [],
                                  ));
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                              maxHeight: 450, minHeight: 100),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Image.memory(imagedata)),
                        ),
                      ),
                Row(children: [
                  Mutation(
                      options: MutationOptions(
                        document: gql(addLike),
                        onCompleted: (dynamic resultData) {
                          widget.refetchCallBack!();
                        },
                      ),
                      builder: (
                        RunMutation runMutation,
                        QueryResult? result,
                      ) {
                        return TextButton.icon(
                            label: Text(likeCount.toString()),
                            icon: likes.contains(user?.email)
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border),
                            onPressed: () {
                              //already change data so we dont need to wait for the result

                              setState(() {
                                if (likes.contains(user?.email)) {
                                  likes.remove(user?.email);
                                  likeCount--;
                                } else {
                                  likes.add(user?.email);
                                  likeCount++;
                                }
                              });

                              runMutation({
                                "id": widget.postdata['_id'],
                                "input": {
                                  'userid': user?.email,
                                }
                              });
                            });
                      }),
                  TextButton.icon(
                    label: Text(commentCount.toString()),
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                    ),
                    onPressed: () {
                      setState(() {
                        if (!widget.openComments) {
                          showCommentInput = !showCommentInput;
                        }
                      });
                    },
                  ),
                ]),
                //add comment
                if (showCommentInput)
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: postTextController,
                          decoration: const InputDecoration(
                            hintText: 'Add a comment',
                          ),
                        ),
                      ),
                      Mutation(
                          options: MutationOptions(
                            document: gql(addComment),
                            onCompleted: (dynamic resultData) {
                              widget.refetchCallBack!();
                              setState(() {
                                if (!widget.openComments) {
                                  showCommentInput = !showCommentInput;
                                }
                              });
                            },
                          ),
                          builder: (
                            RunMutation runMutation,
                            QueryResult? result,
                          ) {
                            return IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                commentCount++;

                                runMutation({
                                  "input": {
                                    "userid": user?.email,
                                    "text": postTextController.text,
                                    "postid": widget.postdata['_id']
                                  }
                                });
                              },
                            );
                          }),
                    ],
                  ),
              ],
            )),
      ),
    );
  }
}
