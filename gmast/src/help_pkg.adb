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
with Gtk.Text_Buffer; use Gtk.Text_Buffer;
with Gtk.Text_Iter; use Gtk.Text_Iter;
with Gtk.Text_Tag; use Gtk.Text_Tag;
with Callbacks_Gmast_Analysis; use Callbacks_Gmast_Analysis;
with Gmast_Analysis_Intl; use Gmast_Analysis_Intl;
with Help_Pkg.Callbacks; use Help_Pkg.Callbacks;
with Ada.Characters.Latin_1;
with Pango.Font; use Pango.Font;

package body Help_Pkg is

procedure Gtk_New (Help : out Help_Access) is
begin
   Help := new Help_Record;
   Help_Pkg.Initialize (Help);
end Gtk_New;

procedure Initialize (Help : access Help_Record'Class) is

   BF,HF,TF : Pango_Font_Description;
   NL : Character := Ada.Characters.Latin_1.LF;
   Buf : Gtk_Text_Buffer;
   Iter : Gtk.Text_Iter.Gtk_Text_Iter;
   Tag_BF, Tag_HF, Tag_TF : Gtk.Text_Tag.Gtk_Text_Tag;

   pragma Suppress (All_Checks);

begin
   Gtk.Window.Initialize (Help, Window_TopLevel);
   Set_Title (Help, -"Help");
   Set_Position (Help, Win_Pos_None);
   Set_Modal (Help, True);
   Set_Default_Size (Help, 600, 400);

   Gtk_New_Vbox (Help.Vbox7, False, 0);
   Add (Help, Help.Vbox7);

   Gtk_New (Help.Scrolledwindow1);
   Set_Policy (Help.Scrolledwindow1, Policy_Always, Policy_Always);
   Pack_Start (Help.Vbox7, Help.Scrolledwindow1, True, True, 0);

   Gtk_New (Help.Text_View1);
   Buf:=Get_Buffer(Help.Text_View1);
   Set_Editable (Help.Text_View1, False);
   Add (Help.Scrolledwindow1, Help.Text_View1);

   Gtk_New
     (Help.Alignment4, 0.5, 0.5, 0.0100005,
      0.0100005);
   Pack_Start (Help.Vbox7, Help.Alignment4, False, False, 0);

   Gtk_New_From_Stock (Help.Help_Ok, "gtk-close");
   Set_Border_Width (Help.Help_Ok, 6);
   Set_Relief (Help.Help_Ok, Relief_Normal);
   Button_Callback.Connect
     (Help.Help_Ok, "clicked",
      Button_Callback.To_Marshaller (On_Help_Ok_Clicked'Access));
   Add (Help.Alignment4, Help.Help_Ok);
   Set_Border_Width (Help.Help_Ok, 6);

   BF := From_String("Sans Bold 12");
   HF := From_String("Sans Bold 14");
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
   Insert_With_Tags
     (Buffer=>Buf,Iter=> Iter, 
      Text=>"Modelling and Analysis Suite for Real-Time Applications"&NL, 
      Tag => Tag_HF);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Tool Description"&NL, 
		    Tag => Tag_HF);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);

   Insert_At_Cursor(Buffer=>Buf,Text=>"      The tool parses the Input file.");
   Insert_At_Cursor(Buffer=>Buf,Text=>"      If it finds errors it reports them and stops. The list of"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"      errors can be found in the file 'mast_parser.lis'. If there are"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"      no errors, the real-time system description is transformed"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"      according to the options specified, the analysis is performed,"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"      and the results are output to the output file."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Tool: ", 
		    Tag => Tag_BF);
   Insert_At_Cursor(Buffer=>Buf,Text=>" is one of the following"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           default : uses the best tool available for"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                     the system: "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                      - offset_based_slanted for systems"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                        with linear transactions"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                      - edf_monoprocessor for simple transaction"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                        systems scheduled under EDF"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                      - classic_rm for simple transaction"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                        systems scheduled under fixed priorities"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           parse : does not make the analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           classic_rm : classic response time analysis for"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                        fixed-priority systems with arbitrary deadlines"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           varying_priorities : varying priorities analysis for"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                linear fixed-priority monoprocessor systems"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           edf_monoprocessor : response time analysis for EDF"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                               monoprocessor systems"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           edf_within_priorities : response time analysis for single"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                   processor systems with hierarchical"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                   scheduling: EDF on top of fixed"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                   priorities"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           holistic : holistic linear analysis both for fixed"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                      priority and EDF processing resources;"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                      for FPS use offset_based which gives"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                      better results"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           offset_based : it defaults to the offset_based_slanted analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           offset_slanted  : offset-based linear analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             optimized to take advantage of the"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             slanted nature of the consumption of execution"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             time; it is an evolution of the offset_based_approx"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             technique, but does not make the optimization"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             by the precedence relations done in the"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             offset_based_approx_w_pr technique"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             it may or may not provide better results"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             than that technique;"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             For EDF processing resources, since offset_based"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             analysis is not yet implemented for them, "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                             the holistic analysis is used "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           offset_based_approx :offset-based linear analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                with no optimizations. it provides"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                results that are worse than in the"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                offset_based_slanted technique; it is"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                provided for comparison purposes"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                For EDF processing resources, since offset_based"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                analysis is not yet implemented for them, "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                the holistic analysis is used "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           offset_based_approx_w_pr:offset-based linear analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    like the offset_based_approx technique"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    but optimizing the analysis by using the precedence"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    relations in the transactions; it may or may not"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    provide better results than the offset_based_slanted"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    technique."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    For EDF processing resources, since offset_based"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    analysis is not yet implemented for them, "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    the holistic analysis is used "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"           offset_based_brute_force:exact offset-based linear analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    trying all possible combinations of tasks"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    for generating the critical instant; this"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    leads to exponential analysis times; this"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    technique should only be used for very small"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                                    examples"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);

   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Directory: ", 
		    Tag => Tag_BF);
   
   Insert_At_Cursor(Buffer=>Buf,Text=>"this is the directory used for the input, output, and"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   description files (see below). It is set when the "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                  'File...' button is used to browse the file system."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Input File: ", 
		    Tag => Tag_BF);

   Insert_At_Cursor(Buffer=>Buf,Text=>"it needs to be defined using the Mast file format (text or XML)"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                  (see the Mast file format definition)"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Output File: ", 
		    Tag => Tag_BF);

   Insert_At_Cursor(Buffer=>Buf,Text=>"will contain the results of the analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   if not specified, then output goes to standard"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   output."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   The 'Default' button will provide an automatic file"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   name for this field."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   The 'Blank' button will make this field blank"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"  "&NL);
   
   Get_End_Iter(Buf,Iter);
   Insert_With_Tags(Buffer=>Buf,Iter=> Iter, 
		    Text=>"Options: ", 
		    Tag => Tag_BF);
   Insert_At_Cursor(Buffer=>Buf,Text=>"the following options are defined:"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Verbose:"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              enable the verbose option"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Local EDF"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              Only used for EDF echeduling. If this flag is specified,"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              Local EDF is used in EDF schedulers, with scheduling"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              deadlines interpretated as local to the processing"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              resource clock. Otherwise, Global EDF is used, with"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              scheduling deadlines assumed to be relative to a "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              system-wide clock."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);

   Insert_At_Cursor(Buffer=>Buf,Text=>"        Calculate Ceilings & Levels"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              calculate ceilings for priority ceiling resources and"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              preemption levels for the stack resource policy before"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              the analysis"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Assign Parameters"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              make an optimum priority or scheduling parameters"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              assignment before the analysis, using the specified"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              assignment technique"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);

   Insert_At_Cursor(Buffer=>Buf,Text=>"        Technique"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              The technique specifies the priority assignment technique"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              named with 'name'; it can be one of the following:"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   default"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   hospa          (default for multiprocessors)"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   pd"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   npd"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   annealing"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"                   monoprocessor (default for monoprocessors)"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Stop factor"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              Analysis will stop iterating when the response time of a"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              task exceeds its hard deadline multiplied by this"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              ""factor"". The default value is 100"&NL);

   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Source Dest. File"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               if this option is specified, after parsing the file and,"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               if required, calculating the ceilings and priorities, a"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               description of the system is written to the filename"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               specified in the option. "&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Calculate Slacks"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               if this option is specified, the analysis is iterated"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               to obtain the system slack, the processing resource slacks and"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"               the transaction slacks."&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"        Calc. Operation Slack"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              if this option is specified, the analysis is iterated to obtain"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              the operation slack associated with the operation whose"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>"              name appears in the entry box placed to the right of the option"&NL);
   Insert_At_Cursor(Buffer=>Buf,Text=>""&NL);

end Initialize;

end Help_Pkg;
