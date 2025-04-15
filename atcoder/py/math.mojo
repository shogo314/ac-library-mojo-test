from sys import bitwidthof


@always_inline
fn isqrt(x: Int) -> Int:
    """Performs square root on an integer.

    Args:
        x: The integer value to perform square root on.

    Returns:
        The square root of x.
    """
    if x < 0:
        return 0

    var r = UInt(0)
    var r2 = UInt(0)

    @parameter
    for p in range(bitwidthof[UInt]() // 2, -1, -1):
        var tr2 = r2 + (r << (p + 1)) + (1 << (p + p))
        if tr2 <= UInt(x):
            r2 = tr2
            r |= 1 << p

    return r
