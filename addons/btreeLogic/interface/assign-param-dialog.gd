tool
extends WindowDialog

signal dialog_finished(result)

onready var msg_lbl = $"marginc/vbox/msg-lbl"
onready var param_list_btn = $"marginc/vbox/param-list-btn"
onready var notice_lbl = $"marginc/vbox/notice-lbl"
onready var connect_btn = $"marginc/vbox/hbox/connect-btn"
onready var cancel_btn = $"marginc/vbox/hbox/cancel-btn"

var param_list = null
var param_holder = null

func get_type(id: int) -> String:
	if id == 0:
		return '[Arr]'
	elif id == 1:
		return '[Dict]'
	elif id == 2:
		return '[Str]'
	else:
		return '[Num]'

func ask_for(list, params) -> void:

	connect_btn.show()
	cancel_btn.show()
	notice_lbl.hide()
	param_list_btn.show()

	param_list = list
	param_holder = params

	msg_lbl.text = 'Assigning ' + param_holder.get_var_name() + ' ' +get_type( param_holder.get_type()) + " to "

	var data = param_list.get_data()

	param_list_btn.clear()
	for i in range(data.size()):
		if param_holder.get_type() == data[i].type:
			param_list_btn.add_item(data[i].param, i)


	if param_list_btn.get_item_count() == 0:
		notice_lbl.show()
		notice_lbl.text = 'There are no parameter of the same type to connect to, create a parameter on the params menu'
		connect_btn.hide()
		param_list_btn.hide()

	popup_centered_minsize(Vector2(800, 300))


func _on_cancelbtn_pressed():
	param_list = null
	param_holder = null
	hide()

func _on_connectbtn_pressed():
	var idx :int = param_list_btn.get_item_id(param_list_btn.selected)
	param_list.consolidate_connection(param_holder, idx)
	param_list = null
	param_holder = null
	hide()

