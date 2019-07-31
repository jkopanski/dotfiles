Config
  { 
  -- appearance
    font =             "xft:Source Code Pro:size=16:antialias=true"
  , additionalFonts =   ["xft:Font Awesome:size=17"] 
  , bgColor =          "#2f2b33"
  --, fgColor =          "#A89984"
  , fgColor =          "#b2b2b2"
  , position =         Static { xpos = 0, ypos = 0, width = 1920, height = 26 }
  -- , textOffset =       20
  , alpha =            220
  , border =           BottomB
  , borderColor =      "#5d4d7a"

  -- layout
  , sepChar =  "%"   -- delineator between plugin names and straight text
  , alignSep = "}{"  -- separator between left-right alignment
  , template = "%StdinReader% }{ Gallium :: %battery% -> %kbd% -> %wlp58s0wi% -> %date% "

  -- general behavior
  , lowerOnStart =     True    -- send to bottom of window stack on start
  , hideOnStart =      False   -- start with window unmapped (hidden)
  , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
  , persistent =       False   -- enable/disable hiding (True = disabled)

  -- plugins
  --   Numbers can be automatically colored according to their value. xmobar
  --   decides color based on a three-tier/two-cutoff system, controlled by
  --   command options:
  --     --Low sets the low cutoff
  --     --High sets the high cutoff
  --
  --     --low sets the color below --Low cutoff
  --     --normal sets the color between --Low and --High cutoffs
  --     --High sets the color above --High cutoff
  --
  --   The --template option controls how the plugin is displayed. Text
  --   color can be set by enclosing in <fc></fc> tags. For more details
  --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.
  , commands = 
    -- stdin reader
    [ Run StdinReader 

    , Run Wireless "wlp58s0" [ "--template" , "<fn=1>\xf1eb</fn> <essid> [<qualitybar>]"
                            , "--nastring" , "Not Connected"
                            , "--bfore"    , "+" 
                            , "--bback"    , "-"
                            ] 15

    -- battery monitor
    , Run Battery        [ "--template" , "<fn=1>\xf240</fn> <acstatus>"
                          , "--Low"      , "10"        -- units: %
                          , "--High"     , "80"        -- units: %
                          , "--low"      , "#C7AE95"
                          , "--normal"   , "grey"
                          , "--high"     , "#95C7AE"

                          , "--" -- battery specific options
                                    -- discharging status
                                    , "-o", "<left>%"
                                    -- AC "on" status
                                    , "-O", "<fn=1>\xf0e7</fn> <left>%"
                                  -- charged status
                                    , "-i", "<fc=#006000>Charged</fc>"
                          ] 50

    -- time and date indicator
    --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
    , Run Date           "<fn=1>\xf073</fn> %F (%a) -> <fn=1>\xf017</fn> %T" "date" 10

    -- keyboard layout indicator
    , Run Kbd            [ ("pl"         , "<fn=1>\xf11c</fn> PL")
                         , ("us"         , "<fn=1>\xf11c</fn> US")
                         ]
    ]
}
