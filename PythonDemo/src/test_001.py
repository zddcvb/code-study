# -*- coding: UTF-8 -*-
'''
Created on 2016年10月22日

@author: Administrator
'''
from __builtin__ import str
print "---字符串----"
str = "hello python"
# []中可以用来表示str的角标数值，作为index来使用
print "直接输出：" + str
print "输出角标为5的值：" + str[5]
print "直接输出角标0到6的值，不包括角标6" + str[0:6]
print "直接输出角标从1开始的值：" + str[1:]
print "直接输出角标到5开始的值，不包括角标5：" + str[:5]
print "重复输出两次str：" + str * 2
print "---输出list----"
list = [ 'abcd', 786 , 2.23, 'john', 70.2 ]
newlist = [123, 56, "hello"]
print list
print "输出角标为3的值：" + list[3]
print list[0:3]
print list[1:]
print list[:3]
print list * 2
print list + newlist
for j in list:
    print j
    print len(list)
print "---元组----"
tuple = ('abcd', 786 , 2.23, 'john', 70.2)
newtuple = (123, 56, "hello")
print tuple
print tuple[3]
print tuple[0:3]
print tuple[1:]
print tuple[:3]
print tuple * 2
print tuple + newtuple
print "---字典---"
dictionary = {}
dictionary["name"] = "jack"
dictionary["age"] = 20
dictionary["id"] = 30
print dictionary
print dictionary["age"]
print dictionary.keys()
print dictionary.values()
#遍历字典
for i in dictionary.keys():
    print dictionary.get(i)

