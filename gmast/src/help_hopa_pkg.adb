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
with Help_Hopa_Pkg.Callbacks; use Help_Hopa_Pkg.Callbacks;
with Ada.Characters.Latin_1;
with Pango.Font; use Pango.Font;

package body Help_Hopa_Pkg is

procedure Gtk_New (Help_Hopa : out Help_Hopa_Access) is
begin
   Help_Hopa := new Help_Hopa_Record;
   Help_Hopa_Pkg.Initialize (Help_Hopa);
end Gtk_New;

procedure Initialize (Help_Hopa : access Help_Hopa_Record'Class) is

   BF,HF,TF : Pango_Font_Description;
   NL : Character := Ada.Characters.Latin_1.LF;
   Buf : Gtk_Text_Buffer;
   Iter : Gtk.Text_Iter.Gtk_Text_Iter;
   Tag_BF, Tag_HF, Tag_TF : Gtk.Text_Tag.Gtk_Text_Tag;

   pragma Suppress (All_Checks);

begin
   Gtk.Window.Initialize (Help_Hopa, Window_TopLevel);
   Set_Title (Help_Hopa, -"Help on the HOSPA Parameters");
   Set_Position (Help_Hopa, Win_Pos_Mouse);
   Set_Modal (Help_Hopa, True);
   Set_Default_Size (Help_Hopa, 600, 400);

   Gtk_New_Vbox (Help_Hopa.Vbox10, False, 0);
   Add (Help_Hopa, Help_Hopa.Vbox10);

   Gtk_New (Help_Hopa.Scrolledwindow2);
   Set_Policy (Help_Hopa.Scrolledwindow2, Policy_Always, Policy_Always);
   Pack_Start (Help_Hopa.Vbox10, Help_Hopa.Scrolledwindow2, True, True, 0);

   Gtk_New (Help_Hopa.Text_View2);
   Buf:=Get_Buffer(Help_Hopa.Text_View2);
   Set_Editable (Help_Hopa.Text_View2, False);
   Add (Help_Hopa.Scrolledwindow2, Help_Hopa.Text_View2);

   Gtk_New
     (Help_Hopa.Alignment11, 0.5, 0.5, 0.0100005,
      0.0100005);
   Pack_Start (Help_Hopa.Vbox10, Help_Hopa.Alignment11, False, False, 0);

   Gtk_New_From_Stock (Help_Hopa.Help_Hopa_Ok_Button, "gtk-close");
   Set_Border_Width (Help_Hopa.Help_Hopa_Ok_Button, 6);
   Set_Relief (Help_Hopa.Help_Hopa_Ok_Button, Relief_Normal);
   Button_Callback.Connect
     (Help_Hopa.Help_Hopa_Ok_Button, "clicked",
      Button_Callback.To_Marshaller (On_Help_Hopa_Ok_Button_Clicked'Access));
   Add (Help_Hopa.Alignment11, Help_Hopa.Help_Hopa_Ok_Button);
   Set_Border_Width (Help_Hopa.Help_Hopa_Ok_Button, 6);

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
		    Text=>"Assignment of scheduling parameters"&NL, 
		    Tag => Tag_HF);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>
       " The configuration of the scheduling parameters assignment tools is"&NL&
       " needed in order to determine the following aspects:"&NL&
       NL&
       " a) bounding the number of iterations performed by the algorithm to"&NL&
       "    reach a sheduling parameter assignment that makes the system"&NL&
       "    schedulable"&NL&
       NL&
       " b) bounding the number of iterations to optimize, which are used"&NL&
       "    after a feasible solution has been obtained to optimize and try"&NL&
       "    reaching a better assignment."&NL&
       NL&
       " c) defining additional parameters for configuring the way in"&NL&
       "    which the heuristic algorithm does its work. Changing these"&NL&
       "    parameters may increase or decrease the quality of the"&NL&
       "    solution, so it is advised to make small changes and compare"&NL&
       "    the output obtained."&NL&
       NL&
       " The scheduling parameters assignment configuration values are"&NL&
       " found in the file assignment_parameters.txt, in the working"&NL&
       " directory."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_tags(Buffer=>Buf,Iter=> Iter, Text=>"HOSPA parameters:"&NL, 
		    Tag=> Tag_HF);
   
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>
             "The maximum number of iterations for this algorithm is not explicit,"&NL&
             "and depends on the size of the List of K-pairs and the values for the"&NL&
             "number of iterations declared in the iterations list."&NL&
             NL&
             " - Initial Assignment: Specifies what kind of initial parameters assignment"&NL&
             "   will be used:"&NL&
             "   - pd: The initial assignment of priorities and/or deadlines will be"&NL&
             "     proportional to each task's WCET."&NL&
             "   - npd: The initial assignment of priorities and/or deadlines will be"&NL&
             "     proportional to each task's WCET, normalizing the results according"&NL&
             "     to each processing resource's utilization."&NL&
             "   - user: The initial assignment of priorities and deadlines will be"&NL&
             "     provided by the user in the MAST description file."&NL&
             NL&
             " - List of K-pairs: K values are heuristic constants used to modify"&NL&
             "   the internal deadlines that are the basis of the algorithm. Normal"&NL&
             "   values for these constants are between 1.0 and 3.0, and the usual"&NL&
             "   number of different values that HOSPA may attempt is between 3 and 5."&NL&
             NL&
             " - Size_Of_K_List: number of K-pairs"&NL&
             NL&
             " - Ka_List: list of constants for varying the priorities or the"&NL&
             "   intermediate deadlines according to the response times of the"&NL&
             "   activities in a transaction"&NL&
             NL&
             " - Kr_List: list of constants for varying the priorities or the"&NL&
             "   intermediate deadlines according to the response times of the"&NL&
             "   activities in a processing resource"&NL&
             NL&
             " - List of number of iterations to perform for each K-pair:"&NL&
             "   Usually, this is a list with increasing values, starting for"&NL&
             "   example with 10. Each value represents an attempt to find better"&NL&
             "   solutions for all values of the list of K-pairs."&NL&
             NL&
             " - Size_Of_Iterations_List: size of the iterations list"&NL&
             NL&
             " - Iterations_List: list with the number of iterations to be"&NL&
             "   performed by the algorithm for each K-pair"&NL&
             NL&
             " - Iterations_To_Optimize: maximum number of iterations to be"&NL&
             "   performed by the algorithm after the first feasible solution has"&NL&
             "   been reached. "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);

end Initialize;

end Help_Hopa_Pkg;
