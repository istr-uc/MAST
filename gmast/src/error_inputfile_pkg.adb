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
with Error_Inputfile_Pkg.Callbacks; use Error_Inputfile_Pkg.Callbacks;

package body Error_Inputfile_Pkg is

procedure Gtk_New (Error_Inputfile : out Error_Inputfile_Access) is
begin
   Error_Inputfile := new Error_Inputfile_Record;
   Error_Inputfile_Pkg.Initialize (Error_Inputfile);
end Gtk_New;

procedure Initialize (Error_Inputfile : access Error_Inputfile_Record'Class) is
   pragma Suppress (All_Checks);
begin
   Gtk.Window.Initialize (Error_Inputfile, Window_TopLevel);
   Set_Title (Error_Inputfile, -"Error");
   --Set_Policy (Error_Inputfile, False, True, False);
   Set_Position (Error_Inputfile, Win_Pos_None);
   Set_Modal (Error_Inputfile, True);

   Gtk_New_Vbox (Error_Inputfile.Vbox6, False, 0);
   Add (Error_Inputfile, Error_Inputfile.Vbox6);

   Gtk_New (Error_Inputfile.Label13, -("Empty Input File"));
   Set_Alignment (Error_Inputfile.Label13, 0.5, 0.5);
   Set_Padding (Error_Inputfile.Label13, 47, 0);
   Set_Justify (Error_Inputfile.Label13, Justify_Center);
   Set_Line_Wrap (Error_Inputfile.Label13, False);
   Pack_Start (Error_Inputfile.Vbox6, Error_Inputfile.Label13, False, False, 33);

   Gtk_New
     (Error_Inputfile.Alignment14, 0.5, 0.5, 0.25,
      0.25);
   Pack_Start
     (Error_Inputfile.Vbox6,
      Error_Inputfile.Alignment14,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New_From_Stock (Error_Inputfile.Button_Ok, "gtk-ok");
   Set_Border_Width (Error_Inputfile.Button_Ok, 2);
   Set_Relief (Error_Inputfile.Button_Ok, Relief_Normal);
   Button_Callback.Connect
     (Error_Inputfile.Button_Ok, "clicked",
      Button_Callback.To_Marshaller (On_Button_Ok_Clicked'Access), False);
   Add (Error_Inputfile.Alignment14, Error_Inputfile.Button_Ok);

end Initialize;

end Error_Inputfile_Pkg;
