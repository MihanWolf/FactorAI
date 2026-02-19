class_name ItemInstance
extends Resource

var data: ItemData
var quality: String = ""
var disc: String = ""

static func create_random(from_data: ItemData):
	var instance = ItemInstance.new()
	instance.data = from_data
	instance.quality = from_data.q.pick_random()
	instance.disc = from_data.disc
	return instance
