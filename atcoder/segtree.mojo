from testing import assert_true

from atcoder.internal_bit import bit_ceil, countr_zero
from atcoder.method_traits import HasAdd, HasInitIntLiteral, HasMul


struct Segtree[S: CollectionElement]:
    var n: Int
    var size: Int
    var log: Int
    var d: List[S]
    var op: fn (S, S) -> S
    var e: S

    fn __init__(out self, n: Int, op: fn (S, S) -> S, e: S):
        self.n = n
        self.size = Int(bit_ceil(self.n))
        self.log = countr_zero(self.size)
        self.d = List[S](e) * (2 * self.size)
        self.op = op
        self.e = e

    fn __init__(out self, v: List[S], op: fn (S, S) -> S, e: S):
        self.n = len(v)
        self.size = Int(bit_ceil(self.n))
        self.log = countr_zero(self.size)
        self.op = op
        self.e = e
        self.d = List[S](e) * (2 * self.size)
        for i in range(self.n):
            self.d[self.size + i] = v[i]
        for i in reversed(range(1, self.size)):
            self.update(i)

    fn update(mut self, k: Int) -> None:
        self.d[k] = self.op(self.d[2 * k], self.d[2 * k + 1])

    fn set(mut self, p: Int, x: S) raises -> None:
        assert_true(0 <= p < self.n)
        var q = p + self.size
        self.d[q] = x
        for i in range(1, self.log + 1):
            self.update(q >> i)

    fn get(mut self, p: Int) raises -> S:
        assert_true(0 <= p < self.n)
        return self.d[p + self.size]

    fn prod(self, l: Int, r: Int) raises -> S:
        assert_true(0 <= l and l <= r and r <= self.n)
        var sml = self.e
        var smr = self.e
        var a = l + self.size
        var b = r + self.size
        while a < b:
            if a & 1:
                sml = self.op(sml, self.d[a])
                a += 1
            if b & 1:
                b -= 1
                smr = self.op(self.d[b], smr)
            a >>= 1
            b >>= 1
        return self.op(sml, smr)

    fn all_prod(self) -> S:
        return self.d[1]


trait RSumQElement(CollectionElement, Defaultable, HasAdd):
    pass


fn RSumQ[S: RSumQElement](n: Int) -> Segtree[S]:
    fn add(x: S, y: S) -> S:
        return x + y

    return Segtree[S](n, add, S())


trait RMulQElement(CollectionElement, HasInitIntLiteral, HasMul):
    pass


fn RMulQ[S: RMulQElement](n: Int) -> Segtree[S]:
    fn mul(x: S, y: S) -> S:
        return x * y

    return Segtree[S](n, mul, S(1))


trait RMaxQElement(CollectionElement, Comparable):
    pass


fn RMaxQ[S: RMaxQElement](n: Int, MIN: S) -> Segtree[S]:
    fn op(x: S, y: S) -> S:
        if x < y:
            return y
        else:
            return x

    return Segtree[S](n, op, MIN)


trait RMinQElement(CollectionElement, Comparable):
    pass


fn RMinQ[S: RMaxQElement](n: Int, MAX: S) -> Segtree[S]:
    fn op(x: S, y: S) -> S:
        if x > y:
            return y
        else:
            return x

    return Segtree[S](n, op, MAX)
