# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_add_range_sum

from atcoder import FenwickTree,IO

fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var bit = FenwickTree[Int](N)
    for i in range(N):
        var a = io.nextInt()
        bit.add(i, a)
    for _ in range(Q):
        var t = io.nextInt()
        if t == 0:
            var p = io.nextInt()
            var x = io.nextInt()
            bit.add(p, x)
        else:
            var l = io.nextInt()
            var r = io.nextInt()
            print(bit.sum(l, r))
