const { ApolloError } = require("apollo-server");

module.exports = async (_, { input }, { models }) => {

    try {
        input.timestamp = new Date().toISOString();
        newComment = await models.Comment.create(input);
        return newComment
    }
    catch (e) {
        throw new ApolloError(e)
    }
};
