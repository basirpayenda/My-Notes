from collections import deque

res = deque([1, 2, 3, 4, 5], maxlen=2)
print(res)  # deque([4, 5], maxlen=2)
res = deque([1, 2, 3, 4, 5], maxlen=3)
print(res)  # deque([3, 4, 5], maxlen=3)


# initializing deque
de = deque([1, 2, 3])

# append() to insert element at right end
de.append(4)
print(de)  # deque([1, 2, 3, 4])


# appendleft() to insert element at right end
de.appendleft(6)
print(de)  # deque([6, 1, 2, 3, 4])


# pop() to delete element from right end
de.pop()
print(de)  # deque([6, 1, 2, 3])


# popleft() to delete element from left end
de.popleft()
print(de)  # deque([1, 2, 3])


# index() - to print the first occurrence of 4
# index(ele, beg, end) :- This function returns the first index of the value
# mentioned from beginning till ending index specified.
print(de.index(4, 2, 6))  # 5


# insert() - to insert the value 3 at 5th position
de.insert(4, 5000000)
print(de)  # deque([1, 4, 2, 3, 5000000, 3, 4, 4])


# count() - to count the occurrences of 3
print(de.count(3))  # 2


# remove() - to remove the first occurrence of 3
de.remove(5000000)
print(de)  # deque([1, 4, 2, 3, 3, 4, 4])


# extend() to add numbers to right end
de.extend([4, 5, 6])
print(de)  # deque([1, 2, 3, 4, 5, 6])


# extendleft() to add numbers to left end
de.extendleft([7, 8, 9])
print(de)  # deque([9, 8, 7, 1, 2, 3, 4, 5, 6])


# rotate(): This function rotates the deque by the number specified in arguments.
# If the number specified is negative, rotation occurs to left. Else rotation is to right.
de.rotate(-4)
print(de)  # deque([2, 3, 4, 5, 6, 9, 8, 7, 1])


# reverse() to reverse the deque
de.reverse()
print(de)  # deque([1, 7, 8, 9, 6, 5, 4, 3, 2])
