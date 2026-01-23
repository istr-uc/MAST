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
with System; use System;
with Glib; use Glib;
with Gdk.Event; use Gdk.Event;
with Gdk.Types; use Gdk.Types;
with Gtk.Accel_Group; use Gtk.Accel_Group;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Style; use Gtk.Style;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Main; use Gtk.Main;
with Error_Window_Pkg; use Error_Window_Pkg;
with Error_InputFile_Pkg; use Error_InputFile_Pkg;
with Help_Pkg; use Help_Pkg;
with Annealing_Window_Pkg; use Annealing_Window_Pkg;
with Hopa_Window_Pkg; use Hopa_Window_Pkg;
with Check_Spaces;
with Parameters_Handling;
with Mast.Annealing_Parameters;
with Mast.Hospa_Parameters;
with Mast.Tool_Exceptions;
with Var_Strings; use Var_Strings;
with Ada.Text_IO; use Ada.Text_IO;
with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;
with Gtk.File_Chooser; use Gtk.File_Chooser;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Stock;
with Ada.Command_Line;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Directories;

package body Mast_Analysis_Pkg.Callbacks is

   use Gtk.Arguments;

   -----------------------------------
   -- On_Mast_Analysis_Delete_Event --
   -----------------------------------

   function On_Mast_Analysis_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean
   is
      Arg1 : Gdk_Event := To_Event (Params, 1);
   begin
      Ada.Command_Line.Set_Exit_Status(Ada.Command_Line.Failure);
      Gtk.Main.Main_Quit;
      return False;
   end On_Mast_Analysis_Delete_Event;

   ----------------------------
   -- On_Output_File_Changed --
   ----------------------------

   procedure On_Output_File_Changed
     (Object : access Gtk_Entry_Record'Class)
   is
   begin
      if Get_Text(Mast_Analysis.Output_File)="" or else
        Get_Active_Text(Mast_Analysis.Tool)="Parse"
      then

         Set_Active(Mast_Analysis.View_Results,False);
         Set_Sensitive(Mast_Analysis.View_Results,False);
      else
         Set_Sensitive(Mast_Analysis.View_Results,True);
         Set_Active(Mast_Analysis.View_Results,True);
      end if;
   end On_Output_File_Changed;

   ------------------------
   -- On_Default_Clicked --
   ------------------------

   procedure On_Default_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
      Out_Name : Var_String;
      Long : Natural;
   begin
      Out_Name :=To_Var_String(Get_Text(Mast_Analysis.Input_File));
      Long:=Length(Out_Name);
      if Long>3 and then Element(Out_Name,Long-3)='.' then
         Out_Name:=Slice(Out_Name,1,Long-3)&"out";
      else
         Out_Name:=Out_Name&".out";
      end if;
      Set_Text(Mast_Analysis.Output_File,To_String(Out_Name));
   end On_Default_Clicked;

   ----------------------
   -- On_Blank_Clicked --
   ----------------------

   procedure On_Blank_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Set_Text(Mast_Analysis.Output_File,"");
   end On_Blank_Clicked;

   -------------------------------------
   -- On_Input_File_Selection_Clicked --
   -------------------------------------

   procedure On_Input_File_Selection_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
      function Find_Pos_Last_Char(Char : Character;Line : String)
				 return Natural is
      begin
         for i in reverse 1..Line'Length loop
            if Line(i)=Char then
               return i;
            end if;
         end loop;
         return 0;
      end Find_Pos_Last_Char;
      
      Dialog : aliased Gtk_File_Chooser_Dialog;
      W1,w2 : Gtk_Widget;
      Success : Boolean;
      Dir_Name : Unbounded_String;
      
      Pos_Slash : Natural;
      
   begin
      
      Dialog:= Gtk_File_Chooser_Dialog_New
	(Title => "Select MAST Input File",
	 Parent => Mast_Analysis, 
	 Action => Action_Open);
      W1:=Dialog.Add_Button
	(Text        => Gtk.Stock.Stock_Cancel, 
	 Response_Id => Gtk.Dialog.Gtk_Response_Cancel);
      W2:=Dialog.Add_Button
	(Text        => Gtk.Stock.Stock_OK, 
	 Response_Id => Gtk.Dialog.Gtk_Response_Accept);
      
      Dir_Name:=To_Unbounded_String(Get_Text(Mast_Analysis.Directory_Entry));
      if Dir_Name/=To_Unbounded_String("") then
	 Success:=Set_Current_Folder
	   (Dialog, To_String(Dir_Name));
      else
	 Success:=Set_Current_Folder
	   (Dialog, 
	    Ada.Directories.Current_Directory);	 
      end if;
      
      if Dialog.Run = Gtk.Dialog.Gtk_Response_Accept then
	 declare
	    Full_Input_Filename : String := Dialog.Get_Filename;
	 begin      
	    if Full_Input_Filename/="" then
	       Pos_Slash:=Find_Pos_Last_Char('/',Full_Input_Filename);
	       if Pos_Slash=0 then
		  Pos_Slash:=Find_Pos_Last_Char('\',Full_Input_Filename);
	       end if;
	       if Pos_Slash=0 then
		  Set_Text(Mast_Analysis.Directory_Entry,"");
		  Set_Text(Mast_Analysis.Input_File,Full_Input_Filename);
	       else
		  Set_Text(Mast_Analysis.Directory_Entry,
			   Full_Input_Filename(1..Pos_Slash));
		  Set_Text(Mast_Analysis.Input_File,
			   Full_Input_Filename(Pos_Slash+1..
						 Full_Input_Filename'Length));
	       end if;
	       Set_Text(Mast_Analysis.Output_File,"");
	    end if;
	 end;
      end if;
      Dialog.Destroy;
   end On_Input_File_Selection_Clicked;

   ---------------------------
   -- On_Tool_Entry_Changed --
   ---------------------------

   procedure On_Tool_Entry_Changed
     (Object : access Gtk_Combo_Box_Text_Record'Class)
   is
   begin
      if Get_Text(Mast_Analysis.Output_File)="" or else
        Get_Active_Text(Mast_Analysis.Tool)="Parse"
      then
         Set_Active(Mast_Analysis.View_Results,False);
         Set_Sensitive(Mast_Analysis.View_Results,False);
      else
         Set_Sensitive(Mast_Analysis.View_Results,True);
         Set_Active(Mast_Analysis.View_Results,True);
      end if;
   end On_Tool_Entry_Changed;

   -------------------------
   -- On_Ceilings_Toggled --
   -------------------------

   procedure On_Ceilings_Toggled
     (Object : access Gtk_Check_Button_Record'Class)
   is
   begin
      if not Get_Active(Object) and then Get_Active(Mast_Analysis.Priorities)
      then
          Set_Active(Object,True);
      end if;
   end On_Ceilings_Toggled;

   ---------------------------
   -- On_Priorities_Toggled --
   ---------------------------

   procedure On_Priorities_Toggled
     (Object : access Gtk_Check_Button_Record'Class)
   is
   begin
      if Get_Active(Object) then
         Set_Active(Mast_Analysis.Ceilings,True);
         if Get_Active_Text(Mast_Analysis.Prio_Assign_Technique)="" then
            Set_Active(Mast_Analysis.Prio_Assign_Technique,1);
         end if;
      else
         Set_Active(Mast_Analysis.Prio_Assign_Technique,0);
      end if;
   end On_Priorities_Toggled;

   -----------------------------------
   -- On_Stop_Factor_Button_Toggled --
   -----------------------------------

   procedure On_Stop_Factor_Button_Toggled
     (Object : access Gtk_Check_Button_Record'Class)
   is
   begin
      if Get_Active(Object) and then
        Get_Text(Mast_Analysis.Stop_Factor_Entry)=""
      then
         Set_Text(Mast_Analysis.Stop_Factor_Entry,"10");
      end if;
   end On_Stop_Factor_Button_Toggled;

   --------------------------------
   -- On_Technique_Entry_Changed --
   --------------------------------

   procedure On_Technique_Entry_Changed
     (Object : access Gtk_Combo_Box_Text_Record'Class)
   is
   begin
      if Get_Active_Text(Mast_Analysis.Prio_Assign_Technique)/="" then
         Set_Active(Mast_Analysis.Priorities,True);
      else
         Set_Active(Mast_Analysis.Priorities,False);
      end if;
   exception
      when Constraint_Error => null;
   end On_Technique_Entry_Changed;

   ---------------------------------
   -- On_Destination_File_Changed --
   ---------------------------------

   procedure On_Destination_File_Changed
     (Object : access Gtk_Entry_Record'Class)
   is
   begin
      Set_Active(Mast_Analysis.Destination,True);
   exception
      when Constraint_Error => null;
   end On_Destination_File_Changed;

   ----------------------------------
   -- On_Stop_Factor_Entry_Changed --
   ----------------------------------

   procedure On_Stop_Factor_Entry_Changed
     (Object : access Gtk_Entry_Record'Class)
   is
   begin
      Set_Active(Mast_Analysis.Stop_Factor_Button,True);
   exception
      when Constraint_Error => null;
   end On_Stop_Factor_Entry_Changed;

   -------------------------------
   -- On_Operation_Name_Changed --
   -------------------------------

   procedure On_Operation_Name_Changed
     (Object : access Gtk_Entry_Record'Class)
   is
   begin
      Set_Active(Mast_Analysis.Operation_Slack,True);
   exception
      when Constraint_Error => null;
   end On_Operation_Name_Changed;

   --------------------------
   -- On_Go_Button_Clicked --
   --------------------------

   procedure On_Go_Button_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
      Command_File,Results_File : File_Type;
      Command_String : Var_String:=To_Var_String("mast_analysis ");
      Results_String : Var_String;
      View_Results : Boolean:=False;
      Technique, Destination, Op_Name, Input_File, Output_File : Var_String;
      Parent : Gtk_Widget :=Get_Toplevel(Object);
      Factor : Positive;
      Empty_Destination,Empty_Input,Invalid_Op_Name,Same_Name,
        Invalid_Number: exception;


      function Has_Spaces(Line : Var_String)
              return Boolean is
      begin
         for i in 1..Length(Line) loop
            if Element(Line,i)=' ' then
               return true;
            end if;
         end loop;
         return false;
      end Has_Spaces;

   begin
      Create(Command_File,Out_File,"mast_command");
      Create(Results_File,Out_File,"mast_results_command");
      -- tool
      Command_String:=Command_String&
                      To_Lower(To_Var_String(
                       Get_Active_Text(Mast_Analysis.Tool)))&' ';
      -- options
      if Get_Active(Mast_Analysis.Verbose) then
         Command_String:=Command_String&"-v ";
      end if;
      if Get_Active(Mast_Analysis.Local_EDF) then
         Command_String:=Command_String&"-l ";
      end if;
      if Get_Active(Mast_Analysis.Ceilings) then
         Command_String:=Command_String&"-c ";
      end if;
      if Get_Active(Mast_Analysis.Priorities) then
         Command_String:=Command_String&"-p ";
         Technique:=To_Lower
           (To_Var_String(Get_Active_Text
                          (Mast_Analysis.Prio_Assign_Technique)));
         if Technique/=To_Var_String("default") and then
           Technique/=To_Var_String("")
         then
              Command_String:=Command_String&"-t "&Technique&' ';
         end if;
      end if;
      if Get_Active(Mast_Analysis.Stop_Factor_Button) then
         begin
            Factor:=Positive'Value(Get_Text(Mast_Analysis.Stop_Factor_Entry));
         exception
            when others =>
               raise Invalid_Number;
         end;
         Command_String:=Command_String&"-f"&Positive'Image(Factor)&" ";
      end if;
      if Get_Active(Mast_Analysis.Operation_Slack) then
         Op_Name:=To_Lower
           (To_Var_String(Get_Text(Mast_Analysis.Operation_Name)));
         if Op_Name=Null_Var_String or else Has_Spaces(Op_Name) then
              raise Invalid_Op_Name;
         end if;
         Command_String:=Command_String&"-os "&
                         Op_Name&' ';
      end if;
      if Get_Active(Mast_Analysis.Destination) then
         Destination:=To_Var_String
           (Check_Spaces(Get_Text(Mast_Analysis.Directory_Entry)&
              Get_Text(Mast_Analysis.Destination_File)));
         if Get_Text(Mast_Analysis.Destination_File)="" then
              raise Empty_Destination;
         end if;
         Command_String:=Command_String&"-d "&
                         Destination&' ';
      end if;
      if Get_Active(Mast_Analysis.Slacks) then
         Command_String:=Command_String&"-s ";
      end if;

      -- files
      if Get_Text(Mast_Analysis.Input_File)="" then
         raise Empty_Input;
      end if;
      Input_File:=To_Var_String
        (Check_Spaces(Get_Text(Mast_Analysis.Directory_Entry)&
                      Get_Text(Mast_Analysis.Input_File)));
      Command_String:=Command_String&Input_File&' ';
      if Get_Text(Mast_Analysis.Output_File)/="" then
         Output_File:=To_Var_String
           (Check_Spaces(Get_Text(Mast_Analysis.Directory_Entry)&
                         Get_Text(Mast_Analysis.Output_File)));
         Command_String:=Command_String&Output_File;
         if Get_Active(Mast_Analysis.View_Results) then
            if Input_File=Output_File then
               raise Same_Name;
            end if;
            View_Results:=True;
            Results_String:=To_Var_String("gmastresults ")&
              Input_File&" "&Output_File;
         end if;
      end if;
      Put_Line(Command_File,Command_String);
      if View_Results then
         Put_Line(Results_File,Results_String);
      end if;
      Close(Command_File);
      Close(Results_File);
      Gtk.Main.Main_Quit;
   exception
      when Empty_Destination =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,"Empty Destination File");
         Set_Modal(Error_Window,True);
         Close(Command_File);
         Close(Results_File);
      when Invalid_Op_Name =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,"Empty or Invalid Operation Name");
         Set_Modal(Error_Window,True);
         Close(Command_File);
         Close(Results_File);
      when Empty_Input =>
         Gtk_New (Error_InputFile);
         Set_Position(Error_InputFile,Win_Pos_Mouse);
         Show_All (Error_InputFile);
         Set_Modal(Error_InputFile,True);
         Close(Command_File);
         Close(Results_File);
      when Same_Name =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "Results file cannot be the same as input file");
         Set_Modal(Error_Window,True);
         Close(Command_File);
         Close(Results_File);
      when Invalid_Number =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "Invalid number for Stop Factor");
         Set_Modal(Error_Window,True);
         Close(Command_File);
         Close(Results_File);
   end On_Go_Button_Clicked;

   -----------------------
   -- On_Cancel_Clicked --
   -----------------------

   procedure On_Cancel_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Ada.Command_Line.Set_Exit_Status(Ada.Command_Line.Failure);
      Gtk.Main.Main_Quit;
   end On_Cancel_Clicked;

   ----------------------------
   -- On_Hopa_Params_Clicked --
   ----------------------------

   procedure On_Hopa_Params_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Gtk_New (HOPA_Window);
      Set_Position(HOPA_Window,Win_Pos_Mouse);
      Show_All (HOPA_Window);
      Set_Modal(HOPA_Window,True);
      begin
         Mast.Hospa_Parameters.Load_Parameters;
      exception
         when Mast.Tool_Exceptions.Invalid_Format =>
            null;
      end;
      Parameters_Handling.Load_Hospa;
   end On_Hopa_Params_Clicked;

   ---------------------------------
   -- On_Annealing_Params_Clicked --
   ---------------------------------

   procedure On_Annealing_Params_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Gtk_New (Annealing_Window);
      Set_Position(Annealing_Window,Win_Pos_Mouse);
      Show_All (Annealing_Window);
      Set_Modal(Annealing_Window,True);
      begin
         Mast.Annealing_Parameters.Load_Parameters;
      exception
         when Mast.Tool_Exceptions.Invalid_Format =>
            null;
      end;
      Parameters_Handling.Load_Annealing;
   end On_Annealing_Params_Clicked;

   ----------------------------
   -- On_Help_Button_Clicked --
   ----------------------------

   procedure On_Help_Button_Clicked
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Gtk_New (Help);
      Show_All (Help);
      Set_Modal(Help,True);
   end On_Help_Button_Clicked;

end Mast_Analysis_Pkg.Callbacks;
