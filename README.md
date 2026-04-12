# C3Logger (colon3logger)

> A simple crossplatform **Luau** logger (**NO LUA**) that UwUifies your logs... or just keeps them normal, if you're *boring*.


# Main Features
## UwUifying
This has 4 levels.
* None - "Hello, world!" *boring*
* Default - "hewwo, wowld!" Kinda random application, randomly stutters for long words (`#word > 7 and math.random() < 0.1`) 
* Always - "h-hewwo, w-wowld!" Always applies, but only after vowels, always stutters for words longer than 2 (`#word > 2`) [SUBJECT TO CHANGE]
* Hyper - "h-hewwo, w-wowwd!" Always **always** applies, stuttering for EVERY word no matter length
## Log Levels
There are the basic log levels, being:
Trace - 0 `:trace()`
Debug - 1 `:debug()`
Info - 2 `:info()`
Danger - 3 `:warn() | :warnAssert() | :logAssert`
Always - `nolevel` `:print() :log()`

All levels below 2 are silencible, as well as :log().
## Formatting
blah blah

## RBX-ts
This comes with Roblox Typescript types, but.... you'll have to make a slight change to the Luau, instead of returning c3logger, return {default = c3logger}

## Simple Tips:

1. I reccomend you prefix like this: `{server}`, `<client>`, `(other)`... or just do what you want it's just a suggestion.
2. For colourful logging in **Lune**, you can use this (not bundled as this is cross runtime.)
  ```luau
  function writeColor(color: c3l.ansiStyle)
      stdio.write(myLogger.ANSI[color])
  end
-- This is preferred over stylenext as stylenext has the side effect of adding a space before and after your logging
  ```

## Example:
```
  {Rooms} initializing sewver roommanager...
  *Room1* initiawizing wogic for woom1
  *Room1* sewver loading logic for woom woom1
  {Rooms} toggwing door for woom1: fawse
  {Rooms} loaded woom wogic fow: woom1
  {Main} pwayer icedwuau joinyed the game.
  {Main} genyewating bawl c-character for pwayew: i-icedwuau
  {Main} bawl chawacter weady for playew: icedluau
  {Rooms} setting up pwogwess for pwayew: icedwuau
  {Rooms} syncing pwogwess to icedluau: active=room1
  <Character> character weady weceived. setting up camewa and contwows.
  <Character> camewa subject set to h-humanoidrootpart
  ```

## Addressing AI + Why was this made?
In my opinion, AI is a good tool. If we compare oats to AI (I do intend to offend oat lovers), and human made to Froot Loops (or any cereal of your choice), then, would you want to open a box of Froot Loops... to find oats? Would you rather get a box of oats and it have oats inside? Would you rather it say it has oats on the box? I do not want AI masquerading as human made code. This is why I made C3L. Spite. I can be CERTAIN this is human made. And, what about an unmarked box in the Froot Loop section, hmm? Perhaps that is even worse than oats in a Froot Loop box.
(Personally I'd rather AI to be disclosed or them LYING over just not disclosing it.)

### Ok, so, why?
UwUlogger. Seems like a great tool, it probably is, but, unmarked. AI? Human? Sure does scream AI. Use it if you want, I guess. But, c3l was made out of spite. That's why. But do go check it out, don't harrass the creator on the basis of "seems like it", or, like, don't do it at all, using AI is not a reason to do that. 
[UwULogger on DevForum](https://devforum.roblox.com/t/uwulogger-v110-intensity-levels-table-printing-and-a-logger-that-refuses-to-be-silenced/4465388/1)

<details>
<summary>AI Usage</summary>
  
<!-- markdown is hard i just use yaml ok? -->
```yaml
Code:
    - Structure: 0.001% AI (for log level names)
    - Stylizer: 90% AI (UwUifier and table deep cloner)
    - Other: 0% AI
ReadMe:
    - Writing: 0% AI
    - Structure: 0% AI
```
</details>
