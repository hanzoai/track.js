import { Track } from 'track.js'

# Save reference to stub analytics
stub = window.track ? []

# Create new analytics instance to replace stub
window.track = new Track {}

# Loop through stub calls and replay them
while stub.length > 0
  event = stub.shift()
  method = event.shift()
  if track[method]?
    track[method].apply track, event

# track some event
track 'foo', a: 1, b: 2

# track this page
track.page()
