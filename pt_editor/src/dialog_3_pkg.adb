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
with Dialog_3_Pkg.Callbacks; use Dialog_3_Pkg.Callbacks;

package body Dialog_3_Pkg is

procedure Gtk_New (Dialog_3 : out Dialog_3_Access) is
begin
   Dialog_3 := new Dialog_3_Record;
   Dialog_3_Pkg.Initialize (Dialog_3);
end Gtk_New;

procedure Initialize (Dialog_3 : access Dialog_3_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
begin
   Gtk.Dialog.Initialize (Dialog_3);
   Set_Border_Width (Dialog_3, 5);
   --Set_USize (Dialog_3, 270, 110);

   Gtk_New
     (Dialog_3.Alignment10, 0.5, 0.5, 1.0,
      1.0);

   Gtk_New (Dialog_3.Label12, -("label-text"));

   Add (Dialog_3.Alignment10, Dialog_3.Label12);
   Pack_Start
     (Dialog_3.Get_Content_Area,
      Dialog_3.Alignment10,
      Expand  => True,
      Fill    => True,
      Padding => 10);

   Gtk_New (Dialog_3.Dialog_Button1, -"Yes");

   Pack_Start
     (Get_Action_Area (Dialog_3),
      Dialog_3.Dialog_Button1,
      Expand  => False,
      Fill    => False,
      Padding => 10);

   Gtk_New (Dialog_3.Dialog_Button2, -"No");

   Pack_Start
     (Get_Action_Area (Dialog_3),
      Dialog_3.Dialog_Button2,
      Expand  => False,
      Fill    => False,
      Padding => 10);

   Gtk_New (Dialog_3.Dialog_Button3, -"Cancel");

   Pack_Start
     (Get_Action_Area (Dialog_3),
      Dialog_3.Dialog_Button3,
      Expand  => False,
      Fill    => False,
      Padding => 10);

   Show_All(Dialog_3);

   --  Connect signals

   Button_Callback.Connect
     (Dialog_3.Dialog_Button1, "pressed",
      Button_Callback.To_Marshaller (On_Dialog_Button1_Pressed'Access), False);
   Button_Callback.Connect
     (Dialog_3.Dialog_Button2, "pressed",
      Button_Callback.To_Marshaller (On_Dialog_Button2_Pressed'Access), False);
   Button_Callback.Connect
     (Dialog_3.Dialog_Button3, "pressed",
      Button_Callback.To_Marshaller (On_Dialog_Button3_Pressed'Access), False);
   Return_Callback.Connect
     (Dialog_3, "delete_event", On_Dialog_3_Delete_Event'Access, False);
end Initialize;

   ----------------
   -- Run_Dialog --
   ----------------
   procedure Run_Dialog(Message, Button1, Button2, Button3 : String;
                        Response : out Response_3_Type)
   is
   begin
      Gtk_New (Dialog_3_Pkg.Dialog_3);
      Set_Text(Dialog_3_Pkg.Dialog_3.Label12,Message);
            -- Wait until dialog is closed
      Set_Label(Dialog_3_Pkg.Dialog_3.Dialog_Button1,Button1);
      Set_Label(Dialog_3_Pkg.Dialog_3.Dialog_Button2,Button2);
      Set_Label(Dialog_3_Pkg.Dialog_3.Dialog_Button3,Button3);
      case Run (Dialog_3_Pkg.Dialog_3) is
         when Gtk_Response_Yes => Response:=Response_Button1;
         when Gtk_Response_No => Response:=Response_Button2;
         when others => Response:=Response_Button3;
      end case;
      Hide (Dialog_3_Pkg.Dialog_3);
      Destroy (Dialog_3_Pkg.Dialog_3);
   end Run_Dialog;



end Dialog_3_Pkg;
