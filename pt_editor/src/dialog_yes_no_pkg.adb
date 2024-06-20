-----------------------------------------------------------------------
--                MAST Graphical Periodic Task Editor                --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2001-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--                                                                   --
-- This program is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 3 of the License, or (at your option) any later version.  --
--                                                                   --
-- This program is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this program; if not, see                      --
-- <http://www.gnu.org/licenses/>.                                   --
--                                                                   --
-----------------------------------------------------------------------

with Glib; use Glib;
with Gtk; use Gtk;
with Gdk.Types; use Gdk.Types;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Enums; use Gtk.Enums;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_pt_editor; use Callbacks_pt_editor;
with pt_editor_Intl; use pt_editor_Intl;
with Gtk.Box; use Gtk.Box;
with Dialog_Yes_No_Pkg.Callbacks; use Dialog_Yes_No_Pkg.Callbacks;

package body Dialog_Yes_No_Pkg is

procedure Gtk_New (Dialog_Yes_No : out Dialog_Yes_No_Access) is
begin
   Dialog_Yes_No := new Dialog_Yes_No_Record;
   Dialog_Yes_No_Pkg.Initialize (Dialog_Yes_No);
end Gtk_New;

procedure Initialize (Dialog_Yes_No : access Dialog_Yes_No_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
begin
   Gtk.Dialog.Initialize (Dialog_Yes_No);
   Set_Border_Width (Dialog_Yes_No, 5);
   --Set_USize (Dialog_Yes_No, 270, 110);

   Gtk_New
     (Dialog_Yes_No.Alignment10, 0.5, 0.5, 1.0,
      1.0);

   Gtk_New (Dialog_Yes_No.Label12, -("label-text"));

   Add (Dialog_Yes_No.Alignment10, Dialog_Yes_No.Label12);
   Pack_Start
     (Dialog_Yes_No.Get_Content_Area,
      Dialog_Yes_No.Alignment10,
      Expand  => True,
      Fill    => True,
      Padding => 10);

   Gtk_New (Dialog_Yes_No.Dialog_Yes_Button, -"Yes");

   Pack_Start
     (Get_Action_Area (Dialog_Yes_No),
      Dialog_Yes_No.Dialog_Yes_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);

   Gtk_New (Dialog_Yes_No.Dialog_No_Button, -"No");

   Pack_Start
     (Get_Action_Area (Dialog_Yes_No),
      Dialog_Yes_No.Dialog_No_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);

   Show_All(Dialog_Yes_No);

   --  Connect signals

   Button_Callback.Connect
     (Dialog_Yes_No.Dialog_Yes_Button, "pressed",
      Button_Callback.To_Marshaller (On_Dialog_Yes_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Dialog_Yes_No.Dialog_No_Button, "pressed",
      Button_Callback.To_Marshaller (On_Dialog_No_Button_Pressed'Access), False);
   Return_Callback.Connect
     (Dialog_Yes_No, "delete_event", On_Dialog_Yes_No_Delete_Event'Access, False);
end Initialize;

   ----------------
   -- Run_Dialog --
   ----------------
   procedure Run_Dialog(Message : String; Response_Is_Yes : out Boolean) is
   begin
      Run_Dialog(Message,"Yes","No",Response_Is_Yes);
   end Run_Dialog;

   ----------------
   -- Run_Dialog --
   ----------------
   procedure Run_Dialog(Message, Button1, Button2 : String;
                        Response_Is_1 : out Boolean)
   is
   begin
      Gtk_New (Dialog_Yes_No_Pkg.Dialog_Yes_No);
      Set_Text(Dialog_Yes_No_Pkg.Dialog_Yes_No.Label12,Message);
            -- Wait until dialog is closed
      Set_Label(Dialog_Yes_No_Pkg.Dialog_Yes_No.Dialog_Yes_Button,Button1);
      Set_Label(Dialog_Yes_No_Pkg.Dialog_Yes_No.Dialog_No_Button,Button2);
      if Run (Dialog_Yes_No_Pkg.Dialog_Yes_No) = Gtk_Response_Yes then
         Response_Is_1:=True;
      else
         Response_Is_1:=False;
      end if;
      Hide (Dialog_Yes_No_Pkg.Dialog_Yes_No);
      Destroy (Dialog_Yes_No_Pkg.Dialog_Yes_No);
   end Run_Dialog;



end Dialog_Yes_No_Pkg;
