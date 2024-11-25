/* See LICENSE file for copyright and license details. */
#include <X11/Xlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

#include "../util.h"

/*
 * fmt consists of uppercase or lowercase 'c' for caps lock and/or 'n' for num
 * lock, each optionally followed by '?', in the order of indicators desired.
 * If followed by '?', the letter with case preserved is included in the output
 * if the corresponding indicator is on.  Otherwise, the letter is always
 * included, lowercase when off and uppercase when on.
 */
#include <X11/XKBlib.h>

const char *keyboard_indicators(const char *arg) {
  static char output[17];
  Display *dpy = XOpenDisplay(NULL);
  if (!dpy) {
    return "No X";
  }

  XKeyboardState state;
  XGetKeyboardControl(dpy, &state);

  snprintf(output, sizeof(output), "Caps:%s Num:%s",
           (state.led_mask & 1) ? "ON" : "OFF",
           (state.led_mask & 2) ? "ON" : "OFF");

  XCloseDisplay(dpy);
  return output;
}
