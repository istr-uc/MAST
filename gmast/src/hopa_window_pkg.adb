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
with Glib.Unicode; use Glib.Unicode;
with Gtk; use Gtk;
with Gdk.Types;       use Gdk.Types;
with Gtk.Widget;      use Gtk.Widget;
with Gtk.Enums;       use Gtk.Enums;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_Gmast_Analysis; use Callbacks_Gmast_Analysis;
with Gmast_Analysis_Intl; use Gmast_Analysis_Intl;
with Hopa_Window_Pkg.Callbacks; use Hopa_Window_Pkg.Callbacks;
with Mast.Hospa_Parameters;

package body Hopa_Window_Pkg is

procedure Gtk_New (Hopa_Window : out Hopa_Window_Access) is
begin
   Hopa_Window := new Hopa_Window_Record;
   Hopa_Window_Pkg.Initialize (Hopa_Window);
end Gtk_New;

procedure Initialize (Hopa_Window : access Hopa_Window_Record'Class) is
   pragma Suppress (All_Checks);
begin
   Gtk.Window.Initialize (Hopa_Window, Window_TopLevel);
   Set_Title (Hopa_Window, -"HOSPA Parameters");
   Set_Position (Hopa_Window, Win_Pos_Mouse);
   Set_Modal (Hopa_Window, True);

   Gtk_New_Vbox (Hopa_Window.Vbox9, False, 0);
   Add (Hopa_Window, Hopa_Window.Vbox9);

   Gtk_New (Hopa_Window.Label27, -("HOSPA Parameters"));
   Set_Alignment (Hopa_Window.Label27, 0.5, 0.5);
   Set_Padding (Hopa_Window.Label27, 0, 0);
   Set_Justify (Hopa_Window.Label27, Justify_Center);
   Set_Line_Wrap (Hopa_Window.Label27, False);
   Pack_Start (Hopa_Window.Vbox9, Hopa_Window.Label27, True, True, 5);

   Gtk_New (Hopa_Window.Frame3);
   Set_Border_Width (Hopa_Window.Frame3, 15);
   Set_Shadow_Type (Hopa_Window.Frame3, Shadow_Etched_In);
   Pack_Start (Hopa_Window.Vbox9, Hopa_Window.Frame3, True, True, 0);

   Gtk_New (Hopa_Window.Table4, 5, 2, False);
   Set_Row_Spacings (Hopa_Window.Table4, 0);
   Set_Col_Spacings (Hopa_Window.Table4, 0);
   Add (Hopa_Window.Frame3, Hopa_Window.Table4);

   Gtk_New_With_Entry(Hopa_Window.Initial_Assignment_Combo);
   for Initial in Mast.Hospa_Parameters.Valid_Initial_Assignments loop
      Append_Text(Hopa_Window.Initial_Assignment_Combo,
                  Mast.Hospa_Parameters.
                    Valid_Initial_Assignments'Image(Initial));
   end loop;
   Attach (Hopa_Window.Table4, Hopa_Window.Initial_Assignment_Combo, 1, 2, 0, 1,
     Expand or Fill, 0,
     0, 0);

   Gtk_New
     (Hopa_Window.Alignment_Initial, 1.0, 0.5, 0.95,
      0.95);
   Attach (Hopa_Window.Table4, Hopa_Window.Alignment_Initial, 0, 1, 0, 1,
     Fill, Expand or Fill,
     0, 0);

   Gtk_New (Hopa_Window.Label_Initial, -("Initial_Assignment"));
   Set_Alignment (Hopa_Window.Label_Initial, 1.0, 0.5);
   Set_Padding (Hopa_Window.Label_Initial, 5, 0);
   Set_Justify (Hopa_Window.Label_Initial, Justify_Right);
   Set_Line_Wrap (Hopa_Window.Label_Initial, False);
   Add (Hopa_Window.Alignment_Initial, Hopa_Window.Label_Initial);


   Gtk_New (Hopa_Window.Ka_Entry);
   Set_Editable (Hopa_Window.Ka_Entry, True);
   Set_Max_Length (Hopa_Window.Ka_Entry, 0);
   Set_Text (Hopa_Window.Ka_Entry, -"");
   Set_Visibility (Hopa_Window.Ka_Entry, True);
   Attach (Hopa_Window.Table4, Hopa_Window.Ka_Entry, 1, 2, 1, 2,
     Expand or Fill, 0,
     0, 0);

   Gtk_New (Hopa_Window.Kr_Entry);
   Set_Editable (Hopa_Window.Kr_Entry, True);
   Set_Max_Length (Hopa_Window.Kr_Entry, 0);
   Set_Text (Hopa_Window.Kr_Entry, -"");
   Set_Visibility (Hopa_Window.Kr_Entry, True);
   Attach (Hopa_Window.Table4, Hopa_Window.Kr_Entry, 1, 2, 2, 3,
     Expand or Fill, 0,
     0, 0);

   Gtk_New
     (Hopa_Window.Alignment6, 1.0, 0.5, 1.0,
      1.0);
   Attach (Hopa_Window.Table4, Hopa_Window.Alignment6, 0, 1, 1, 2,
     Fill, Fill,
     0, 0);

   Gtk_New
     (Hopa_Window.Alignment10, 1.0, 0.5, 1.0,
      1.0);
   Add (Hopa_Window.Alignment6, Hopa_Window.Alignment10);

   Gtk_New (Hopa_Window.Label30, -("Ka List"));
   Set_Alignment (Hopa_Window.Label30, 1.0, 0.5);
   Set_Padding (Hopa_Window.Label30, 5, 0);
   Set_Justify (Hopa_Window.Label30, Justify_Right);
   Set_Line_Wrap (Hopa_Window.Label30, False);
   Add (Hopa_Window.Alignment10, Hopa_Window.Label30);

   Gtk_New
     (Hopa_Window.Alignment7, 1.0, 0.5, 0.95,
      0.95);
   Attach (Hopa_Window.Table4, Hopa_Window.Alignment7, 0, 1, 4, 5,
     Fill, Expand or Fill,
     0, 0);

   Gtk_New (Hopa_Window.Label20, -("Optimization Iterations"));
   Set_Alignment (Hopa_Window.Label20, 1.0, 0.5);
   Set_Padding (Hopa_Window.Label20, 5, 0);
   Set_Justify (Hopa_Window.Label20, Justify_Right);
   Set_Line_Wrap (Hopa_Window.Label20, False);
   Add (Hopa_Window.Alignment7, Hopa_Window.Label20);

   Gtk_New (Hopa_Window.Opiter_Entry);
   Set_Editable (Hopa_Window.Opiter_Entry, True);
   Set_Max_Length (Hopa_Window.Opiter_Entry, 0);
   Set_Text (Hopa_Window.Opiter_Entry, -"");
   Set_Visibility (Hopa_Window.Opiter_Entry, True);
   Attach (Hopa_Window.Table4, Hopa_Window.Opiter_Entry, 1, 2, 4, 5,
     Expand or Fill, 0,
     0, 0);

   Gtk_New
     (Hopa_Window.Alignment8, 1.0, 0.5, 0.95,
      0.95);
   Attach (Hopa_Window.Table4, Hopa_Window.Alignment8, 0, 1, 3, 4,
     Fill, Expand or Fill,
     0, 0);

   Gtk_New (Hopa_Window.Label28, -("Iterations List"));
   Set_Alignment (Hopa_Window.Label28, 1.0, 0.5);
   Set_Padding (Hopa_Window.Label28, 5, 0);
   Set_Justify (Hopa_Window.Label28, Justify_Right);
   Set_Line_Wrap (Hopa_Window.Label28, False);
   Add (Hopa_Window.Alignment8, Hopa_Window.Label28);

   Gtk_New
     (Hopa_Window.Alignment9, 1.0, 0.5, 0.95,
      0.95);
   Attach (Hopa_Window.Table4, Hopa_Window.Alignment9, 0, 1, 2, 3,
     Fill, Fill,
     0, 0);

   Gtk_New (Hopa_Window.Label29, -("Kr List"));
   Set_Alignment (Hopa_Window.Label29, 1.0, 0.5);
   Set_Padding (Hopa_Window.Label29, 5, 0);
   Set_Justify (Hopa_Window.Label29, Justify_Right);
   Set_Line_Wrap (Hopa_Window.Label29, False);
   Add (Hopa_Window.Alignment9, Hopa_Window.Label29);

   Gtk_New (Hopa_Window.Iter_List_Entry);
   Set_Editable (Hopa_Window.Iter_List_Entry, True);
   Set_Max_Length (Hopa_Window.Iter_List_Entry, 0);
   Set_Text (Hopa_Window.Iter_List_Entry, -"");
   Set_Visibility (Hopa_Window.Iter_List_Entry, True);
   Attach (Hopa_Window.Table4, Hopa_Window.Iter_List_Entry, 1, 2, 3, 4,
     Expand or Fill, 0,
     0, 0);

   Gtk_New_Hbox (Hopa_Window.Hbox14, True, 0);
   Set_Border_Width (Hopa_Window.Hbox14, 14);
   Pack_Start (Hopa_Window.Vbox9, Hopa_Window.Hbox14, True, True, 0);

   Gtk_New (Hopa_Window.Hset_Button);
   Set_Relief (Hopa_Window.Hset_Button, Relief_Normal);
   Pack_Start (Hopa_Window.Hbox14, Hopa_Window.Hset_Button, False, False, 0);
   Button_Callback.Connect
     (Hopa_Window.Hset_Button, "clicked",
      Button_Callback.To_Marshaller (On_Hset_Button_Clicked'Access));

   Gtk_New
     (Hopa_Window.Alignment17, 0.5, 0.5, 0.0,
      0.0);
   Add (Hopa_Window.Hset_Button, Hopa_Window.Alignment17);

   Gtk_New_Hbox (Hopa_Window.Hbox17, False, 2);
   Add (Hopa_Window.Alignment17, Hopa_Window.Hbox17);

   Gtk_New (Hopa_Window.Image3 , "gtk-apply", Gtk_Icon_Size'Val (4));
   Set_Alignment (Hopa_Window.Image3, 0.5, 0.5);
   Set_Padding (Hopa_Window.Image3, 0, 0);
   Pack_Start
     (Hopa_Window.Hbox17,
      Hopa_Window.Image3,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Hopa_Window.Label33, -("Set"));
   Set_Alignment (Hopa_Window.Label33, 0.5, 0.5);
   Set_Padding (Hopa_Window.Label33, 0, 0);
   Set_Justify (Hopa_Window.Label33, Justify_Left);
   Set_Line_Wrap (Hopa_Window.Label33, False);
   Set_Selectable (Hopa_Window.Label33, False);
   Set_Use_Markup (Hopa_Window.Label33, False);
   Set_Use_Underline (Hopa_Window.Label33, True);
   Pack_Start
     (Hopa_Window.Hbox17,
      Hopa_Window.Label33,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Hopa_Window.Hget_Defaults_Button);
   Set_Relief (Hopa_Window.Hget_Defaults_Button, Relief_Normal);
   Pack_Start (Hopa_Window.Hbox14, Hopa_Window.Hget_Defaults_Button, False, False, 0);
   Button_Callback.Connect
     (Hopa_Window.Hget_Defaults_Button, "clicked",
      Button_Callback.To_Marshaller (On_Hget_Defaults_Button_Clicked'Access));

   Gtk_New
     (Hopa_Window.Alignment18, 0.5, 0.5, 0.0,
      0.0);
   Add (Hopa_Window.Hget_Defaults_Button, Hopa_Window.Alignment18);

   Gtk_New_Hbox (Hopa_Window.Hbox18, False, 2);
   Add (Hopa_Window.Alignment18, Hopa_Window.Hbox18);

   Gtk_New (Hopa_Window.Image4 , "gtk-refresh", Gtk_Icon_Size'Val (4));
   Set_Alignment (Hopa_Window.Image4, 0.5, 0.5);
   Set_Padding (Hopa_Window.Image4, 0, 0);
   Pack_Start
     (Hopa_Window.Hbox18,
      Hopa_Window.Image4,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New (Hopa_Window.Label34, -("Get Defaults"));
   Set_Alignment (Hopa_Window.Label34, 0.5, 0.5);
   Set_Padding (Hopa_Window.Label34, 0, 0);
   Set_Justify (Hopa_Window.Label34, Justify_Left);
   Set_Line_Wrap (Hopa_Window.Label34, False);
   Set_Selectable (Hopa_Window.Label34, False);
   Set_Use_Markup (Hopa_Window.Label34, False);
   Set_Use_Underline (Hopa_Window.Label34, True);
   Pack_Start
     (Hopa_Window.Hbox18,
      Hopa_Window.Label34,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Gtk_New_From_Stock (Hopa_Window.Hopa_Help_Button, "gtk-help");
   Set_Relief (Hopa_Window.Hopa_Help_Button, Relief_Normal);
   Pack_Start (Hopa_Window.Hbox14, Hopa_Window.Hopa_Help_Button, False, False, 0);
   Button_Callback.Connect
     (Hopa_Window.Hopa_Help_Button, "clicked",
      Button_Callback.To_Marshaller (On_Hopa_Help_Button_Clicked'Access));

   Gtk_New_From_Stock (Hopa_Window.Hcancel_Button, "gtk-cancel");
   Set_Relief (Hopa_Window.Hcancel_Button, Relief_Normal);
   Pack_Start (Hopa_Window.Hbox14, Hopa_Window.Hcancel_Button, False, False, 0);
   Button_Callback.Connect
     (Hopa_Window.Hcancel_Button, "clicked",
      Button_Callback.To_Marshaller (On_Hcancel_Button_Clicked'Access));

end Initialize;

end Hopa_Window_Pkg;
