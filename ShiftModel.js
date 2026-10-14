.pragma library

// Calendar-day arithmetic in UTC avoids daylight-saving jumps. Date keys
// still represent the user's local day, as they do in the parent calendar.
var DAY_MS = 86400000

function dayNumber(key) {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(String(key || ""))) return null
  var year = Number(key.substr(0, 4))
  var month = Number(key.substr(5, 2))
  var day = Number(key.substr(8, 2))
  var stamp = Date.UTC(year, month - 1, day)
  var check = new Date(stamp)
  if (check.getUTCFullYear() !== year || check.getUTCMonth() !== month - 1 || check.getUTCDate() !== day) return null
  return Math.floor(stamp / DAY_MS)
}

function keyFromNumber(number) {
  var date = new Date(number * DAY_MS)
  var month = date.getUTCMonth() + 1
  var day = date.getUTCDate()
  return date.getUTCFullYear() + "-" + (month < 10 ? "0" : "") + month + "-" + (day < 10 ? "0" : "") + day
}

function status(key, anchor, serviceDays, offDays, overrides) {
  var override = overrides && overrides[key]
  if (override === "service" || override === "off") return override
  var date = dayNumber(key)
  var first = dayNumber(anchor)
  var on = Number(serviceDays)
  var off = Number(offDays)
  if (date === null || first === null || !Number.isInteger(on) || !Number.isInteger(off) || on < 1 || off < 1)
    return "none"
  var period = on + off
  return ((date - first) % period + period) % period < on ? "service" : "off"
}

function nextService(fromKey, anchor, serviceDays, offDays, overrides) {
  var start = dayNumber(fromKey)
  var first = dayNumber(anchor)
  if (start === null) return ""
  var exceptions = overrides || {}
  if (first === null) {
    var extra = Object.keys(exceptions).filter(function(key) {
      return exceptions[key] === "service" && dayNumber(key) !== null && dayNumber(key) >= start
    }).sort()
    return extra.length ? extra[0] : ""
  }
  var period = Number(serviceDays) + Number(offDays)
  if (!Number.isInteger(period) || period < 2) return ""
  // Finite exceptions can suppress a finite number of complete cycles.
  var limit = period * (Object.keys(exceptions).length + 1)
  for (var i = 0; i <= limit; i++) {
    var key = keyFromNumber(start + i)
    if (status(key, anchor, serviceDays, offDays, exceptions) === "service") return key
  }
  return ""
}

function toggledOverrides(key, anchor, serviceDays, offDays, overrides) {
  var next = {}
  var stored = overrides || {}
  for (var saved in stored) next[saved] = stored[saved]
  if (next[key]) delete next[key]
  else next[key] = status(key, anchor, serviceDays, offDays, stored) === "service" ? "off" : "service"
  return next
}

if (typeof module !== "undefined") module.exports = {
  dayNumber: dayNumber,
  status: status,
  nextService: nextService,
  toggledOverrides: toggledOverrides
}
