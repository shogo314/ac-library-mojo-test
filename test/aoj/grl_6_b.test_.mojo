# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_B

from atcoder.io import IO
from atcoder.mincostflow import MCFGraph


fn main() raises:
    var io = IO()
    var n = io.nextInt()
    var m = io.nextInt()
    var f = io.nextInt()
    var mcf_graph = MCFGraph[Int,Int](n)
    for _ in range(m):
        var u = io.nextInt()
        var v = io.nextInt()
        var c = io.nextInt()
        var d = io.nextInt()
        _ = mcf_graph.add_edge(u, v, c, d)
