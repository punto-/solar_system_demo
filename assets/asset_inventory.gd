class_name AssetInventory
extends Node

@export var _machines := {
	
}

@export var _miner: PackedScene

func generate_asset(asset_id: int) -> Node:
	return _miner.instantiate()