# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_point_get

from atcoder.io import IO
from atcoder.ext.dualsegtree import DualSegtree
from atcoder.modint import modint998244353
from atcoder.ext.affine import Affine

alias mint = modint998244353


fn composite(x: Affine[mint], y: Affine[mint]) -> Affine[mint]:
    return x.assign(y)


fn mapping(f: Affine[mint], x: mint) -> mint:
    return f.assign(x)


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var init = io.nextList[mint](N)
    var seg = DualSegtree[mint, Affine[mint]](
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
