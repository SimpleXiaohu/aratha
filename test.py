
def main(arg1) -> dict:
    res = ""
    for i, v in enumerate(arg1):
        res += "### Number " + str(i + 1) + "\n"
        res += v
        if i != len(arg1) - 1:
            res += "\n\n"
    return {
        "result": arg1 + arg2,
    }
