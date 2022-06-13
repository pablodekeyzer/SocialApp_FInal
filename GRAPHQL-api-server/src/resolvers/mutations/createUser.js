
module.exports = async (_, { input }, { models }) => {

    //if user exist return
    const user = await models.User.findOne({ id: input.id });
    if (user) {
        return;
    }
    newUser = await models.User.create(input);
    return newUser

};
