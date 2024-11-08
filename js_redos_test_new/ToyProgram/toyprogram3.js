function main (str) {
    if (str.length > 10 && str.length < 16 &&
        str.substring(8, 14) === 'github') {
        var matched = str.match(/https:\/\/(.*\/?)*\/$/i)
        console.log(matched)
    }
}