const { ApolloError } = require("apollo-server");

module.exports = async (_, { id, input }, { models }) => {

    try {
        const postToUpdate = await models.Post.findOne({ _id: id });

        if (!postToUpdate) throw new ApolloError(`Could not find Post with id: '${id}'.`, 400);

        //only if not in array
        if (!postToUpdate.likes.includes(input.userid)) {
            postToUpdate.likes.push(input.userid);
        }
        //else remove from array
        else {
            postToUpdate.likes.splice(postToUpdate.likes.indexOf(input.userid), 1);
        }

        const updatedPost = await postToUpdate.save();
        updatedPost['likeCount'] = postToUpdate.likes.length

        return updatedPost
    }
    catch (e) {
        throw new ApolloError(e)
    }
};
