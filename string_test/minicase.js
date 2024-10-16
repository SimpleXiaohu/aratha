function main (str) {
    if (str.length > 10 && str.length < 50 && str.substring(8, 14) === 'github') {
        var matched = str.match(/https:\/\/(.*\/?)*\//i)
        console.log(matched)
    }
}

var str = J$.readString()
main(str)