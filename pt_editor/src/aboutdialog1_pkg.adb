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
with Gtk.Window; use Gtk.Window;
with Callbacks_pt_editor; use Callbacks_pt_editor;
with Gtk.Dialog;           use Gtk.Dialog;
with Gtk.Box; use Gtk.Box;
with Pt_Editor_Pkg;
with pt_editor_Intl; use pt_editor_Intl;

package body Aboutdialog1_Pkg is

procedure Gtk_New (Aboutdialog1 : out Aboutdialog1_Access) is
begin
   Aboutdialog1 := new Aboutdialog1_Record;
   Aboutdialog1_Pkg.Initialize (Aboutdialog1);
end Gtk_New;

procedure Initialize (Aboutdialog1 : access Aboutdialog1_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
begin

   Gtk.About_Dialog.Initialize(Aboutdialog1);
   Set_Transient_For (Aboutdialog1, Gtk_Window
                        (Pt_Editor_Pkg.Pt_Editor));
   Set_Destroy_With_Parent (Aboutdialog1, True);
   Set_Modal (Aboutdialog1, True);
   Set_Comments
     (Aboutdialog1, "This program is part of MAST: "&
        "Modelling and Analysis Suite for Real-Time Systems");
   Set_Authors (Aboutdialog1,
                (1 => new String'("Michael González Harbour <mgh@unican.es>")));

   Set_Copyright
        (Aboutdialog1, "Copyright (c) 2010, Universidad de Cantabria");
   Set_License
     (Aboutdialog1,
      "This program is free software; you can redistribute it and/or"
        & " modify it under the terms of the GNU General Public"
        & " License as published by the Free Software Foundation; either"
        & " version 2 of the License, or (at your option) any later version."
        & ASCII.LF
        & "This library is distributed in the hope that it will be useful,"
        & " but WITHOUT ANY WARRANTY; without even the implied warranty of"
        & " MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU"
        & " General Public License for more details.");
   Set_Wrap_License (Aboutdialog1, True);
   Set_Name (Aboutdialog1, "MAST Periodic Task Editor");
   Set_Version (Aboutdialog1, "0.1");
   Set_Website (Aboutdialog1, "http://mast.unican.es");
   Set_Website_Label (Aboutdialog1, "mast.unican.es");

   Gtk_New (Aboutdialog1.Textview1);
   declare
      Iter : Gtk_Text_Iter;
   begin
      Get_Iter_At_Line (Get_Buffer (Aboutdialog1.Textview1), Iter, 0);
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("The objective of the Periodic Task Editor is to provide an"&
               ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("easy way of defining a MAST model for a simple task system"&
               ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("running on a single processor."&
                  ASCII.LF&ASCII.LF));

      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("The editor allows defining periodic tasks with their execution"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("times (WCET), periods (T), and Deadlines (D). These tasks may"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("interact by sharing mutual exclusion resources."&
                  ASCII.LF&ASCII.LF));

      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("The editor uses the MAST schedulability analysis tools to"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("automatically assign priorities or scheduling parameters,"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("and to obtain worst case response times and overall system"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("utilization and slack."&
                  ASCII.LF&ASCII.LF));

      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("The model is stored in a file with termination "".pte"", which"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("can be later edited with this program."&
                  ASCII.LF&ASCII.LF));

      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("In addition, the tool saves the model in a file with"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("termination ""_mast.txt"", which contains the full MAST model"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("that can be edited with gmasteditor and used with the"&
                  ASCII.LF));
      Insert (Get_Buffer (Aboutdialog1.Textview1), Iter,
              -("MAST analysis tools."&
                  ASCII.LF));

   end;

   Pack_Start
     (Get_Content_Area (Aboutdialog1),
      Aboutdialog1.Textview1,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Show_All (Aboutdialog1);

   --  Connect signals

end Initialize;

end Aboutdialog1_Pkg;
