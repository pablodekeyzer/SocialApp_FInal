const { ApolloError } = require("apollo-server");

module.exports = async (_, { id }, { models }) => {

    try {
        const comments = await models.Comment.find({ postid: id });

        return comments
    }
    catch (e) {
        throw new ApolloError(e)
    }
};
