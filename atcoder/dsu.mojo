from testing import assert_true


struct DSU:
    var n: Int
    var parent_or_size: List[Int]

    fn __init__(out self, n: Int):
        self.n = n
        self.parent_or_size = List[Int](-1) * n

    fn merge(mut self, a: Int, b: Int) raises -> Int:
        assert_true(0 <= a < self.n)
        assert_true(0 <= b < self.n)
        var x: Int = self.leader(a)
        var y: Int = self.leader(b)
        if x == y:
            return x
        if -self.parent_or_size[x] < -self.parent_or_size[y]:
            x, y = y, x
        self.parent_or_size[x] += self.parent_or_size[y]
        self.parent_or_size[y] = x
        return x

    fn same(mut self, a: Int, b: Int) raises -> Bool:
        assert_true(0 <= a < self.n)
        assert_true(0 <= b < self.n)
        return self.leader(a) == self.leader(b)

    fn leader(mut self, a: Int) raises -> Int:
        assert_true(0 <= a < self.n)
        if self.parent_or_size[a] < 0:
            return a
        self.parent_or_size[a] = self.leader(self.parent_or_size[a])
        return self.parent_or_size[a]

    fn size(mut self, a: Int) raises -> Int:
        assert_true(0 <= a < self.n)
        return -self.parent_or_size[self.leader(a)]

    fn groups(mut self) raises -> List[List[Int]]:
        var leader_buf = List[Int](0) * self.n
        var group_size = List[Int](0) * self.n
        for i in range(self.n):
            leader_buf[i] = self.leader(i)
            group_size[leader_buf[i]] += 1
        var result = List[List[Int]](List[Int]()) * self.n
        for i in range(self.n):
            result[leader_buf[i]].append(i)
        var res = List[List[Int]]()
        for i in range(self.n):
            if len(result[i]):
                res.append(result[i])
        return res


alias UnionFind = DSU
