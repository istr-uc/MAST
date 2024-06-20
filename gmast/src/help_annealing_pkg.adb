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
with Gtk.Text_Buffer; use Gtk.Text_Buffer;
with Gtk.Text_Iter; use Gtk.Text_Iter;
with Gtk.Text_Tag; use Gtk.Text_Tag;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_Gmast_Analysis; use Callbacks_Gmast_Analysis;
with Gmast_Analysis_Intl; use Gmast_Analysis_Intl;
with Help_Annealing_Pkg.Callbacks; use Help_Annealing_Pkg.Callbacks;
with Ada.Characters.Latin_1;
with Pango.Font; use Pango.Font;

package body Help_Annealing_Pkg is

procedure Gtk_New (Help_Annealing : out Help_Annealing_Access) is
begin
   Help_Annealing := new Help_Annealing_Record;
   Help_Annealing_Pkg.Initialize (Help_Annealing);
end Gtk_New;

procedure Initialize (Help_Annealing : access Help_Annealing_Record'Class) is

   BF,HF,TF : Pango_Font_Description;
   NL : Character := Ada.Characters.Latin_1.LF;
   Buf : Gtk_Text_Buffer;
   Iter : Gtk.Text_Iter.Gtk_Text_Iter;
   Tag_BF, Tag_HF, Tag_TF : Gtk.Text_Tag.Gtk_Text_Tag;
   
   pragma Suppress (All_Checks);
begin
   Gtk.Window.Initialize (Help_Annealing, Window_TopLevel);
   Set_Title (Help_Annealing, -"Help on Annealing Parameters");
   Set_Position (Help_Annealing, Win_Pos_Mouse);
   Set_Modal (Help_Annealing, True);
   Set_Default_Size (Help_Annealing, 600, 400);

   Gtk_New_Vbox (Help_Annealing.Vbox11, False, 0);
   Add (Help_Annealing, Help_Annealing.Vbox11);

   Gtk_New (Help_Annealing.Scrolledwindow3);
   Set_Policy (Help_Annealing.Scrolledwindow3, Policy_Always, Policy_Always);
   Pack_Start (Help_Annealing.Vbox11, Help_Annealing.Scrolledwindow3, True, True, 0);

   Gtk_New (Help_Annealing.Text_View3);
   Buf:=Get_Buffer(Help_Annealing.Text_View3);
   Set_Editable (Help_Annealing.Text_View3, False);
   Add (Help_Annealing.Scrolledwindow3, Help_Annealing.Text_View3);

   Gtk_New
     (Help_Annealing.Alignment12, 0.5, 0.5, 0.0100005,
      0.0100005);
   Pack_Start (Help_Annealing.Vbox11, Help_Annealing.Alignment12, False, False, 0);

   Gtk_New_From_Stock (Help_Annealing.Help_Ann_Ok_Button, "gtk-close");
   Set_Border_Width (Help_Annealing.Help_Ann_Ok_Button, 6);
   Set_Relief (Help_Annealing.Help_Ann_Ok_Button, Relief_Normal);
   Button_Callback.Connect
     (Help_Annealing.Help_Ann_Ok_Button, "clicked",
      Button_Callback.To_Marshaller (On_Help_Ann_Ok_Button_Clicked'Access));
   Add (Help_Annealing.Alignment12, Help_Annealing.Help_Ann_Ok_Button);
   Set_Border_Width (Help_Annealing.Help_Ann_Ok_Button, 6);

   BF := From_String("Sans Bold 14");
   HF := From_String("Sans Bold 18");
   TF := From_String("Sans Bold 32");
   
   Tag_TF:= Create_Tag(Buf,"TF");
   Set_Property(Tag_TF,Font_Desc_Property,TF);
   Tag_HF:= Create_Tag(Buf,"HF");
   Set_Property(Tag_HF,Font_Desc_Property,HF);
   Tag_BF:= Create_Tag(Buf,"BF");
   Set_Property(Tag_BF,Font_Desc_Property,BF);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_tags(Buffer=>Buf,Iter=> Iter, Text=>"Mast"&NL, Tag=> Tag_TF);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Priority assignment parameters"&NL, Tag => Tag_HF);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"    The priority assignment parameters allow the configuration of the"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"    priority assignment tools in order to determine two main aspects:"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"       a) bounding the number of iterations performed by the algorithm to"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"       reach a priority assignment that makes the system schedulable"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"       b) bounding the number of iterations to optimize, which are used"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"       after a feasible solution has been obtained to optimize and try"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"       reaching a better assignment."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Simulated annealing parameters:"&NL, Tag => Tag_HF);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>" - Max_Iterations: maximum number of iterations to be performed by"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"   the algorithm."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>" - Iterations_To_Optimize: maximum number of iterations to be"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"   performed by the algorithm after the first feasible solution has"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"   been reached."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);


end Initialize;

end Help_Annealing_Pkg;
