extends Node

@onready var config_node = get_node_or_null("/root/VisualZoneMCM")

const FILE_PATH = "user://MCM/visual_zone/config.ini"

const DEF_LUT        = "Default"
const DEF_LUT_INT    = 0.85
const DEF_EXPOSURE   = 0.8
const DEF_CONTRAST   = 0.85
const DEF_SATURATION = 1.25

var current_lut        : String = DEF_LUT
var current_lut_int    : float  = DEF_LUT_INT
var current_exposure   : float  = DEF_EXPOSURE
var current_contrast   : float  = DEF_CONTRAST
var current_saturation : float  = DEF_SATURATION

var spatial_rig : Node3D
var tm_mesh     : MeshInstance3D
var tonemap_mat : ShaderMaterial

var _current_active_camera : Camera3D = null
var search_timer : float = 0.0
const SEARCH_INTERVAL : float = 2.0

const LUT_PATHS = {
	"Zone":    "res://visual_zone/luts/zone.png",
	"Pripyat": "res://visual_zone/luts/pripyat.png",
	"Anomaly": "res://visual_zone/luts/anomaly.png",
	"Tarkov":  "res://visual_zone/luts/tarkov.png",
	"Woods":   "res://visual_zone/luts/woods.png",
	"Reserve": "res://visual_zone/luts/reserve.png",
}

func _ready():
	process_priority = 10000
	process_mode = Node.PROCESS_MODE_ALWAYS
	_init_post_process()
	_load_and_apply()
	print("[VisualZone] Loaded")

func _process(delta):
	search_timer += delta
	if search_timer >= SEARCH_INTERVAL:
		search_timer = 0.0

	var cam = get_viewport().get_camera_3d()
	if is_instance_valid(cam) and cam.is_inside_tree():
		spatial_rig.global_transform = cam.global_transform
		spatial_rig.visible = true
		if cam != _current_active_camera:
			_current_active_camera = cam
			_apply_all_uniforms()
	else:
		if is_instance_valid(spatial_rig):
			spatial_rig.visible = false

func _init_post_process():
	spatial_rig = Node3D.new()
	spatial_rig.top_level = true
	add_child(spatial_rig)

	tonemap_mat = ShaderMaterial.new()
	var tm_shader = load("res://visual_zone/Shaders/tonemap_lut.gdshader")
	if tm_shader:
		tonemap_mat.shader = tm_shader
		tm_mesh = _create_quad(tonemap_mat, -8)
		spatial_rig.add_child(tm_mesh)

func _create_quad(mat: ShaderMaterial, priority: int) -> MeshInstance3D:
	var mi = MeshInstance3D.new()
	var q  = QuadMesh.new()
	q.size = Vector2(2, 2)
	q.flip_faces = true
	mi.mesh = q
	mi.material_override = mat
	mi.cast_shadow = 0
	mi.extra_cull_margin = 10000.0
	mat.render_priority = priority
	return mi

func _load_and_apply():
	var cfg = ConfigFile.new()
	if cfg.load(FILE_PATH) != OK:
		_apply_all_uniforms()
		return
	apply_from_config(cfg)

func apply_from_config(cfg: ConfigFile):
	current_lut        = _get(cfg, "Dropdown", "lut_preset",    DEF_LUT)
	current_lut_int    = _get(cfg, "Float",    "lut_intensity", DEF_LUT_INT)
	current_exposure   = _get(cfg, "Float",    "exposure",      DEF_EXPOSURE)
	current_contrast   = _get(cfg, "Float",    "contrast",      DEF_CONTRAST)
	current_saturation = _get(cfg, "Float",    "saturation",    DEF_SATURATION)
	_apply_all_uniforms()

func _get(cfg: ConfigFile, section: String, key: String, default):
	var data = cfg.get_value(section, key, null)
	if data is Dictionary and data.has("value"):
		return data["value"]
	return default

func _apply_all_uniforms():
	_apply_lut(current_lut, current_lut_int)
	_apply_tonemap()

func _apply_lut(preset: String, intensity: float):
	if not tonemap_mat or not is_instance_valid(tm_mesh):
		return
	if preset == "Default":
		tm_mesh.visible = false
		return
	var path = LUT_PATHS.get(preset, "")
	if path == "":
		tm_mesh.visible = false
		return
	var img = Image.load_from_file(path)
	if img == null:
		push_error("[VisualZone] LUT not found: " + path)
		tm_mesh.visible = false
		return
	tonemap_mat.set_shader_parameter("lut_tex",        ImageTexture.create_from_image(img))
	tonemap_mat.set_shader_parameter("lut_intensity",  intensity)
	tm_mesh.visible = true
	print("[VisualZone] LUT applied: ", preset)

func _apply_tonemap():
	if not tonemap_mat:
		return
	tonemap_mat.set_shader_parameter("exposure",   current_exposure)
	tonemap_mat.set_shader_parameter("contrast",   current_contrast)
	tonemap_mat.set_shader_parameter("saturation", current_saturation)