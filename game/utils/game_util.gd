class_name GameUtil
extends Object

static func get_dynamic_parent(n: Node) -> Node:
	var parent = n.get_node_or_null("%DynamicParent")
	if !parent:
		parent = n.get_parent()
	return parent
