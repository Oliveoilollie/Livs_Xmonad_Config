-- livs xmonad config, make sure you have the proper programs
-- this config is was based on the haskell darks config http://code.haskell.org/xmonad/man/xmonad.hs.
--
--
-- thanks to distrotube for making this all easy
--
-- im so sorry for those that read this config. you will all cry
--
import XMonad
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- modules ive added
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import Graphics.X11.ExtraTypes.XF86
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.ClickableWorkspaces
import qualified XMonad.Util.Hacks as Hacks
import XMonad.Util.SpawnOnce

-- TODO: 
-- 1. clickable panel. xmobar by defualt doesnt do this
-- 2. conky with shortcut info
-- 3. script that shows what music is playing
-- 4. easy to use application or Dmenu script to run .desktop files
-- 5. fix how the panel is hiding

myTerminal      = "alacritty"
myEditor        = "emacsclient -c -a 'emacs' "
myBrowser       = "librewolf-bin"
myScreenShot    = "scrot -s -e 'xclip -selection clipboard -t image/png < $f'"
-- myEditor      = myTerminal ++ "nvim "
-- myScreenShot  = "flameshot-gui"
myFiles         = "pcmanfm"
myAudio         = "mpv"
myWallpaper     = "~/.xmonad/jeez.png"
myStartSound    = "~/.xmonad/sounds/sound.webm"

-- color Scheme
-- TODO: find a color scheme i like

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- import XMonad.Hooks.WindowSwallowing
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = [" www "," othr "," term "," chat "," emacs "," gmr "," vbox "," mus "," etc "]

-- myWorkspaces    = ["www","chat","emacs","term","files","music","top","mail","games"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#1D1616"
myFocusedBorderColor = "#8e1616"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")


    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
     , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    -- volume shits
    , ((0,               xF86XK_AudioRaiseVolume     ), spawn "amixer set Master 10%+")
    , ((0,               xF86XK_AudioLowerVolume     ), spawn "amixer set Master 10%-")
    , ((0,               xF86XK_AudioMute     ), spawn "amixer set Master toggle")
    , ((0,               xF86XK_AudioPlay     ), spawn "playerctl play-pause")
    
    -- because my keyboard is so fucking weird
    , ((modm .|. shiftMask,               xF86XK_AudioPlay     ), spawn "playerctl next")
    , ((modm .|. controlMask,               xF86XK_AudioPlay     ), spawn "playerctl previous")
    
    -- seek through shit
    , ((modm .|. controlMask,               xF86XK_AudioRaiseVolume     ), spawn "playerctl position +10")
    , ((modm .|. controlMask,               xF86XK_AudioLowerVolume     ), spawn "playerctl position 10-")

    --common shits i use lmfao
    , ((modm .|. shiftMask, xK_s     ), spawn myScreenShot)
    , ((modm .|. shiftMask, xK_x     ), spawn "xkill")
    , ((modm .|. shiftMask, xK_v     ), spawn "vesktop-bin")
    , ((modm .|. shiftMask, xK_f     ), spawn myFiles)
    , ((modm .|. shiftMask, xK_t     ), spawn "xterm")
    , ((modm .|. shiftMask, xK_g     ), spawn "steam")
    , ((modm .|. shiftMask, xK_d     ), spawn "dmenu_run_desktop")
    , ((modm .|. shiftMask, xK_b     ), spawn myBrowser)
    , ((modm .|. controlMask, xK_e     ), spawn myEditor)
    , ((modm .|. controlMask, xK_e     ), spawn myEditor)

    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
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
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

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
--
myLayout = avoidStruts $ smartBorders $ smartSpacing 8 $ fullscreenFull $ (tiled ||| Mirror tiled ||| noBorders Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

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
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "mpv"            --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    -- because im a unoranised fuck and i need my window manager to oranise shit for me
    , title =? "Mozilla Firefox"             --> doShift ( myWorkspaces !! 0 )
    , title =? "LibreWolf"                   --> doShift ( myWorkspaces !! 0 ) 
    , title =? "New Tab - Chromium"          --> doShift ( myWorkspaces !! 0 ) 
    , title =? "Alacritty"                   --> doShift ( myWorkspaces !! 2 ) 
    , title =? "Vesktop"                     --> doShift ( myWorkspaces !! 3 ) 
    , title =? "Steam"                       --> doShift ( myWorkspaces !! 5 ) 
    , title =? "GNU Emacs"                   --> doShift ( myWorkspaces !! 1 ) 
    , title =? "xterm"                       --> doShift ( myWorkspaces !! 2 ) 
    , title =? "Spotify"                     --> doShift ( myWorkspaces !! 7 ) 
    , title =? "Virtual Machine Manager"     --> doShift ( myWorkspaces !! 6 ) ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook (this is old shit. not really used today like this. and its already setup bitch)
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.

-- this has been changed completly from the example, thanks chatgpt you are the best

myEventHook :: Event -> X All
myEventHook = mempty
    <+> swallowEventHook (className =? "st-256color" <||> className =? "Alacritty" <||> className =? "Xterm" ) (return True)
    <+> Hacks.trayerPaddingXmobarEventHook


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hookimport qualified XMonad.Util.Hacks as Hacks

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = startup
startup :: X ()
startup = do
         -- play my startup sound for fun TODO: work on this dumbass
         --kill all the old processes
         spawn "killall mpd"
         spawn "killall dunst"
         spawn "killall emacs"
         spawn "killall trayer-srg"
         --start new ones
         spawnOnce "picom &"
         spawnOnce "xwallpaper --zoom ~/.xmonad/jeez.png"
         spawnOnce "dunst &"
         spawnOnce "mpd &"
         spawn "openrgb --profile red.orp &"
         -- TODO: get a emacs config
         spawnOnce "emacs --daemon &"
         spawn "/usr/libexec/polkit-mate-authentication-agent-1 &"
         spawn "trayer-srg --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --height 17 --tint 0x1D1616 --margin 2 &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
myPP = def { ppCurrent = xmobarColor "#1D1616" "#D84040"
, ppHiddenNoWindows = xmobarColor "#D84040" "#1D1616"
}

mySB = statusBarProp "xmobar" (clickablePP myPP)

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
      -- actual way to start up xmobar so it can have my workspaces
      mySB <- statusBarPipe "xmobar ~/.xmonad/xmobar/xmobarrc -x 0" (pure myPP)

      -- this was the way that made me wanna cuss, dont uncomment this out,
      --xmproc <- spawnPipe "/home/liv/.local/bin/xmobar -x 0 1 /home/liv/.xmonad/xmobar/xmobarrc"
      xmonad . withEasySB mySB defToggleStrutsKey $ fullscreenSupportBorder $ docks $ ewmhFullscreen $ ewmh $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format. TODO: work on updating this with my keybindings!
help :: String
help = unlines ["The default modifier key is 'super', or what the supid winders people say THE WINDOWS KEY Default keybindings, i expect you to fucking read the config idiot:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch alacritty",
    "mod-p            Launch dmenu, literally the gods of run programs",
    "mod-Shift-p      Launch gmrun, who uses this",
    "mod-Shift-c      Close/kill the focused window, naw just use Xkill",
    "mod-Shift-x      runs Xkill.",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
