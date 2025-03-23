trait HasAdd:
    fn __add__(self, x: Self) -> Self:
        pass


trait HasNeg:
    fn __neg__(self) -> Self:
        pass


trait HasMul:
    fn __mul__(self, x: Self) -> Self:
        pass


trait HasTruediv:
    fn __truediv__(self, x: Self) -> Self:
        pass


trait HasInitIntLiteral:
    fn __init__(out self, x: IntLiteral):
        pass

