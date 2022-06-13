const { ApolloError } = require("apollo-server");
const { timeStringHelper } = require("./timeStringHelper");

module.exports = async (_, { id }, { models }) => {

    try {
        //find and set relational/computed fields for post
        const post = await models.Post.findOne({ _id: id });
        const comments = await models.Comment.find({ postid: post.id });
        for (let j = 0; j < comments.length; j++) {
            let userC = await models.User.findOne({ id: comments[j].userid });
            let timedataC = timeStringHelper(comments[j].timestamp);
            comments[j]['timeAgo'] = timedataC[0];
            comments[j]['timeAbs'] = timedataC[1];
            comments[j]['user'] = userC;
        }
        comments.sort((a, b) => {
            return a.timeAbs - b.timeAbs
        })
        console.log(comments)
        if (!post) throw new ApolloError(`Could not find Post with id: '${id}'.`, 400);
        let user = await models.User.findOne({ id: post.userid });

        let timedata = timeStringHelper(post.timestamp);
        post['timeAgo'] = timedata[0];
        post['timeAbs'] = timedata[1];
        post['comments'] = comments
        post['commentCount'] = post.comments.length
        post['user'] = user;
        post['likeCount'] = post.likes.length
        return post;
    }
    catch (e) {
        throw new ApolloError(e)
    }
};
