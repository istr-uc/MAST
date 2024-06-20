-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-----------------------------------------------------------------------
with Glib; use Glib;
with Gtk; use Gtk;
with Gdk.Types;       use Gdk.Types;
with Gtk.Widget;      use Gtk.Widget;
with Gtk.Enums;       use Gtk.Enums;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_Gmast_Analysis; use Callbacks_Gmast_Analysis;
with Gmast_Analysis_Intl; use Gmast_Analysis_Intl;
with Error_Window_Pkg.Callbacks; use Error_Window_Pkg.Callbacks;

package body Error_Window_Pkg is

procedure Gtk_New (Error_Window : out Error_Window_Access) is
begin
   Error_Window := new Error_Window_Record;
   Error_Window_Pkg.Initialize (Error_Window);
end Gtk_New;

procedure Initialize (Error_Window : access Error_Window_Record'Class) is
   pragma Suppress (All_Checks);
begin
   Gtk.Window.Initialize (Error_Window, Window_TopLevel);
   Set_Title (Error_Window, -"Error");
   --Set_Policy (Error_Window, False, True, False);
   Set_Position (Error_Window, Win_Pos_None);
   Set_Modal (Error_Window, True);

   Gtk_New_Vbox (Error_Window.Vbox4, False, 1);
   Add (Error_Window, Error_Window.Vbox4);

   Gtk_New (Error_Window.Label_Error, -("Error"));
   Set_Alignment (Error_Window.Label_Error, 0.5, 0.5);
   Set_Padding (Error_Window.Label_Error, 47, 0);
   Set_Justify (Error_Window.Label_Error, Justify_Center);
   Set_Line_Wrap (Error_Window.Label_Error, False);
   Pack_Start (Error_Window.Vbox4, Error_Window.Label_Error, False, False, 33);

   Gtk_New
     (Error_Window.Alignment13, 0.5, 0.5, 0.11,
      0.11);
   Pack_Start
     (Error_Window.Vbox4,
      Error_Window.Alignment13,
      Expand  => False,
      Fill    => False,
      Padding => 1);
   Gtk_New_From_Stock (Error_Window.Button1, "gtk-ok");
   Set_Relief (Error_Window.Button1, Relief_Normal);
   Button_Callback.Connect
     (Error_Window.Button1, "clicked",
      Button_Callback.To_Marshaller (On_Button1_Clicked'Access), False);
   Add (Error_Window.Alignment13, Error_Window.Button1);

end Initialize;

end Error_Window_Pkg;
