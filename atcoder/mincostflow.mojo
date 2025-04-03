from testing import assert_true
from collections import Deque

from atcoder.internal_csr import CSR
from atcoder.method_traits import HasAdd, HasSub


trait Capable(CollectionElement, Defaultable, HasAdd, HasSub, Comparable):
    pass


trait Costable(CollectionElement, Defaultable, HasAdd, HasSub, Comparable):
    pass


@value
struct Edge[Cap: Capable, Cost: Costable]:
    var src: Int
    var dst: Int
    var cap: Cap
    var flow: Cap
    var cost: Cost


@value
struct _Edge[Cap: Capable, Cost: Costable]:
    var dst: Int
    var rev: Int
    var cap: Cap
    var cost: Cost

    fn __init__(out self):
        self.dst = -1
        self.rev = -1
        self.cap = Cap()
        self.cost = Cost()


struct MCFGraph[Cap: Capable, Cost: Costable]:
    var _n: Int
    var _edges: List[Edge[Cap, Cost]]

    fn __init__(out self, n: Int):
        self._n = n
        self._edges = List[Edge[Cap, Cost]]()

    fn add_edge(
        mut self, src: Int, dst: Int, cap: Cap, cost: Cost
    ) raises -> Int:
        assert_true(0 <= src < self._n)
        assert_true(0 <= dst < self._n)
        assert_true(Cap() <= cap)
        assert_true(Cost() <= cost)
        var m = len(self._edges)
        self._edges.append(Edge[Cap, Cost](src, dst, cap, Cap(), cost))
        return m

    fn get_edge(self, i: Int) raises -> Edge[Cap, Cost]:
        var m = len(self._edges)
        assert_true(0 <= i < m)
        return self._edges[i]

    fn edges(self) -> List[Edge[Cap, Cost]]:
        return self._edges

    fn flow(self, s: Int, t: Int, flow_limit: Cap) raises -> (Cap, Cost):
        return self.slope(s, t, flow_limit)[-1]

    fn slope(self, s: Int, t: Int, flow_limit: Cap) raises -> List[(Cap, Cost)]:
        assert_true(0 <= s < self._n)
        assert_true(0 <= t < self._n)
        assert_true(s != t)
        var m = len(self._edges)
        var edge_idx = List[Int](0) * m

        var degree = List[Int](0) * self._n
        var redge_idx = List[Int](0) * m
        var elist = List[(Int, _Edge)]()
        for i in range(m):
            var e = self._edges[i]
            edge_idx[i] = degree[e.src]
            degree[e.src] += 1
            redge_idx[i] = degree[e.dst]
            degree[e.dst] += 1
            elist.append((e.src, _Edge(e.dst, -1, e.cap - e.flow, e.cost)))
            elist.append((e.dst, _Edge(e.src, -1, e.flow, -e.cost)))
        var g = CSR(self._n, elist)
        for i in range(m):
            var e = self._edges[i]
            edge_idx[i] += g.start[e.src]
            redge_idx[i] += g.start[e.dst]
            g.elist[edge_idx[i]].rev = redge_idx[i]
            g.elist[redge_idx[i]].rev = edge_idx[i]

        var result = self._slope(g, s, t, flow_limit)

        for i in range(m):
            var e = g.elist[edge_idx[i]]
            self._edges[i].flow = self._edges[i].cap - e.cap

        return result

    fn _slope(
        self, g: CSR[_Edge[Cap, Cost]], s: Int, t: Int, flow_limit: Cap
    ) -> List[(Cap, Cost)]:
        var dual_dist = List[(Cost, Cost)](Cost(), Cost()) * self._n
        var prev_e = List[Int](0) * self._n
        var vis = List[Bool](False) * self._n
