from testing import assert_true
from atcoder.io import IO
from atcoder.internal_type_traits import HasAdd, HasSub
from collections import Deque


trait Capable(
    CollectionElement, Defaultable, HasAdd, HasSub, Comparable, Writable
):
    pass


struct Edge[Cap: Capable](CollectionElement):
    var src: Int
    var dst: Int
    var cap: Cap
    var flow: Cap

    fn __init__(out self, src: Int, dst: Int, cap: Cap, flow: Cap):
        self.src = src
        self.dst = dst
        self.cap = cap
        self.flow = flow

    fn __copyinit__(out self, o: Self):
        self.src = o.src
        self.dst = o.dst
        self.cap = o.cap
        self.flow = o.flow

    fn __moveinit__(out self, owned o: Self):
        self.src = o.src
        self.dst = o.dst
        self.cap = o.cap
        self.flow = o.flow


struct _Edge[Cap: Capable](CollectionElement):
    var dst: Int
    var rev: Int
    var cap: Cap

    fn __init__(out self, dst: Int, rev: Int, cap: Cap):
        self.dst = dst
        self.rev = rev
        self.cap = cap

    fn __copyinit__(out self, o: Self):
        self.dst = o.dst
        self.rev = o.rev
        self.cap = o.cap

    fn __moveinit__(out self, owned o: Self):
        self.dst = o.dst
        self.rev = o.rev
        self.cap = o.cap


struct MFGraph[Cap: Capable]:
    var _n: Int
    var _g: List[List[_Edge[Cap]]]
    var _pos: List[(Int, Int)]

    fn __init__(out self, n: Int):
        self._n = n
        self._g = List[List[_Edge[Cap]]](List[_Edge[Cap]]()) * n
        self._pos = List[(Int, Int)]()

    fn add_edge(mut self, src: Int, dst: Int, cap: Cap) raises -> Int:
        assert_true(0 <= src < self._n)
        assert_true(0 <= dst < self._n)
        assert_true(Cap() <= cap)
        var m = len(self._pos)
        self._pos.append((src, len(self._g[src])))
        var src_id = len(self._g[src])
        var dst_id = len(self._g[dst])
        if src == dst:
            dst_id += 1
        self._g[src].append(_Edge(dst, dst_id, cap))
        self._g[dst].append(_Edge(src, src_id, Cap()))
        return m

    fn get_edge(self, i: Int) raises -> Edge[Cap]:
        var m = len(self._pos)
        assert_true(0 <= i < m)
        var _e = self._g[self._pos[i][0]][self._pos[i][1]]
        var _re = self._g[_e.dst][_e.rev]
        return Edge(self._pos[i][0], _e.dst, _e.cap + _re.cap, _re.cap)

    fn edges(self) raises -> List[Edge[Cap]]:
        var m = len(self._pos)
        var result = List[Edge[Cap]]()
        for i in range(m):
            result.append(self.get_edge(i))
        return result

    fn change_edge(mut self, i: Int, new_cap: Cap, new_flow: Cap) raises:
        var m = len(self._pos)
        assert_true(0 <= i < m)
        assert_true(Cap() <= new_flow <= new_cap)
        var _e = self._g[self._pos[i][0]][self._pos[i][1]]
        var _re = self._g[_e.dst][_e.rev]
        _e.cap = new_cap - new_flow
        _re.cap = new_flow
        self._g[self._pos[i][0]][self._pos[i][1]] = _e
        self._g[_e.dst][_e.rev] = _re

    fn flow(mut self, s: Int, t: Int, flow_limit: Cap) raises -> Cap:
        assert_true(0 <= s < self._n)
        assert_true(0 <= t < self._n)
        assert_true(s != t)
        var level = List[Int](0) * self._n
        var current_edge = List[Int](0) * self._n

        var flow = Cap()
        while flow < flow_limit:
            for i in range(self._n):
                level[i] = -1
            level[s] = 0
            var queue = Deque[Int]()
            queue.append(s)
            while queue:
                var v = queue.popleft()
                for e in self._g[v]:
                    if e[].cap == Cap() or level[e[].dst] >= 0:
                        continue
                    level[e[].dst] = level[v] + 1
                    if e[].dst == t:
                        queue.clear()
                        break
                    queue.append(e[].dst)

            if level[t] == -1:
                break
            for i in range(self._n):
                current_edge[i] = 0

            var res = Cap()
            var stack = List[(Int, Cap, Cap, Bool)]()
            stack.append((t, flow_limit - flow, Cap(), True))
            while stack:
                var v = stack[-1][0]
                var up = stack[-1][1]
                var w = stack[-1][2]
                var f = stack[-1][3]
                _ = stack.pop()
                if v == s:
                    res = up
                    continue
                var i = current_edge[v]
                if i == len(self._g[v]):
                    level[v] = self._n
                    res = w
                    continue
                var e = self._g[v][current_edge[i]]
                if f:
                    if (
                        level[v] <= level[e.dst]
                        or self._g[e.dst][e.rev].cap == Cap()
                    ):
                        current_edge[v] += 1
                        stack.append((v, up, w, True))
                        continue
                    res = w
                    var tmp = up - res
                    if tmp > self._g[e.dst][e.rev].cap:
                        tmp = self._g[e.dst][e.rev].cap
                    stack.append((v, up, w, False))
                    stack.append((e.dst, tmp, Cap(), True))
                else:
                    var d = res
                    if d <= Cap():
                        current_edge[v] += 1
                        stack.append((v, up, w, True))
                        continue
                    self._g[v][i].cap = self._g[v][i].cap + d
                    self._g[e.dst][e.rev].cap = self._g[e.dst][e.rev].cap - d
                    w = w + d
                    if w == up:
                        res = w
                        continue
                    current_edge[v] += 1
                    stack.append((v, up, w, True))
            flow = flow + res
        return flow


fn main() raises:
    var DX = List[Int](1, 0, -1, 0)
    var DY = List[Int](0, 1, 0, -1)
    var io = IO()
    var N = io.nextInt()
    var M = io.nextInt()
    var S = List[String]()
    for _ in range(N):
        S.append(io.next())
    var mf_graph = MFGraph[Int](N * M + 2)
    for i in range(N):
        for j in range(M):
            if (i + j) % 2 == 0:
                for dir in range(4):
                    var i2 = i + DX[dir]
                    var j2 = j + DY[dir]
                    if not 0 <= i2 < N:
                        continue
                    if not 0 <= j2 < M:
                        continue
                    if S[i][j] == "." and S[i][j] == ".":
                        _ = mf_graph.add_edge(i * M + j, i2 * M + j2, 1)
            if S[i][j] == ".":
                if (i + j) % 2 == 0:
                    _ = mf_graph.add_edge(N * M, i * M + j, 1)
                else:
                    _ = mf_graph.add_edge(i * M + j, N * M + 1, 1)
    var max_flow = mf_graph.flow(N * M, N * M + 1, Int.MAX)
    var ans = List[List[String]](List[String]("") * M) * N
    for i in range(N):
        for j in range(M):
            ans[i][j] = S[i][j]
    for e in mf_graph.edges():
        if e[].src == N * M:
            continue
        if e[].dst == N * M + 1:
            continue
        if e[].flow == 0:
            continue
        var i_src = e[].src // M
        var j_src = e[].src % M
        var i_dst = e[].dst // M
        var j_dst = e[].dst % M
        if i_src == i_dst:
            if j_src > j_dst:
                j_src, j_dst = j_dst, j_src
            ans[i_src][j_src] = ">"
            ans[i_dst][j_dst] = "<"
        else:
            if i_src > i_dst:
                i_src, i_dst = i_dst, i_src
            ans[i_src][j_src] = "v"
            ans[i_dst][j_dst] = "^"
    print(max_flow)
    for i in range(N):
        print("".join(ans[i]))
