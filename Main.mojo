# verification-helper: PROBLEM https://judge.yosupo.jp/problem/unionfind_with_potential_non_commutative_group

from atcoder.io import IO
from atcoder.ext.potentialized_unionfind import PotentializedUnionFind
from atcoder.modint import modint998244353

alias mint = modint998244353


struct Matrix_2x2:
    var a: mint
    var b: mint
    var c: mint
    var d: mint

    fn __init__(out self, a: mint, b: mint, c: mint, d: mint):
        self.a = a
        self.b = b
        self.c = c
        self.d = d

    fn __eq__(self, o: Self) -> Bool:
        return (
            self.a == o.a and self.b == o.b and self.c == o.c and self.d == o.d
        )

    fn write_to[W: Writer](self, mut writer: W):
        writer.write(self.a.val, self.b.val, self.c.val, self.d.val)


fn op(x: Matrix_2x2, y: Matrix_2x2) -> Matrix_2x2:
    return Matrix_2x2(
        x.a * y.a + x.b * y.c,
        x.a * y.b + x.b * y.d,
        x.c * y.a + x.d * y.c,
        x.c * y.b + x.d * y.d,
    )


fn main() raises:
    # var _io = IO()
    print(Matrix_2x2(mint(1), mint(0), mint(0), mint(1)))
    # var N = io.nextInt()
    # var Q = io.nextInt()
    # var uf = UnionFindPlus[modint998244353](N)
    # for _ in range(Q):
    #     var t = io.nextInt()
    #     var u = io.nextInt()
    #     var v = io.nextInt()
    #     if t == 0:
    #         x = io.nextInt()
    #         if uf.same(u, v):
    #             if uf.diff(v, u) == x:
    #                 print(1)
    #             else:
    #                 print(0)
    #         else:
    #             print(1)
    #             _ = uf.merge(v, u, modint998244353(x))
    #     else:
    #         if uf.same(u, v):
    #             print(uf.diff(v, u).val)
    #         else:
    #             print(-1)
