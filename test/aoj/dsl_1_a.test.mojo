# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DSL_1_A

from atcoder import DSU, IO


fn main() raises:
    var io = IO()
    var n = io.nextInt()
    var q = io.nextInt()
    var dsu = DSU(n)
    for _ in range(q):
        var com = io.nextInt()
        var x = io.nextInt()
        var y = io.nextInt()
        if com == 0:
            _ = dsu.merge(x, y)
        else:
            if dsu.same(x, y):
                print(1)
            else:
                print(0)
