# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_set_range_composite

from collections import Optional

from atcoder.io import IO
from atcoder.lazysegtree import LazySegtree
from atcoder.modint import modint998244353

alias mint = modint998244353


struct WithSize[T: CollectionElement](CollectionElement):
    var value: T
    var size: Int

    fn __init__(out self, value: T):
        self.value = value
        self.size = 1

    fn __init__(out self, value: T, size: Int):
        self.value = value
        self.size = size

    fn __copyinit__(out self, o: Self):
        self.value = o.value
        self.size = o.size

    fn __moveinit__(out self, owned o: Self):
        self.value = o.value
        self.size = o.size


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

    fn assign(self, o: Self) -> Self:
        return Self(self.a * o.a, self.a * o.b + self.b)

    fn assign(self, x: mint) -> mint:
        return self.a * x + self.b


fn mapping(f: Optional[Affine], x: WithSize[Affine]) -> WithSize[Affine]:
    if f:
        try:
            var fv = f.value()
            var pw = fv.a.pow(x.size)
            return WithSize[Affine](
                Affine(pw, (pw - 1) / (fv.a - 1) * fv.b), x.size
            )
        except:
            return WithSize[Affine](Affine(mint(1), mint(0)), 0)
    else:
        return x


fn composite(x: Optional[Affine], y: Optional[Affine]) -> Optional[Affine]:
    if x:
        return x
    else:
        return y


fn id() -> Optional[Affine]:
    return Optional[Affine](None)


fn op(x: WithSize[Affine], y: WithSize[Affine]) -> WithSize[Affine]:
    return WithSize[Affine](y.value.assign(x.value), x.size + y.size)


fn e() -> WithSize[Affine]:
    return WithSize[Affine](Affine(mint(1), mint(0)), 0)


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var Q = io.nextInt()
    var init = List[WithSize[Affine]]()
    for _ in range(N):
        var a = io.nextInt()
        var b = io.nextInt()
        init.append(WithSize[Affine](Affine(mint(a), mint(b))))
    var seg = LazySegtree[WithSize[Affine], Optional[Affine]](
        init, op, e(), mapping, composite, id()
    )
    for _ in range(Q):
        var q = io.nextInt()
        if q == 0:
            var l = io.nextInt()
            var r = io.nextInt()
            var c = io.nextInt()
            var d = io.nextInt()
            seg.apply(l, r, Optional[Affine](Affine(mint(c), mint(d))))
        else:
            var l = io.nextInt()
            var r = io.nextInt()
            var x = io.nextInt()
            print(seg.prod(l, r).value.assign(mint(x)))
