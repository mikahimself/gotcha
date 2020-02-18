extends Node

var PATH_N = 0
var PATH_E = 0
var PATH_S = 0
var PATH_W = 0
var VISITED = 0

func get_cell_value() -> int:
    var cell_total = 0
    if PATH_N:
        cell_total += 1
    if PATH_E:
        cell_total += 2
    if PATH_S:
        cell_total += 4
    if PATH_W:
        cell_total += 8
    return cell_total
