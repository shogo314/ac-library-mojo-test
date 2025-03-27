# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_A

from atcoder.io import IO
from atcoder.segtree import RMinQ


fn main() raises:
    var io = IO()
    var n = io.nextInt()
    var q = io.nextInt()
    var seg = RMinQ[Int](n, 2**31 - 1)
    for _ in range(q):
        var com = io.nextInt()
        var x = io.nextInt()
        var y = io.nextInt()
        if com == 0:
            seg.set(x, y)
        else:
            print(seg.prod(x, y + 1))
