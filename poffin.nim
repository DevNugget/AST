import os
import utils
import strutils

var fileName = paramStr(1)

var lines = newSeq[string](0)

const INT = "INT"
const ADD_OP = "ADD_OP"
const SUB_OP = "SUB_OP"
const MUL_OP = "MUL_OP"
const DIV_OP = "DIV_OP"

const UNDEFINED = "UNDEFINED"

for line in lines(fileName):
    lines.add(line)

var ln_pointer = 0

var numbers = "1234567890"
var tokens = newSeq[string](0)
var allValues = newSeq[string](0)

type 
    intNode = object
        value: int
        token: string

    binOp = object
        left: string
        right: string
        index_left: int
        index_right: int
        op_index: int
        token: string

    node = object
        node: binOp

var AST = newSeq[binOp](0)

for line in lines:
    var ln = line
    ln.removeSuffix("\n")
    var values = splitArgs(ln)
    allValues.add(values)

proc tokenize() =
    tokens = @[]
    ln_pointer = 0
    while ln_pointer < lines.len:
        for value in allValues:
            for chr in value:
                if chr in numbers:
                    tokens.add(INT)
                    break

                elif chr == '+':
                    tokens.add(ADD_OP)
                    break
                elif chr == '-':
                    tokens.add(SUB_OP)
                    break
                elif chr == '*':
                    tokens.add(MUL_OP)
                    break
                elif chr == '/':
                    tokens.add(DIV_OP)
                    break
        ln_pointer += 1
    echo tokens

tokenize()


proc generateNodes() =
    var token_pointer = 0
    AST = @[]
    while token_pointer < tokens.len:
        if tokens[token_pointer] == ADD_OP:
            var addNode: binOp

            var childOne: string
            if token_pointer - 1 > -1:
                childOne = tokens[token_pointer - 1]
                addNode.index_left = token_pointer - 1
                
            var childTwo: string
            if token_pointer + 1 < tokens.len:
                childTwo = tokens[token_pointer + 1]
                addNode.index_right = token_pointer + 1

            addNode.op_index = token_pointer
            addNode.left = childOne
            addNode.right = childTwo
            addNode.token = ADD_OP

            AST.add(addNode)
        token_pointer += 1

generateNodes()

proc parse() =
    for node in AST:
        if node.token == ADD_OP:
            echo node.left & " + " & node.right
            if node.left == INT and node.right == INT:
                var result = parseInt(allValues[node.index_left]) + parseInt(allValues[node.index_right])
                echo result
                allValues.delete(node.index_left)
                allValues.delete(node.op_index - 1)
                allValues.delete(node.index_right - 2)
                allValues.insert($result, node.index_left)
                echo allValues
                tokenize()
                generateNodes()
                parse()
                break

        elif node.token == SUB_OP:
            echo node.left & " - " & node.right
        elif node.token == MUL_OP:
            echo node.left & " * " & node.right
        elif node.token == DIV_OP:
            echo node.left & " / " & node.right
        else:
            echo node.token

parse()