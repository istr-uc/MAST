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

with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Label; use Gtk.Label;
with Gtk.Button; use Gtk.Button;
package Dialog_3_Pkg is

   type Dialog_3_Record is new Gtk_Dialog_Record with record
      Alignment10 : Gtk_Alignment;
      Label12 : Gtk_Label;
      Dialog_Button1 : Gtk_Button;
      Dialog_Button2 : Gtk_Button;
      Dialog_Button3 : Gtk_Button;
   end record;
   type Dialog_3_Access is access all Dialog_3_Record'Class;

   type Response_3_Type is
     (Response_Button1, Response_Button2, Response_Button3);

   procedure Gtk_New (Dialog_3 : out Dialog_3_Access);
   procedure Initialize (Dialog_3 : access Dialog_3_Record'Class);

   procedure Run_Dialog(Message, Button1, Button2, Button3 : String;
                        Response : out Response_3_Type);

   Dialog_3 : Dialog_3_Access;

end Dialog_3_Pkg;
