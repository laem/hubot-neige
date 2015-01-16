# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md


neigeUrl = "http://clientservice.onthesnow.com/externalservice/resort/2212/snowreport?token=a5bae8eea465aae810130937a29cebaa6cd92ce60336d8e3&language=fr&country=FR"

module.exports = (robot) ->

   annoyIntervalId = null

   robot.respond /neige/, (msg) ->

     robot.http(neigeUrl)
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse(body)
        fall = data.report.snowfall.snow24h

        msg.send "*** Bulletin pour la Rosière ***"
        if fall
          msg.send "Elle a tombé : #{fall} cm de neige hier"

        onSlope = data.report.snowQuality.onSlope
        msg.send "En bas: #{onSlope.surfaceBottom}, #{onSlope.lowerDepth} cm"
        msg.send "En haut: #{onSlope.surfaceTop}, #{onSlope.upperDepth} cm"
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
