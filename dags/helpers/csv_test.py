from itertools import islice
from typing import List


def test_csvs(*, files: List[str]):
    for file in files:
        with open(file, "r") as f:
            for line in islice(f, 0, 9):
                print(line.rstrip())
