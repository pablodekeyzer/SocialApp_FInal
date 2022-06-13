

function timeStringHelper(time) {
    let now = new Date();
    let output = "";
    const diffTime = Math.abs(now - new Date(time));
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    const diffHrs = Math.ceil(diffTime / (1000 * 60 * 60));
    const diffMins = Math.ceil(diffTime / (1000 * 60));
    if (diffDays > 1) {
        output = diffDays + ' days ago';
    } else if (diffHrs > 1) {
        output = diffHrs + ' hours ago';
    } else if (diffMins > 1) {
        output = diffMins + ' minutes ago';
    } else {
        output = 'just now';
    }
    return [output, diffTime];

}

module.exports = {
    timeStringHelper
}