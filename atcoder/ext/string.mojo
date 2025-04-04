from atcoder.method_traits import HasEqCollectionElement


fn levenshtein_distance[C: HasEqCollectionElement](s1: List[C], s2: List[C]) -> Int:
    var dp = List[List[Int]](List[Int](0) * (len(s2) + 1)) * (len(s1) + 1)
    for i in range(len(s1)):
        dp[i + 1][0] = i + 1
    for j in range(len(s2)):
        dp[0][j + 1] = j + 1
    for i in range(len(s1)):
        for j in range(len(s2)):
            dp[i + 1][j + 1] = min(dp[i][j + 1], dp[i + 1][j], dp[i][j]) + 1
            if s1[i] == s2[j]:
                dp[i + 1][j + 1] = dp[i][j]
    return dp[-1][-1]


fn levenshtein_distance(s1: String, s2: String) -> Int:
    var s1_ = List[Int](0) * len(s1)
    for i in range(len(s1)):
        s1_[i] = ord(s1[i])
    var s2_ = List[Int](0) * len(s2)
    for i in range(len(s2)):
        s2_[i] = ord(s2[i])
    return levenshtein_distance(s1_, s2_)


fn edit_distance[C: HasEqCollectionElement](s1: List[C], s2: List[C]) -> Int:
    return levenshtein_distance(s1, s2)


fn edit_distance(s1: String, s2: String) -> Int:
    return levenshtein_distance(s1, s2)
