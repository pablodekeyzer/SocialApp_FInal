const { ApolloError } = require("apollo-server");

module.exports = async (_, { id }, { models }) => {

  const comments = await models.Comment.deleteMany({ postid: id });
  console.log(comments.deletedCount);
  const deletePost = await models.Post.deleteOne({ _id: id })

  if (deletePost.deletedCount) return { id: id }

  else throw new ApolloError(`Failed to delete address.`);

};