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
with Dialog1_Pkg.Callbacks; use Dialog1_Pkg.Callbacks;

package body Dialog1_Pkg is

procedure Gtk_New (Dialog1 : out Dialog1_Access) is
begin
   Dialog1 := new Dialog1_Record;
   Dialog1_Pkg.Initialize (Dialog1);
end Gtk_New;

procedure Initialize (Dialog1 : access Dialog1_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
begin
   Gtk.Dialog.Initialize (Dialog1);
   Set_Border_Width (Dialog1, 5);
   --Set_USize (Dialog1, 270, 110);

   Gtk_New
     (Dialog1.Alignment10, 0.5, 0.5, 1.0,
      1.0);

   Gtk_New (Dialog1.Label12, -("label-text"));

   Add (Dialog1.Alignment10, Dialog1.Label12);
   Pack_Start
     (Get_Content_Area (Dialog1),
      Dialog1.Alignment10,
      Expand  => True,
      Fill    => True,
      Padding => 10);

   Gtk_New (Dialog1.Dialog_Ok_Button, -"OK");

   Pack_Start
     (Get_Action_Area (Dialog1),
      Dialog1.Dialog_Ok_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);

   Show_All(Dialog1);

   --  Connect signals

   Button_Callback.Connect
     (Dialog1.Dialog_Ok_Button, "pressed",
      Button_Callback.To_Marshaller (On_Dialog_Ok_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Dialog1.Dialog_Ok_Button, "activate",
      Button_Callback.To_Marshaller (On_Dialog_Ok_Button_Activate'Access), False);
   Return_Callback.Connect
     (Dialog1, "delete_event", On_Dialog1_Delete_Event'Access, False);
end Initialize;

   ----------------
   -- Run_Dialog --
   ----------------
   procedure Run_Dialog(Message : String) is
   begin
      Gtk_New (Dialog1_Pkg.Dialog1);
      Set_Text(Dialog1_Pkg.Dialog1.Label12,Message);
            -- Wait until dialog is closed
      if Run (Dialog1_Pkg.Dialog1) = Gtk_Response_OK then
         null; --"Dialog OK"
      else
         null; --"Dialog was destroyed by user"
      end if;
      Hide (Dialog1_Pkg.Dialog1);
      Destroy (Dialog1_Pkg.Dialog1);
   end Run_Dialog;


end Dialog1_Pkg;
