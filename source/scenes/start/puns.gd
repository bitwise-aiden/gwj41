extends Label


# Private constants

const __PUNS: Array = [
	"Let's Git Kraken!",
	"Have a Kraken time",
	"I can hear his heart Kraken from here",
	"I ship it",
	"This pun is shore to get a laugh",
	"Don't want to cause a commocean",
	"Water you waiting for let's go!",
	"This game is Cray-Sea",
	"I would tell you how to win,\nbut it's a sea-cret",
	"Is that Ryan Sea Crest?",
	"It's a hug emergensea!",
	"Hugs from the deep, a Kraken good tale",
	"The Huggening: Hugs so good they Kraken your back",
	"Don't go kraken my heart",
	"Please stop, you're krilling me!",
	"Phil McKraken",
]


# Private variables

var __lower: bool = false
var __timer: Timer = Timer.new()


# Lifecycle methods

func _ready() -> void:
	text = "The Huggening:\nHugs so good they Kraken your back"# __PUNS[randi() % __PUNS.size()]

	add_child(__timer)
	__timer.wait_time = 0.2
	__timer.connect("timeout", self, "__toggle_text")
	__timer.start()


# Private methods

func __toggle_text() -> void:
	if __lower:
		text = text.to_upper()
	else:
		text = text.to_lower()

	__lower = !__lower
