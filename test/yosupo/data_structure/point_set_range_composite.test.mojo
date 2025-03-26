# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_composite

from atcoder.io import IO
from atcoder.segtree import Segtree
from atcoder.modint import modint998244353

alias mint = modint998244353


struct Affine(CollectionElement):
    var a: mint
    var b: mint

    fn __init__(out self, a: mint, b: mint):
        self.a = a
        self.b = b

    fn __copyinit__(out self, o: Self):
        self.a = o.a
        self.b = o.b

    fn __moveinit__(out self, owned o: Self):
        self.a = o.a
        self.b = o.b

    fn assign(self, x: mint) -> mint:
        return self.a * x + self.b


fn composite(x: Affine, y: Affine) -> Affine:
    return Affine(x.a * y.a, x.b * y.a + y.b)


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var init = List[Affine]()
    for _ in range(N):
        var a = io.nextInt()
        var b = io.nextInt()
        init.append(Affine(mint(a), mint(b)))
    var seg = Segtree[Affine](init, composite, Affine(mint(1), mint(0)))
    for _ in range(Q):
        var q = io.nextInt()
        if q == 0:
            var p = io.nextInt()
            var c = io.nextInt()
            var d = io.nextInt()
            seg.set(p, Affine(mint(c), mint(d)))
        else:
            var l = io.nextInt()
            var r = io.nextInt()
            var x = io.nextInt()
            print(seg.prod(l, r).assign(mint(x)))
