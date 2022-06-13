import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:social_app/Widgets/createpost.dart';
import 'package:social_app/Widgets/post.dart';

import '../constants.dart';

class Feed extends StatefulWidget {
  String? userId;
  Feed({Key? key, this.userId}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late bool firstload;
  late String readPosts;
  @override
  void initState() {
    print(widget.userId);

    firstload = true;
    readPosts = widget.userId == null
        ? r"""
  query posts {
    posts{
      _id
      text
      likeCount
      timeAgo
      img
      likes
      user {
        id
        displayname
        img
      }
      comments {
        timeAgo
        text
        user {
          displayname
          img
      }
      }
      commentCount
    }
  }
  """
        : r"""
  query posts($userPostsId: String!) {
userPosts(id: $userPostsId) {
      _id
      text
      likeCount
      timeAgo
      img
      likes
      user {
        displayname
        img
      }
      comments {
        timeAgo
        text
        user {
          id
          displayname
          img
      }
      }
      commentCount
    }
  }
  """;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
          document: gql(readPosts),
          variables:
              widget.userId == null ? {} : {"userPostsId": widget.userId}),
      // Just like in apollo refetch() could be used to manually trigger a refetch
      // while fetchMore() can be used for pagination purpose
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }
        if (result.isLoading && firstload) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List posts = [];
        if (widget.userId == null) {
          posts = result.data?['posts'];
        } else {
          posts = result.data?['userPosts'];
        }

        if (posts.isEmpty) {
          //return const Text('Loading');
        }

        if (firstload) {
          firstload = false;
          refetch!();
        }
        return ListView.builder(
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0 && widget.userId == null) {
                return CreatePost(
                  refetchCallBack: refetch,
                );
              } else if (index == 0 && widget.userId != null) {
                return Center(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: CircleAvatar(
                              radius: 35.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  posts[0]['user']['img']))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            posts[0]['user']['displayname'] ?? '',
                            style: bigUserText,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              final post = posts[index - 1];

              if (post == null) return const SizedBox();
              return Post(
                postdata: post,
                refetchCallBack: refetch,
              );
            });
      },
    );
  }
}
