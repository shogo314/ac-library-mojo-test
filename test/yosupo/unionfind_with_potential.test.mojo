# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind_with_potential

from atcoder import IO, UnionFindPlus, modint998244353


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var uf = UnionFindPlus[modint998244353](N)
    for _ in range(Q):
        var t = io.nextInt()
        var u = io.nextInt()
        var v = io.nextInt()
        if t == 0:
            x = io.nextInt()
            if uf.same(u, v):
                if uf.diff(v, u) == x:
                    print(1)
                else:
                    print(0)
            else:
                print(1)
                _ = uf.merge(v, u, modint998244353(x))
        else:
            if uf.same(u, v):
                print(uf.diff(v, u).val)
            else:
                print(-1)
