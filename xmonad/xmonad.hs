import XMonad
import XMonad.Hooks.DynamicLog     (dynamicLog)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog     (PP (..), xmobarColor, xmobarPP, statusBar, wrap)
import XMonad.Layout.NoBorders     (smartBorders)
import XMonad.Layout.Spacing       (smartSpacing)
import XMonad.Util.NamedScratchpad ( NamedScratchpad (..)
                                   , customFloating
                                   , namedScratchpadAction
                                   , namedScratchpadManageHook
                                   )
import XMonad.Util.SpawnOnce       (spawnOnce)

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import Colors

homeDir = "/home/nat"

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
myTerminal      = "urxvt"

-- Width of the window border in pixels.
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
myWorkspaces    = [ "1: <fn=1>\xf0ac</fn>"
                  , "2: <fn=1>\xf120</fn>"
                  , "3: <fn=1>\xf121</fn>"
                  , "4: <fn=1>\xf108</fn>"
                  , "5: <fn=1>\xf108</fn>"
                  , "6: <fn=1>\xf108</fn>"
                  , "7: <fn=1>\xf001</fn>"
                  , "8: <fn=1>\xf04b</fn>"
                  , "9: <fn=1>\xf1d1</fn>"
                  , "10: <fn=1>\xf1d1</fn>"
                  ]
-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = cblkBg
myFocusedBorderColor = border

-- Named Scratchpads
-- Semi full screen windows with often used programs
-- keybase
-- ncpamixer
-- terminal
myScratchpads   = [ NS "keybase"
                       "keybase-gui" (className =? "Keybase")
                       (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
                  , NS "term"
                       "urxvt -title termscratch"
                       (title =? "termscratch")
                       (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
                  , NS "mixer"
                       "urxvt -title mixer -e ncpamixer"
                       (title =? "mixer")
                       (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
                  , NS "hoogle"
                       "urxvt -title hoogle -e bhoogle"
                       (title =? "hoogle")
                       (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
                  , NS "weechat"
                       "urxvt -title weechat -e weechat"
                       ((title =? "WeeChat 2.0") <||> (title =? "weechat"))
                       (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
                  ]

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
myKeys conf@(XConfig {modMask = modm}) = M.fromList $
  -- launch a terminal
  [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)
  -- launch dmenu
  , ((modm,               xK_p     ), spawn "zsh -c \"rofi -show run\"")
  -- launch qutebrowser
  , ((modm,               xK_q     ), spawn "qutebrowser --backend webengine")
  -- close focused window
  , ((modm .|. shiftMask, xK_c     ), kill)
  -- Rotate through the available layout algorithms
  , ((modm,               xK_space ), sendMessage NextLayout)
  --  Reset the layouts on the current workspace to default
  , ((modm .|. shiftMask, xK_space ), setLayout $ layoutHook conf)
  -- Resize viewed windows to the correct size
  , ((modm,               xK_n     ), refresh)
  -- Move focus to the next window
  , ((modm,               xK_Tab   ), windows W.focusDown)
  -- Move focus to the next window
  , ((modm,               xK_h     ), windows W.focusDown)
  -- Move focus to the previous window
  , ((modm,               xK_t     ), windows W.focusUp  )
  -- Move focus to the master window
  , ((modm,               xK_m     ), windows W.focusMaster  )
  -- Swap the focused window and the master window
  -- , ((modm,               xK_Return), windows W.swapMaster)
  -- Swap the focused window with the next window
  , ((modm,               xK_d     ), windows W.swapDown  )
  -- Swap the focused window with the previous window
  , ((modm,               xK_n     ), windows W.swapUp    )
  -- Shrink the master area
  , ((modm,               xK_c     ), sendMessage Shrink)
  -- Expand the master area
  , ((modm,               xK_g     ), sendMessage Expand)
  -- Push window back into tiling
  , ((modm,               xK_f     ), withFocused $ windows . W.sink)
  -- Increment the number of windows in the master area
  , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
  -- Deincrement the number of windows in the master area
  , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
  -- Toggle the status bar gap
  -- Use this binding with avoidStruts from Hooks.ManageDocks.
  -- See also the statusBar function from Hooks.DynamicLog.
  --
  -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
  -- Quit xmonad
  -- , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
  -- Restart xmonad
  -- , ((modm              , xK_r     ), spawn "xmonad --recompile; xmonad --restart")
  -- Show terminal
  , ((noModMask         , xK_F12   ), namedScratchpadAction myScratchpads "term")
  , ((modm .|. shiftMask, xK_m     ), namedScratchpadAction myScratchpads "mixer")
  , ((modm              , xK_u     ), namedScratchpadAction myScratchpads "keybase")
  , ((modm .|. shiftMask, xK_h     ), namedScratchpadAction myScratchpads "hoogle")
  , ((modm              , xK_i     ), namedScratchpadAction myScratchpads "weechat")
  ]
  ++
  --
  -- [F1..F10], Switch to workspace N
  -- shift-[F1..F10], Move client to workspace N
  --
  [((m .|. noModMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F10]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
  --
  -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
  --
  [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
myMouseBindings (XConfig {modMask = modm}) = M.fromList $
  -- mod-button1, Set the window to floating mode and move by dragging
  [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                      >> windows W.shiftMaster))
  -- mod-button2, Raise the window to the top of the stack
  , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
  -- mod-button3, Set the window to floating mode and resize by dragging
  , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                      >> windows W.shiftMaster))
  -- you may also bind events to the mouse scroll wheel (button4 and button5)
  ]

------------------------------------------------------------------------
-- Layouts:
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
myLayout = smartBorders tiled ||| smartBorders Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = smartSpacing 12 $ Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

------------------------------------------------------------------------
-- Window rules:
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
myManageHook = composeAll
  [ className =? "mpv"            --> doShift "8: <fn=1>\xf04b</fn>"
  , className =? "MPlayer"        --> doFloat
  , className =? "Gimp"           --> doFloat
  , resource  =? "desktop_window" --> doIgnore
  , namedScratchpadManageHook myScratchpads
  ]

------------------------------------------------------------------------
-- Event handling
-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = dynamicLog

------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook :: X ()
myStartupHook = spawnOnce ("feh --bg-scale -z " ++ homeDir ++ "/wallpapers.d")

conf = def
  { borderWidth        = myBorderWidth
  , clickJustFocuses   = False
  , focusedBorderColor = myFocusedBorderColor
  , focusFollowsMouse  = True
  , handleEventHook    = myEventHook
  , keys               = myKeys
  , layoutHook         = myLayout
  , logHook            = myLogHook
  , manageHook         = myManageHook
  , modMask            = myModMask
  , normalBorderColor  = myNormalBorderColor
  , startupHook        = myStartupHook
  , terminal           = myTerminal
  , workspaces         = myWorkspaces
  }

myXmobar :: String
myXmobar = "xmobar ~/.xmonad/xmobar.hs"

myXmobarPP :: PP
myXmobarPP = xmobarPP
  { ppCurrent = xmobarColor keyword "" . wrap " " ""
  , ppHidden  = xmobarColor var "" . wrap " " ""
  , ppTitle   = \str -> ""
  , ppLayout  = \str -> ""
  }

toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
toggleStrutsKey XConfig{modMask = modm} = (modm, xK_b )

main = xmonad =<< statusBar myXmobar myXmobarPP toggleStrutsKey conf
