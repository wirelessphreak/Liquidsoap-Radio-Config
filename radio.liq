#!/usr/bin/liquidsoap
# Log dir
#log.file.path.set("/tmp/basic-radio.log")
settings.init.allow_root.set(true)
# Music
library1 = playlist("/storage/music/Library1")
library2 = playlist("/storage/music/Library2")
library3 = playlist("/storage/music/Library3")
# Some jingles
jingles = playlist("/storage/music/Jingles")
# If something goes wrong, we'll play this
security = single("/storage/music/saftey.ogg")

# Start building the feed with music
radio = switch([
  ({ 0h-6h }, library1),
  ({ 6h-12h }, library2),
  ({ 12h-24h }, library3)
])
# Now add some jingles
radio = rotate(weights = [1, 10],[jingles, radio])
# Add Smart Crossfade
radio = crossfade(radio, smart=true)

# And finally the security
radio = fallback(track_sensitive = false, [radio, security])

# Stream it out
output.icecast(%vorbis,
  host = "127.0.0.1", port = 8000,
  password = "hackme", mount = "stream.ogg",
  name = "Station Name",
  genre = "Genre",
  timeout = 10.0,
  url = "Yourstation.com",
  description = "Clever catch phrase",
  radio)