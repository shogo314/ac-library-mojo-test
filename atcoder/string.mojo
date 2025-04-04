from atcoder.method_traits import HasEqCollectionElement


fn z_algorithm[S: HasEqCollectionElement](s: List[S]) -> List[Int]:
    var n = len(s)
    if n == 0:
        return List[Int]()
    var z = List[Int](0) * n
    var j = 0
    for i in range(1, n):
        if j + z[j] <= i:
            z[i] = 0
        else:
            z[i] = min(j + z[j] - i, z[i - j])
        while i + z[i] < n and s[z[i]] == s[i + z[i]]:
            z[i] += 1
        if j + z[j] < i + z[i]:
            j = i
    z[0] = n
    return z


fn z_algorithm(s: String) -> List[Int]:
    var s2 = List[Int](0) * len(s)
    for i in range(len(s)):
        s2[i] = ord(s[i])
    return z_algorithm(s2)
