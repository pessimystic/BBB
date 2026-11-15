extends Node2D
## Night city background. Drawn once (static), so it costs almost nothing.

const W := 480


func _draw() -> void:
	var bands := ["#0e1030", "#151a44", "#1d2358", "#2a2f6e", "#3b3a80", "#54478f"]
	for i in bands.size():
		draw_rect(Rect2(0, i * 40, W, 41), Color(bands[i]))
	for i in 60:
		var s := 1 if i % 5 != 0 else 2
		draw_rect(Rect2((i * 97) % W, (i * 53) % 150, s, s), Color.WHITE if i % 4 == 0 else Color("#8a93d6"))
	draw_circle(Vector2(400, 52), 20, Color("#f4f0d0"))
	draw_circle(Vector2(392, 46), 4, Color("#d9d4aa"))
	draw_circle(Vector2(406, 58), 3, Color("#d9d4aa"))
	draw_circle(Vector2(398, 63), 2, Color("#d9d4aa"))
	for c in [Vector3(60, 70, 60), Vector3(220, 40, 80), Vector3(320, 95, 50)]:
		draw_rect(Rect2(c.x, c.y, c.z, 5), Color(0.47, 0.43, 0.75, 0.35))
		draw_rect(Rect2(c.x + 8, c.y - 4, c.z - 20, 4), Color(0.47, 0.43, 0.75, 0.35))
	var x := 0
	while x < W:
		var w := 18 + (x * 7) % 22
		var h := 50 + (x * 13) % 60
		draw_rect(Rect2(x, 226 - h, w, h + 20), Color("#262b5c"))
		x += w + 2
	x = 0
	while x < W:
		var w := 24 + (x * 11) % 26
		var h := 40 + (x * 17) % 70
		draw_rect(Rect2(x, 246 - h, w, h), Color("#181c42"))
		var wy := 246 - h + 6
		while wy < 238:
			var wx := x + 4
			while wx < x + w - 4:
				if (wx * 31 + wy * 17) % 7 < 3:
					draw_rect(Rect2(wx, wy, 3, 4), Color("#d9b24f") if (wx + wy) % 3 != 0 else Color("#5fb3d0"))
				wx += 7
			wy += 9
		x += w + 4
