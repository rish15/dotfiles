#!/usr/bin/env python3
"""Desktop widget: big clock, date and a month calendar on the wallpaper.

Sits on the layer below normal windows, so it shows on empty workspaces and
during desktop peek (Super+D). Catppuccin Mocha. Needs python-gobject, gtk3,
gtk-layer-shell.
"""
import datetime

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import GLib, Gtk, GtkLayerShell  # noqa: E402

CSS = b"""
window { background: transparent; }
.card {
    background: alpha(#1e1e2e, 0.72);
    border: 1px solid alpha(#45475a, 0.9);
    border-radius: 22px;
    padding: 22px 26px;
}
.time  { font-family: "JetBrainsMono Nerd Font"; font-size: 64px; font-weight: 800; color: #cdd6f4; }
.date  { font-family: "JetBrainsMono Nerd Font"; font-size: 17px; color: #cba6f7; margin-bottom: 14px; }
calendar {
    font-family: "JetBrainsMono Nerd Font"; font-size: 13px;
    background: transparent; color: #cdd6f4; border: none; padding: 4px;
}
calendar.header { background: transparent; border: none; color: #b4befe; }
calendar.button { color: #b4befe; background: transparent; border: none; box-shadow: none; }
calendar.button:hover { color: #f5c2e7; }
calendar:selected { background: #cba6f7; color: #11111b; border-radius: 8px; }
calendar.highlight { color: #fab387; font-weight: bold; }
calendar:indeterminate { color: #585b70; }
"""


class DesktopWidget(Gtk.Window):
    def __init__(self):
        super().__init__(title="desktop-widget")
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_namespace(self, "desktop-widget")
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.BOTTOM)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.NONE)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, 72)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, 48)

        provider = Gtk.CssProvider()
        provider.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            self.get_screen(), provider, Gtk.STYLE_PROVIDER_PRIORITY_USER
        )

        card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        card.get_style_context().add_class("card")
        self.time = Gtk.Label(xalign=0)
        self.time.get_style_context().add_class("time")
        self.date = Gtk.Label(xalign=0)
        self.date.get_style_context().add_class("date")
        self.calendar = Gtk.Calendar()
        self.calendar.set_display_options(
            Gtk.CalendarDisplayOptions.SHOW_HEADING
            | Gtk.CalendarDisplayOptions.SHOW_DAY_NAMES
            | Gtk.CalendarDisplayOptions.SHOW_WEEK_NUMBERS
        )
        for w in (self.time, self.date, self.calendar):
            card.pack_start(w, False, False, 0)
        self.add(card)

        self.today = None
        self.tick()
        GLib.timeout_add_seconds(1, self.tick)

    def tick(self):
        now = datetime.datetime.now()
        self.time.set_text(now.strftime("%H:%M"))
        self.date.set_text(now.strftime("%A, %d %B %Y"))
        if self.today != now.date():          # new day: move the calendar to today
            self.today = now.date()
            self.calendar.select_month(now.month - 1, now.year)
            self.calendar.select_day(now.day)
        return True


if __name__ == "__main__":
    win = DesktopWidget()
    win.connect("destroy", Gtk.main_quit)
    win.show_all()
    Gtk.main()
