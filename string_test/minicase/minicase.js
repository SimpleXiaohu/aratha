function main (str) {
    if (str.length > 10 && str.length < 50 && str.substring(8, 14) === 'github') {
        // var matched = str.match(/https:\/\/(.*\/?)*\//i)
        var matched = /https:\/\/(.*\/?)*\//i.exec(str)
        if (matched) {
            console.log(matched[0])
        }
        console.log(matched)
    }
}

var str = J$.readString()
main(str)