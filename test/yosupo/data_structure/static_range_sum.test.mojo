# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum

from atcoder.io import IO
from atcoder.fenwicktree import FenwickTree


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var bit = FenwickTree[Int](N)
    for i in range(N):
        var a = io.nextInt()
        bit.add(i, a)
    for _ in range(Q):
        var l = io.nextInt()
        var r = io.nextInt()
        print(bit.sum(l, r))
