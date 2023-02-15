#!/usr/bin/liquidsoap
# Log dir
#log.file.path.set("/tmp/basic-radio.log")
settings.init.allow_root.set(true)

# Define the location of your Music files
library1 = playlist("/storage/music/Library1")
library2 = playlist("/storage/music/Library2")
library3 = playlist("/storage/music/Library3")

# Define the location of your jingles
jingles = playlist("/storage/music/Jingles")

# If something goes wrong, we'll play this
security = single("/storage/music/saftey.ogg")

# Start building your music stream, this is set to time of day
radio = switch([
  ({ 0h-6h }, library1),
  ({ 6h-12h }, library2),
  ({ 12h-24h }, library3)
])

# Now integrate your jingles
radio = rotate(weights = [1, 10],[jingles, radio])

# Add Smart Crossfade
radio = crossfade(radio, smart=true)

# And finally set your security fallback
radio = fallback(track_sensitive = false, [radio, security])

# Stream to icecast
output.icecast(%vorbis,
  host = "127.0.0.1", port = 8000,
  password = "hackme", mount = "stream.ogg",
  name = "Station Name",
  genre = "Genre",
  timeout = 10.0,
  url = "Yourstation.com",
  description = "Clever catch phrase",
  radio)
