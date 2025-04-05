fn string_to_list(s: String) -> List[Int]:
    var res = List[Int](0) * len(s)
    for i in range(len(s)):
        res[i] = ord(s[i])
    return res
