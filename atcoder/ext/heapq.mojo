from testing import assert_true


trait HeapElement(CollectionElement, Comparable):
    pass


fn heappush[S: HeapElement](mut heap: List[S], item: S):
    var k = len(heap)
    heap.append(item)
    while k:
        var nk = (k - 1) >> 1
        if heap[nk] > heap[k]:
            heap.swap_elements(k, nk)
            k = nk
        else:
            break


fn heappop[S: HeapElement](mut heap: List[S]) raises -> S:
    assert_true(len(heap))
    if len(heap) == 1:
        return heap.pop()
    var res = heap[0]
    heap[0] = heap.pop()
    _heapify(heap, 0)
    return res


fn heappushpop[S: HeapElement](mut heap: List[S], item: S) -> S:
    if len(heap):
        if item <= heap[0]:
            return item
        else:
            var res = heap[0]
            heap[0] = item
            _heapify(heap, 0)
            return res
    else:
        return item


fn heapify[S: HeapElement](mut heap: List[S]):
    for i in reversed(range(len(heap))):
        _heapify(heap, i)


fn heapreplace[S: HeapElement](mut heap: List[S], item: S) raises -> S:
    assert_true(len(heap))
    var res = heap[0]
    heap[0] = item
    _heapify(heap, 0)
    return res


fn _heapify[S: HeapElement](mut heap: List[S], k: Int):
    if len(heap) <= 2 * k + 1:
        pass
    else:
        var nk = 2 * k + 1
        if 2 * k + 2 < len(heap) and heap[2 * k + 1] > heap[2 * k + 2]:
            nk = 2 * k + 2
        if heap[k] > heap[nk]:
            heap.swap_elements(k, nk)
            _heapify(heap, nk)


struct Heap[S: HeapElement]:
    var data: List[S]

    fn __init__(out self):
        self.data = List[S]()

    fn __init__(out self, data: List[S]):
        self.data = data
        heapify(self.data)

    fn top(self) raises -> S:
        assert_true(len(self.data))
        return self.data[0]

    fn push(mut self, item: S):
        heappush(self.data, item)

    fn pop(mut self) raises -> S:
        return heappop(self.data)

    fn __bool__(self) -> Bool:
        return len(self.data)

    fn __len__(self) -> Int:
        return len(self.data)
