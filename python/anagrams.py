#!/usr/bin/env python3
import copy
import json

words = [
'PANS',
'POTS',
'OPT',
'SNAP',
'STOP',
'TOPS',
]

def anagrams(words):
    """ put your code here """
    tmp = copy.deepcopy(words)
    ret_dict = {}
    for word in words:
        sorted_word = ''.join(sorted(word))
        if word in tmp:
            ret_dict[sorted_word] = []
        for word2 in tmp:
            sorted_word2 = ''.join(sorted(word2))
            if sorted_word == sorted_word2:
                ret_dict[sorted_word].append(word2)
                tmp.pop(tmp.index(word2))
    return ret_dict


print(json.dumps(anagrams(words), indent=4))

