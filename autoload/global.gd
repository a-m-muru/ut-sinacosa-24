extends Node

const STARS_PER_LEVEL := 1000

var remaining_stars := {}
var star_noise := FastNoiseLite.new()
var stars_vacuumed = 0
