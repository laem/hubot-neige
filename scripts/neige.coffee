# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md


neigeUrl = "http://www.myweather2.com/developer/weather.ashx?uac=7fcYm4FvK/&output=json&uref=b10a3eb6-d28a-4194-b01a-36c07dbd5d2f"

module.exports = (robot) ->

   annoyIntervalId = null

   robot.respond /active les alertes neige/, (msg) ->
     if annoyIntervalId
       msg.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
       return

     msg.send "Excellent !"
     annoyIntervalId = setInterval () ->
       robot.http(neigeUrl)
        .header('Accept', 'application/json')
        .get() (err, res, body) ->
          data = JSON.parse(body)
          msg.send "#{data.weather.snow_report.conditions}"
     , 1000

   robot.respond /désactive les alertes neige/, (msg) ->
     if annoyIntervalId
       msg.send "OK, ça va..."
       clearInterval(annoyIntervalId)
       annoyIntervalId = null
     else
       msg.send "Impossible, les alertes ne sont pas activées"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, msg) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if msg?
  #     msg.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (msg) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     msg.reply "I'm too fizzy.."
  #
  #   else
  #     msg.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (msg) ->
  #   robot.brain.set 'totalSodas', 0
  #   robot.respond 'zzzzz'
