# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_point_get

from atcoder.io import IO
from atcoder.ext.dualsegtree import DualSegtree
from atcoder.modint import modint998244353

alias mint = modint998244353


@value
struct Affine(CollectionElement):
    var a: mint
    var b: mint

    fn assign(self, x: mint) -> mint:
        return self.a * x + self.b

    fn assign(self, x: Affine) -> Affine:
        return Affine(self.a * x.a, self.a * x.b + self.b)


fn composite(x: Affine, y: Affine) -> Affine:
    return x.assign(y)


fn mapping(f: Affine, x: mint) -> mint:
    return f.assign(x)


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var init = List[mint]()
    for _ in range(N):
        var a = io.nextInt()
        init.append(mint(a))
    var seg = DualSegtree[mint, Affine](
        init, mapping, composite, Affine(mint(1), mint(0))
    )
    for _ in range(Q):
        var q = io.nextInt()
        if q == 0:
            var l = io.nextInt()
            var r = io.nextInt()
            var b = io.nextInt()
            var c = io.nextInt()
            seg.apply(l, r, Affine(mint(b), mint(c)))
        else:
            var i = io.nextInt()
            print(seg.get(i))
