fn pow_mod(x: Int, n: Int, m: Int) -> Int:
    if m == 1:
        return 0
    var r = 1
    var y = x % m
    var n_ = n
    while n_:
        if n_ & 1:
            r = r * y % m
        y = y * y % m
        n_ = n_ >> 1
    return r

# struct barrett:
#     var _m: UInt32
#     var im: UInt64
    
#     def __init__(out self, m: UInt32):
#         self._m = m
#         self.im = UInt(-1) // UInt64(m) + 1

# fn _is_prime(n: Int) -> Bool:
#     if n <= 1:
#         return False
#     if n == 2 or n == 7 or n == 61:
#         return True
#     if n % 2 == 0:
#         return False

#     d = n - 1
#     while d % 2 == 0:
#         d //= 2

#     for a in List[Int](2, 7, 61):
#         t = d
#         y = pow(a, t, n)
#         while t != n - 1 and y != 1 and y != n - 1:
#             y = y * y % n
#             t <<= 1
#         if y != n - 1 and t % 2 == 0:
#             return False
#     return True


fn _inv_gcd(a: Int, b: Int) -> (Int, Int):
    var s = b
    var t = a % b
    if t == 0:
        return (b, 0)
    var m0 = 0
    var m1 = 1
    while t:
        u = s // t
        s -= t * u
        m0 -= m1 * u
        s, t = t, s
        m0, m1 = m1, m0
    if m0 < 0:
        m0 += b // s
    return (s, m0)


fn _primitive_root(m: Int) -> Int:
    if m == 2:
        return 1
    if m == 167772161:
        return 3
    if m == 469762049:
        return 3
    if m == 754974721:
        return 11
    if m == 998244353:
        return 3

    var divs = List[Int](0) * 20
    divs[0] = 2
    var cnt = 1
    var x = (m - 1) // 2
    while x % 2 == 0:
        x //= 2

    var i = 3
    while i * i <= x:
        if x % i == 0:
            divs[cnt] = i
            cnt += 1
            while x % i == 0:
                x //= i
        i += 2

    if x > 1:
        divs[cnt] = x
        cnt += 1

    var g = 2
    while True:
        for i in range(cnt):
            if pow_mod(g, (m - 1) // divs[i], m) == 1:
                break
        else:
            return g
        g += 1
