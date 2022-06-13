const { ApolloError } = require("apollo-server");

module.exports = async (_, { id, input }, { models }) => {

  try {
    const postToUpdate = await models.Post.findOne({ _id: id });

    if (!postToUpdate) throw new ApolloError(`Could not find Post with id: '${id}'.`, 400);

    Object.keys(input).forEach(value => {
      postToUpdate[value] = input[value];
    });

    const updatedPost = await postToUpdate.save();

    return updatedPost
  }
  catch (e) {
    throw new ApolloError(e)
  }
};
