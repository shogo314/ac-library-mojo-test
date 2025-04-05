from atcoder.ext.bisect import bisect_left


fn longest_increasing_subsequence(a: List[Int]) -> Int:
    var dp = List[Int](Int.MAX) * len(a)
    for i in range(len(a)):
        dp[bisect_left(dp, a[i])] = a[i]
    for i in reversed(range(len(a))):
        if dp[i] < Int.MAX:
            return i + 1
    return 0
