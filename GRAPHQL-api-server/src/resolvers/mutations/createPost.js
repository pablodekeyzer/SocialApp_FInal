const { ApolloError } = require("apollo-server");

module.exports = async (_, { input }, { models }) => {

  try {
    input.timestamp = new Date().toISOString();
    newPost = await models.Post.create(input);
    return newPost
  }
  catch (e) {
    throw new ApolloError(e)
  }

};
