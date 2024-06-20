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

with System; use System;
with Glib; use Glib;
with Gdk.Event; use Gdk.Event;
with Gdk.Types; use Gdk.Types;
with Gtk.Accel_Group; use Gtk.Accel_Group;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Style; use Gtk.Style;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Dialog;           use Gtk.Dialog;
with Gtk.File_Chooser; use Gtk.File_Chooser;
with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;
with Gtk.Label; use Gtk.Label;
with Gtk.Main;
with Gtk.Tree_Store; use Gtk.Tree_Store;
with Gtk.Tree_Model; use Gtk.Tree_Model;
with Gtk.Tree_View; use Gtk.Tree_View;
with Gtk.Tree_View_Column; use Gtk.Tree_View_Column;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;
with Filechooserdialog1_Pkg; use Filechooserdialog1_Pkg;
with Dialog1_Pkg; use Dialog1_Pkg;
with Usage_Dialog_Pkg; use Usage_Dialog_Pkg;
with Dialog_Yes_No_Pkg; use Dialog_Yes_No_Pkg;
with Dialog_3_Pkg; use Dialog_3_Pkg;

with Task_Table;
with Mutex_Table;
with Usage_Table;
with Results_Table;
with Check_Operations;
with Changes_Control;
with File_Operations;
with Global_Options;
with Model_Operations;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;
with Ada.Directories; use Ada.Directories;
with Ada.Calendar;
with Ada.Directories;

package body Pt_Editor_Pkg.Callbacks is

   use Gtk.Arguments;
   use type Ada.Calendar.Time;

   -------------------------------
   -- On_New_Menuitem1_Activate --
   -------------------------------

   procedure On_New_Menuitem1_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Response : Response_3_Type;
   begin
      if Changes_Control.Changes_Made_Since_Last_Save then
         Run_Dialog("Changes were made. Save  Changes?","Save","Discard",
                    "Cancel",Response);
         case Response is
            when Response_Button1 => --Save
               On_Save_Menuitem3_Activate(Object);
            when Response_Button2 => -- Discard
               null;
            when Response_Button3 => -- Cancel
               return;
         end case;
      end if;
      -- Reset all data
      Task_Table.Initialize;
      Mutex_Table.Initialize;
      Usage_Table.Initialize;
      Results_Table.Initialize;
      Global_Options.Initialize;
      Changes_Control.Reset;
      Model_Operations.Clear_Model;
   end On_New_Menuitem1_Activate;

   --------------------------------
   -- On_Open_Menuitem2_Activate --
   --------------------------------

   procedure On_Open_Menuitem2_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Response : Response_3_Type;
      File_Response : Gtk_Response_Type;
      Success : Boolean;
   begin
      if Changes_Control.Changes_Made_Since_Last_Save then
         Run_Dialog("Changes were made. Save  changes before open?",
                    "Save","Discard","Cancel",Response);
         case Response is
            when Response_Button1 => --Save
               On_Save_Menuitem3_Activate(Object);
            when Response_Button2 => -- Discard
               null;
            when Response_Button3 => -- Cancel
               return;
         end case;
      end if;
      Set_Title(Filechooserdialog1_Pkg.Filechooserdialog1,"Open...");
      Set_Label(Filechooserdialog1_Pkg.Filechooserdialog1.Fileselection_Ok,
                "Open");
      Set_Action(+Filechooserdialog1_Pkg.Filechooserdialog1,Action_Open);
      if Global_Options.Get_System_Name/="" then
	 Success:=Set_Current_Folder
	   (Filechooserdialog1_Pkg.Filechooserdialog1, 
	    Ada.Directories.Containing_Directory
	      (Global_Options.Get_System_Name));
      else
	 Success:=Set_Current_Folder
	   (Filechooserdialog1_Pkg.Filechooserdialog1, 
	    Ada.Directories.Current_Directory);	 
      end if;
      
      Show_All(Filechooserdialog1_Pkg.Filechooserdialog1);
      File_Response:=Run (Filechooserdialog1_Pkg.Filechooserdialog1);
      if File_Response= Gtk_Response_OK or else File_Response=0 then
         declare
            Filename : String:=
              File_Operations.Get_Complete_Filename
              (Get_Filename(+Filechooserdialog1_Pkg.Filechooserdialog1));
         begin
            File_Operations.Read(Filename);
            Changes_Control.Reset;
            Global_Options.Set_System_Name(Filename);
            Usage_Table.Set_Buttons;
         end;
      end if;
      Hide(Filechooserdialog1_Pkg.Filechooserdialog1);

   end On_Open_Menuitem2_Activate;

   ---------------------------
   -- Model should be saved --
   ---------------------------
   function Model_Should_Be_Saved (Name : String) return Boolean
   is
      Model_Name : String:=Name(Name'First..Name'Last-4)&"_mast.txt";
      Response_Is_Overwrite : Boolean;

   begin
      if Exists(Model_Name) then
         if Exists(Name) then
            if Modification_Time(Model_Name)>Modification_Time(Name)+2.0
            then
               Run_Dialog("Model file "&Model_Name&
                            " has been modified since it was last saved",
                          "Overwrite","Cancel Save Operation",
                          Response_Is_Overwrite);
               return Response_Is_Overwrite;
            else
               return True;
            end if;
         else
            Run_Dialog("Model file "&Model_Name&" Exists",
                       "Overwrite","Discard", Response_Is_Overwrite);
            return Response_Is_Overwrite;
         end if;
      end if;
      return True;
   end Model_Should_Be_Saved;


   --------------------------------
   -- On_Save_Menuitem3_Activate --
   --------------------------------

   procedure On_Save_Menuitem3_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
   begin
      if Global_Options.Is_System_Name_Defined then
         File_Operations.Write(Global_Options.Get_System_Name);
         Put_Line("Periodic Tasks Saved to "&Global_Options.Get_System_Name);
         if Model_Should_Be_Saved(Global_Options.Get_System_Name) then
            Changes_Control.Save_Operation_Made;
            Model_Operations.Save_Model;
            declare
               Name : String:=Global_Options.Get_System_Name;
               Model_Name : String:=Name(Name'First..Name'Last-4)&"_mast.txt";
            begin
               Put_Line("MAST Model Saved to "&Model_Name);
            end;
         end if;
      else
         On_Save_As_Menuitem4_Activate(Object);
      end if;
   end On_Save_Menuitem3_Activate;

   -----------------------------------
   -- On_Save_As_Menuitem4_Activate --
   -----------------------------------

   procedure On_Save_As_Menuitem4_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Response : Gtk_Response_Type;
      Success : Boolean;
   begin
      Set_Title(Filechooserdialog1_Pkg.Filechooserdialog1,"Save as...");
      Set_Label(Filechooserdialog1_Pkg.Filechooserdialog1.Fileselection_Ok,
                "Save");
      Set_Action(+Filechooserdialog1_Pkg.Filechooserdialog1,Action_Save);
      if Global_Options.Get_System_Name/="" then
	 Success:=Set_Current_Folder
	   (Filechooserdialog1_Pkg.Filechooserdialog1, 
	    Ada.Directories.Containing_Directory
	      (Global_Options.Get_System_Name));
	 Set_Current_Name
	   (Filechooserdialog1_Pkg.Filechooserdialog1, 
	    Ada.Directories.Simple_Name(Global_Options.Get_System_Name));
      else
	 Success:=Set_Current_Folder
	   (Filechooserdialog1_Pkg.Filechooserdialog1, 
	    Ada.Directories.Current_Directory);	 
      end if;
      Show_All(Filechooserdialog1_Pkg.Filechooserdialog1);
      -- loop until we exit the dialog
      loop
         Response:= Run (Filechooserdialog1_Pkg.Filechooserdialog1);
         if Response/= Gtk_Response_OK and then Response/=0
         then
            exit;
         else
            declare
               File_Should_Be_Saved : Boolean:=False;
               Filename : String:=
                 Trim(Get_Filename
                        (+Filechooserdialog1_Pkg.Filechooserdialog1),Both);
            begin
               if Filename="" then
                  null; -- nothing to do, retry dialog
               else
                  -- Check whether file exists or not
                  if Exists(File_Operations.Get_Complete_Filename(Filename))
                  then
                     Run_Dialog("File exists. Overwrite?",File_Should_Be_Saved);
                  else
                     File_Should_Be_Saved:=True;
                  end if;
               end if;
               if File_Should_Be_Saved then
                  Global_Options.Set_System_Name
                    (File_Operations.Get_Complete_Filename
                       (Get_Filename
                          (+Filechooserdialog1_Pkg.Filechooserdialog1)));
                  File_Operations.Write(Global_Options.Get_System_Name);
                  Put_Line("Periodic Tasks Saved to "&
                                Global_Options.Get_System_Name);
                  if Model_Should_Be_Saved(Global_Options.Get_System_Name)
                  then
                     Changes_Control.Save_Operation_Made;
                     Model_Operations.Save_Model;
                     declare
                        Name : String:=Global_Options.Get_System_Name;
                        Model_Name : String:=
                          Name(Name'First..Name'Last-4)&"_mast.txt";
                     begin
                        Put_Line("MAST Model Saved to "&Model_Name);
                     end;
                  end if;
                  exit;
               end if;
            end;
         end if;
      end loop;
      Hide(Filechooserdialog1_Pkg.Filechooserdialog1);
   end On_Save_As_Menuitem4_Activate;

   --------------------------------
   -- On_Quit_Menuitem5_Activate --
   --------------------------------

   procedure On_Quit_Menuitem5_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Response : Response_3_Type;
   begin
      if Changes_Control.Changes_Made_Since_Last_Save then
         Run_Dialog("Changes were made. Save  Changes?","Save","Discard",
                    "Cancel",Response);
         case Response is
            when Response_Button1 => --Save
               On_Save_Menuitem3_Activate(Object);
            when Response_Button2 => -- Discard
               null;
            when Response_Button3 => -- Cancel
               return;
         end case;
      end if;
      -- exit application
      Gtk.Main.Main_Quit;
   end On_Quit_Menuitem5_Activate;

   ----------------------------------
   -- On_About_Menuitem10_Activate --
   ----------------------------------

   procedure On_About_Menuitem10_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
   begin
      Gtk_New (Aboutdialog1);
      -- Wait until dialog is closed
      if Run (Aboutdialog1) /= Gtk_Response_Close then
         --  Dialog was destroyed by user
         null;
      end if;
      Destroy (Aboutdialog1);

   end On_About_Menuitem10_Activate;

   ---------------------------------------
   -- On_Fixed_Prio_Radiobutton_Toggled --
   ---------------------------------------

   procedure On_Fixed_Prio_Radiobutton_Toggled
     (Object : access Gtk_Radio_Button_Record'Class)
   is
      Col      : Gtk_Tree_View_Column;
   begin
      Col:=Get_Column
        (Pt_Editor_Pkg.Pt_Editor.Task_Treeview,Task_Table.Prio_Col);
      Set_Title (Col, "Priority");
      Col:=Get_Column
        (Pt_Editor_Pkg.Pt_Editor.Mutex_Treeview,Mutex_Table.Prio_Col);
      Set_Title (Col, "Priority Ceiling");
      Changes_Control.Change_Was_Made;
   end On_Fixed_Prio_Radiobutton_Toggled;

   --------------------------------
   -- On_Edf_Radiobutton_Toggled --
   --------------------------------

   procedure On_Edf_Radiobutton_Toggled
     (Object : access Gtk_Radio_Button_Record'Class)
   is
      Col      : Gtk_Tree_View_Column;
   begin
      Col:=Get_Column
        (Pt_Editor_Pkg.Pt_Editor.Task_Treeview,Task_Table.Prio_Col);
      Set_Title (Col, "Preemption Level");
      Col:=Get_Column
        (Pt_Editor_Pkg.Pt_Editor.Mutex_Treeview,Mutex_Table.Prio_Col);
      Set_Title (Col, "Preemption Level");
      Changes_Control.Change_Was_Made;
   end On_Edf_Radiobutton_Toggled;

   -----------------------------------------
   -- On_Cswitch_Spinbutton_Value_Changed --
   -----------------------------------------

   procedure On_Cswitch_Spinbutton_Value_Changed
     (Object : access Gtk_Spin_Button_Record'Class)
   is
   begin
      Changes_Control.Change_Was_Made;
   end On_Cswitch_Spinbutton_Value_Changed;

   ----------------------------------------
   -- On_Ticker_Spinbutton_Value_Changed --
   ----------------------------------------

   procedure On_Ticker_Spinbutton_Value_Changed
     (Object : access Gtk_Spin_Button_Record'Class)
   is
   begin
      Changes_Control.Change_Was_Made;
   end On_Ticker_Spinbutton_Value_Changed;

   --------------------------------------
   -- On_Task_Treeview_Columns_Changed --
   --------------------------------------

   procedure On_Task_Treeview_Columns_Changed
     (Object : access Gtk_Tree_View_Record'Class)
   is
   begin
      null;
   end On_Task_Treeview_Columns_Changed;

   --------------------------------
   -- On_Add_Task_Button_Pressed --
   --------------------------------

   procedure On_Add_Task_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Task_Table.Add_New_Task("0.0","0.0","0.0","1");
      Changes_Control.Change_Was_Made;
      if Mutex_Table.Num_Mutexes>0 then
         Set_Sensitive(Pt_Editor.Add_Usage_Button,True);
      end if;
   end On_Add_Task_Button_Pressed;

   -----------------------------------
   -- On_Delete_Task_Button_Pressed --
   -----------------------------------

   procedure On_Delete_Task_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
      Deleted : Boolean;
   begin
      if Usage_Table.Task_Is_In_Use(Task_Table.Selected_Task_Name) then
         Run_Dialog("Error: Task "&Task_Table.Selected_Task_Name&
                      " is in use");
      else
         Task_Table.Delete_Selected_Task(Deleted);
         if Deleted then
            Changes_Control.Change_Was_Made;
            if Task_Table.Num_Tasks=0 then
               Set_Sensitive(Pt_Editor.Add_Usage_Button,False);
            end if;
         end if;
      end if;
   end On_Delete_Task_Button_Pressed;

   -----------------------------------
   -- On_Assign_Prio_Button_Pressed --
   -----------------------------------

   procedure On_Assign_Prio_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Model_Operations.Assign_Parameters;
   end On_Assign_Prio_Button_Pressed;

   ---------------------------------
   -- On_Add_Mutex_Button_Pressed --
   ---------------------------------

   procedure On_Add_Mutex_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Mutex_Table.Add_New_Mutex("1");
      Changes_Control.Change_Was_Made;
      if Task_Table.Num_Tasks>0 then
         Set_Sensitive(Pt_Editor.Add_Usage_Button,True);
      end if;
   end On_Add_Mutex_Button_Pressed;

   ------------------------------------
   -- On_Delete_Mutex_Button_Pressed --
   ------------------------------------

   procedure On_Delete_Mutex_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
      Deleted : Boolean;
   begin
      if Usage_Table.Mutex_Is_In_Use(Mutex_Table.Selected_Mutex_Name) then
         Run_Dialog("Error: Mutex "&Mutex_Table.Selected_Mutex_Name&
                      " is in use");
      else
         Mutex_Table.Delete_Selected_Mutex(Deleted);
         if Deleted then
            Changes_Control.Change_Was_Made;
            if Mutex_Table.Num_Mutexes=0 then
               Set_Sensitive(Pt_Editor.Add_Usage_Button,False);
            end if;
         end if;
      end if;
   end On_Delete_Mutex_Button_Pressed;

   ---------------------------------------
   -- On_Assign_Ceilings_Button_Pressed --
   ---------------------------------------

   procedure On_Assign_Ceilings_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Model_Operations.Assign_Ceilings;
   end On_Assign_Ceilings_Button_Pressed;

   ---------------------------------
   -- On_Add_Usage_Button_Pressed --
   ---------------------------------

   procedure On_Add_Usage_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
      Response : Gtk_Response_Type;
   begin
      -- set the task names
      Task_Table.Fill_Task_Names
        (Usage_Dialog_Pkg.Usage_Dialog.Taskname_Combobox);
      -- set the mutex names
      Mutex_Table.Fill_Mutex_Names
        (Usage_Dialog_Pkg.Usage_Dialog.Mutexname_Combobox);
      -- set the operation name
      loop
         declare
            Num : String:=Integer'Image(Usage_Table.Get_Last_Usage+1);
         begin
            if Usage_Table.Usage_Name_Is_In_Use
              ("Op"&Num(Num'First+1..Num'Last)) then
               Usage_Table.Increase_Last_Usage;
            else
               Set_Text(Usage_Dialog.Operation_Entry,
                        "Op"&Num(Num'First+1..Num'Last));
               exit;
            end if;
         end;
      end loop;
      --set the WCET value
      Set_Text(Usage_Dialog.Wcet_Entry,"0.0");

      Show_All (Usage_Dialog_Pkg.Usage_Dialog);
      -- Wait until dialog is closed
      loop
         Response:=Run (Usage_Dialog_Pkg.Usage_Dialog);
         if Response = Gtk_Response_OK then
            if N_Children
              (Get_Model(Usage_Dialog_Pkg.Usage_Dialog.Taskname_Combobox))>0
              and then N_Children
              (Get_Model(Usage_Dialog_Pkg.Usage_Dialog.Mutexname_Combobox))>0
            then
               declare
                  Name : String:=
                    Get_Text(Usage_Dialog_Pkg.Usage_Dialog.Operation_Entry);
                  Taskname : String:= Get_Active_Text
                    (Usage_Dialog_Pkg.Usage_Dialog.Taskname_Combobox);
                  Mutexname : String:= Get_Active_Text
                    (Usage_Dialog_Pkg.Usage_Dialog.Mutexname_Combobox);
                  WCET : String:=
                    Get_Text(Usage_Dialog_Pkg.Usage_Dialog.WCET_Entry);
               begin
                  if Check_Operations.Is_Correct_Identifier(Name) then
                     if Check_Operations.Is_Correct_Time(WCET) then
                        if Usage_Table.Usage_Name_Is_In_Use(Name) or else
                          Task_Table.Task_Name_Is_In_Use(Name)
                        then
                           Run_Dialog("Error: Operation name is not unique");
                        else
                           Usage_Table.Add_New_Usage
                             (Name,Taskname,Mutexname,WCET);
                           Changes_Control.Change_Was_Made;
                           exit;
                        end if;
                     else
                        Run_Dialog("WCET is not a correct time value");
                     end if;
                  else
                     Run_Dialog("Operation name is not a correct identifier");
                  end if;
               end;
            else
               Run_Dialog("There are no Tasks or Mutexes");
               exit;
            end if;
         elsif Response = Gtk_Response_Cancel then
            exit; --"Dialog was destroyed by user"
         else
            null; -- there was an error, so we retry
         end if;
      end loop;
      Hide (Usage_Dialog_Pkg.Usage_Dialog);

   end On_Add_Usage_Button_Pressed;

   ------------------------------------
   -- On_Delete_Usage_Button_Pressed --
   ------------------------------------

   procedure On_Delete_Usage_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
      Deleted : Boolean;
   begin
      Usage_Table.Delete_Selected_Usage(Deleted);
      if Deleted then
         Changes_Control.Change_Was_Made;
      end if;
   end On_Delete_Usage_Button_Pressed;

   -------------------------------------
   -- On_Assign_Params_Button_Pressed --
   -------------------------------------

   procedure On_Assign_Params_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Model_Operations.Assign_Parameters;
      Put_Line("Assigned Priorities and Ceilings/Levels");
   end On_Assign_Params_Button_Pressed;

   -----------------------------------
   -- On_Do_Analysis_Button_Pressed --
   -----------------------------------

   procedure On_Do_Analysis_Button_Pressed
     (Object : access Gtk_Button_Record'Class)
   is
   begin
      Model_Operations.Do_Analysis;
   end On_Do_Analysis_Button_Pressed;

   -------------------------------
   -- On_Pt_Editor_Delete_Event --
   -------------------------------

   function On_Pt_Editor_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean
   is
      Arg1 : Gdk_Event := To_Event (Params, 1);
      Response : Response_3_Type;
   begin
      if Changes_Control.Changes_Made_Since_Last_Save then
         Run_Dialog("Changes were made. Save  Changes?","Save","Discard",
                    "Cancel",Response);
         case Response is
            when Response_Button1 => --Save
               On_Save_Menuitem3_Activate(Pt_Editor.Save_Menuitem3);
            when Response_Button2 => -- Discard
               null;
            when Response_Button3 => -- Cancel
               return True;
         end case;
      end if;
      -- exit application
      Gtk.Main.Main_Quit;
      return True;
   end On_Pt_Editor_Delete_Event;

   -------------------------------
   -- Text_Edited_Callback_Name --
   -------------------------------

   procedure Text_Edited_Callback_Name
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
        Get_Iter_From_String (M, Path_String);
      Row : Positive:=Integer'Value(Path_String)+1;
   begin
      if Check_Operations.Is_Correct_Identifier(Text_String) then
         if Task_Table.Task_Name_Is_Unique(Text_String,Row) then
            Set_Value (M, Iter, Task_Table.Name_Col, Text_Value);
            Changes_Control.Change_Was_Made;
         else
            Run_Dialog("Error: Task name is not unique");
         end if;
      else
         Run_Dialog("Error: Task name is not a correct identifier");
      end if;
   end Text_Edited_Callback_Name;

   -------------------------------
   -- Mutex_Edited_Callback_Name --
   -------------------------------

   procedure Mutex_Edited_Callback_Name
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
        Get_Iter_From_String (M, Path_String);
      Row : Positive:=Integer'Value(Path_String)+1;
   begin
      if Check_Operations.Is_Correct_Identifier(Text_String) then
         if Mutex_Table.Mutex_Name_Is_Unique(Text_String,Row) then
            Set_Value (M, Iter, Mutex_Table.Name_Col, Text_Value);
            Changes_Control.Change_Was_Made;
         else
            Run_Dialog("Error: Mutex name is not unique");
         end if;
      else
         Run_Dialog("Error: Mutex name is not a correct identifier");
      end if;
   end Mutex_Edited_Callback_Name;

   --------------------------------
   -- Usage_Edited_Callback_Name --
   --------------------------------

   procedure Usage_Edited_Callback_Name
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
        Get_Iter_From_String (M, Path_String);
      Row : Positive:=Integer'Value(Path_String)+1;
   begin
      if Check_Operations.Is_Correct_Identifier(Text_String) then
         if Usage_Table.Usage_Name_Is_Unique(Text_String,Row) then
            Set_Value (M, Iter, Usage_Table.Name_Col, Text_Value);
            Changes_Control.Change_Was_Made;
         else
            Run_Dialog("Error: Operation name is not unique");
         end if;
      else
         Run_Dialog("Error: Operation name is not a correct identifier");
      end if;
   end Usage_Edited_Callback_Name;

   -------------------------------
   -- Text_Edited_Callback_C --
   -------------------------------

   procedure Text_Edited_Callback_C
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
                      Get_Iter_From_String (M, Path_String);
   begin
      if Check_Operations.Is_Correct_Time(Text_String) then
         Set_Value (M, Iter, Task_Table.C_Col, Text_Value);
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("Error: Incorrect time value");
      end if;
   end Text_Edited_Callback_C;

   --------------------------------
   -- Usage_Edited_Callback_WCET --
   --------------------------------

   procedure Usage_Edited_Callback_WCET
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
                      Get_Iter_From_String (M, Path_String);
   begin
      if Check_Operations.Is_Correct_Time(Text_String) then
         Set_Value (M, Iter, Usage_Table.WCET_Col, Text_Value);
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("Error: Incorrect time value");
      end if;
   end Usage_Edited_Callback_WCET;

   -------------------------------
   -- Text_Edited_Callback_T --
   -------------------------------

   procedure Text_Edited_Callback_T
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
                      Get_Iter_From_String (M, Path_String);
   begin
      if Check_Operations.Is_Correct_Time(Text_String) then
         Set_Value (M, Iter, Task_Table.T_Col, Text_Value);
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("Error: Incorrect time value");
      end if;
   end Text_Edited_Callback_T;

   -------------------------------
   -- Text_Edited_Callback_D --
   -------------------------------

   procedure Text_Edited_Callback_D
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
                      Get_Iter_From_String (M, Path_String);
   begin
      if Check_Operations.Is_Correct_Time(Text_String) then
         Set_Value (M, Iter, Task_Table.D_Col, Text_Value);
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("Error: Incorrect time value");
      end if;
   end Text_Edited_Callback_D;

   -------------------------------
   -- Text_Edited_Callback_Prio --
   -------------------------------

   procedure Text_Edited_Callback_Prio
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
                      Get_Iter_From_String (M, Path_String);
   begin
      if Check_Operations.Is_Correct_Prio(Text_String) then
         Set_Value (M, Iter, Task_Table.Prio_Col, Text_Value);
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("Error: Incorrect priority or preemption level value");
      end if;
   end Text_Edited_Callback_Prio;

   -------------------------------
   -- Mutex_Edited_Callback_Prio --
   -------------------------------

   procedure Mutex_Edited_Callback_Prio
     (Model  : access GObject_Record'Class;
      Params : Glib.Values.GValues)
   is
      M           : constant Gtk_Tree_Store := Gtk_Tree_Store (Model);
      Path_String : constant String := Get_String (Nth (Params, 1));
      Text_Value  : constant GValue := Nth (Params, 2);
      Text_String  : constant string := Get_String (Nth (Params, 2));
      Iter        : constant Gtk_Tree_Iter :=
                      Get_Iter_From_String (M, Path_String);
   begin
      if Check_Operations.Is_Correct_Prio(Text_String) then
         Set_Value (M, Iter, Mutex_Table.Prio_Col, Text_Value);
         Changes_Control.Change_Was_Made;
      else
         Run_Dialog("Error: Incorrect priority or preemption level value");
      end if;
   end Mutex_Edited_Callback_Prio;

end Pt_Editor_Pkg.Callbacks;
