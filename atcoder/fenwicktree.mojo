from testing import assert_true

from atcoder.method_traits import AddGroup


struct FenwickTree[T: AddGroup]:
    var _n: Int
    var data: List[T]

    fn __init__(out self, n: Int):
        self._n = n
        self.data = List[T](T()) * n

    fn add(mut self, p: Int, x: T) raises -> None:
        assert_true(0 <= p < self._n)

        var q = p + 1
        while q <= self._n:
            self.data[q - 1] = self.data[q - 1] + x
            q += q & -q

    fn sum(self, left: Int, right: Int) raises -> T:
        assert_true(0 <= left <= right <= self._n)
        return self._sum(right) + -self._sum(left)

    fn _sum(self, r: Int) -> T:
        var t = r
        var s = T()
        while t > 0:
            s = s + self.data[t - 1]
            t -= t & -t
        return s
