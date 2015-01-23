# Description
#   Get a succinct snow report for the ski resort of your choice
#   Works with France and US resorts
#
# Dependencies:
#   "cheerio": "*"
#   "fuzzy": "*"
#
# Configuration:
#   None
#
# Commands:
#   hubot neige [French resort name]
#   hubot snow  [US resort name]
#
# Notes:
#   Other countries could be implemented quickly !
#
# Author:
#   laem

cheerio = require('cheerio')
fuzzy = require('fuzzy')

i18n = {
    'neige': {
      url : 'http://www.skiinfo.fr/france/bulletin-neige.html',
      intro: (name) -> '*** Bulletin pour ' + name + ' ***',
      state: (state) -> 'Enneigement bas - haut : ' + state,
      fall: (snowFall24h) -> 'Elle a tombé : ' + snowFall24h + ' de neige hier'
    },
    'snow': {
      url: 'http://www.onthesnow.com/united-states/skireport.html',
      intro: (name) -> '*** Snow report for ' + name + ' ***',
      state: (state) -> 'Snow report down - up : ' + state,
      fall: (snowFall24h) -> 'Snowfall !! : ' + snowFall24h + ' of snow yesterday'
    }
}

# Would be handy to have a free token for this API :
# "http://clientservice.onthesnow.com/externalservice/resort/2212/snowreport?token=a5bae8eea465aae810130937a29cebaa6cd92ce60336d8e3&language=fr&country=FR"

module.exports = (robot) ->

  robot.respond /neige (.*)/i, (msg) ->
     inform(robot, msg, 'neige', msg.match[1])

  robot.respond /snow (.*)/i, (msg) ->
    inform(robot, msg, 'snow', msg.match[1])


inform = (robot, msg, keyword, resortQuery) ->

  lang = i18n[keyword]
  robot.http(lang.url)
   .get() (err, res, body) ->
     $ = cheerio.load(body)

     messages = []

     names =
       $('.resortList .name a').map (i, el) ->
         $(this).attr('title')

     candidates = fuzzy.filter(resortQuery, names.get())
     candidate = candidates[0].string

     row = $('.resortList tr').filter (i, el) ->
         $(this).find('.name a').attr('title') == candidate

     name = $(row).find('.name a').attr('title')

     messages.push lang.intro(name)

     state = $(row).find('.rMid.c b').text()

     messages.push lang.state(state)

     snowFallElements = $(row).find('.rLeft.b b')
     snowFall = ($(el).text() for el in snowFallElements)

     snowFall24h = snowFall[0]
     snowFall72h = snowFall[1]

     unless snowFall24h.match(/\d+/)[0] == 0
       messages.push lang.fall(snowFall24h)

     delay = (s, i) ->
       setTimeout () ->
         msg.send s
       , 100 * i

     for s, i in messages
       delay s, i
