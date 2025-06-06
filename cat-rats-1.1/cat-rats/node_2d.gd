extends Node2D
@onready var totalsec : int =0
@onready var timer=$Timer
@onready var label=$labeltimer
@onready var zombie_scene=preload("res://Zombie.tscn")
@onready var vida=$labelvida
@onready var panbase=$panrigido
@onready var ui_scene=preload("res://popup.tscn")	
@onready var CatArcherTowerSprite = preload("res://Tower_Sprites.tscn").instantiate()
var aparicion_menu=null
var vidaTotal=100
var enemy=null
var enemyList= []
var followingCursor= false
func _ready():
	$Timer.start()	
	add_child(CatArcherTowerSprite)
	CatArcherTowerSprite.visible=false
	

func _process(delta):
	$labelvida.text=str(vidaTotal)
	if followingCursor:
		CatArcherTowerSprite.global_position = get_global_mouse_position()
func _on_Timer_timeout():
	totalsec+=1
	
	var minutos=int(totalsec/60)
	var segundos=totalsec-minutos*60
	$labeltimer.text='%02d:%02d' % [minutos,segundos]
	if totalsec%1==0:
		spawnear()
func spawnear ():
	enemy=zombie_scene.instantiate()
	add_child(enemy)
	enemyList.append(enemy)
func menu(event):
	if aparicion_menu == null:
		pass
	else: aparicion_menu.queue_free() 
	aparicion_menu = ui_scene.instantiate()
	add_child(aparicion_menu)
	var panel = aparicion_menu.get_node("PanelContainer")
	print("Panel node:", panel)
	if panel == null:
		print("Error: PanelContainer node not found!")
		return
	await get_tree().process_frame  # Wait one frame for layout to calculate
	var mouse_pos = event.position
	var viewport_rect = get_viewport().get_visible_rect()
	var panel_size = panel.size
	print(panel_size)
	var clamped_x = clamp(mouse_pos.x, 0, viewport_rect.size.x - panel_size.x)
	var clamped_y = clamp(mouse_pos.y, 0, viewport_rect.size.y - panel_size.y)
	panel.global_position = Vector2(clamped_x, clamped_y)
	var firstTowerButton = aparicion_menu.get_node("PanelContainer/MarginContainer/VBoxContainer/towersLine1/firstTower")
	firstTowerButton.connect("button_down", Callable(self, "_on_first_tower_button_down"))	 #Aca trae la senal de otra escena queremos traer esta en especifico para poder usar el input
	#var firstTowerbuttonUp = aparicion_menu.get_node("PanelContainer/MarginContainer/VBoxContainer/towersLine1/firstTower")  # Adjust path if needed
	#firstTowerbuttonUp.connect("button_up", Callable(self, "_on_first_tower_button_up"))	
func _on_area_2d_area_entered(area):	
	enemyList[0].queue_free()	
	enemyList.remove_at(0)
	vidaTotal-=1	
	
func _on_first_tower_button_down ():
		aparicion_menu.queue_free()
		followingCursor=true	
		CatArcherTowerSprite.visible=true
		print("whatever")
#func _on_first_tower_button_up ():
	#print("diego lo mamas")
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		menu(event)

		
#var camaraVisible=get_viewport().get_visible_rect()
