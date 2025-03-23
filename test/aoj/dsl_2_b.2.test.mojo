# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DSL_2_B

from atcoder import Segtree, IO


fn add(x: Int, y: Int) -> Int:
    return x + y


fn main() raises:
    var io = IO()
    var n = io.nextInt()
    var q = io.nextInt()
    var seg = Segtree[Int](n, add, 0)
    for _ in range(q):
        var com = io.nextInt()
        var x = io.nextInt()
        var y = io.nextInt()
        if com == 0:
            seg.set(x - 1, y + seg.get(x - 1))
        else:
            print(seg.prod(x - 1, y))
