# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_D

from atcoder.io import IO
from atcoder.ext.longest_increasing_subsequence import (
    longest_increasing_subsequence,
)


fn main() raises:
    var io = IO()
    var n = io.nextInt()
    var a = io.nextListInt(n)
    print(longest_increasing_subsequence(a))
