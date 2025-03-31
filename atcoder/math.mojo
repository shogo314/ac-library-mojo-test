from testing import assert_true

import atcoder.internal_math


fn pow_mod(x: Int, n: Int, m: Int) -> Int:
    """
    1 <= m < 2^32.
    """
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


# fn inv_mod(x: Int, m: Int) -> Int:
#     assert 1 <= m

#     z = atcoder.Internal_math._inv_gcd(x, m)

#     assert z[0] == 1

#     return z[1]


# fn crt(r: List[Int], m: List[Int]) -> Tuple[Int, Int]:
#     assert len(r) == len(m)

#     # Contracts: 0 <= r0 < m0
#     r0 = 0
#     m0 = 1
#     for r1, m1 in zip(r, m):
#         assert 1 <= m1
#         r1 %= m1
#         if m0 < m1:
#             r0, r1 = r1, r0
#             m0, m1 = m1, m0
#         if m0 % m1 == 0:
#             if r0 % m1 != r1:
#                 return (0, 0)
#             continue

#         # assume: m0 > m1, lcm(m0, m1) >= 2 * max(m0, m1)

#         '''
#         (r0, m0), (r1, m1) -> (r2, m2 = lcm(m0, m1));
#         r2 % m0 = r0
#         r2 % m1 = r1
#         -> (r0 + x*m0) % m1 = r1
#         -> x*u0*g % (u1*g) = (r1 - r0) (u0*g = m0, u1*g = m1)
#         -> x = (r1 - r0) / g * inv(u0) (mod u1)
#         '''

#         # im = inv(u0) (mod u1) (0 <= im < u1)
#         g, im = atcoder.Internal_math._inv_gcd(m0, m1)

#         u1 = m1 // g
#         # |r1 - r0| < (m0 + m1) <= lcm(m0, m1)
#         if (r1 - r0) % g:
#             return (0, 0)

#         # u1 * u1 <= m1 * m1 / g / g <= m0 * m1 / g = lcm(m0, m1)
#         x = (r1 - r0) // g % u1 * im % u1

#         '''
#         |r0| + |m0 * x|
#         < m0 + m0 * (u1 - 1)
#         = m0 + m0 * m1 / g - m0
#         = lcm(m0, m1)
#         '''

#         r0 += x * m0
#         m0 *= u1  # -> lcm(m0, m1)
#         if r0 < 0:
#             r0 += m0

#     return (r0, m0)


fn floor_sum(n: Int, m: Int, a: Int, b: Int) raises -> Int:
    assert_true(1 <= n)
    assert_true(1 <= m)
    var x = a
    var y = b
    ans = 0
    if x >= m:
        ans += (n - 1) * n * (x // m) // 2
        x %= m
    if y >= m:
        ans += n * (y // m)
        y %= m
    y_max = (x * n + y) // m
    x_max = y_max * m - y
    if y_max == 0:
        return ans
    ans += (n - (x_max + x - 1) // x) * y_max
    ans += floor_sum(y_max, x, m, (x - x_max % x) % x)
    return ans
