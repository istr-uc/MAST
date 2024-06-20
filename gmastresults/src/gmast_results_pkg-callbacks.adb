-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2000-2014                     --
--                 Universidad de Cantabria, SPAIN                   --
--                                                                   --
-- Authors: Michael Gonzalez       mgh@unican.es                     --
--          Jose Javier Gutierrez  gutierjj@unican.es                --
--          Jose Carlos Palencia   palencij@unican.es                --
--          Jose Maria Drake       drakej@unican.es                  --
--          Yago Pereiro                                             --
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
with Gtk.Main;
with Gtk.Stock;
with Mast_Actions;
with Mast.Transactions;
with Gtkada.File_Selection; use Gtkada.File_Selection;
with Gtk.File_Chooser_Dialog; use Gtk.File_Chooser_Dialog;
with Gtk.File_Chooser; use Gtk.File_Chooser;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Combo_Box_Text; use Gtk.Combo_Box_Text;
with Gtk.Tree_Store; use Gtk.Tree_Store;
with Gtk.Tree_Model; use Gtk.Tree_Model;
with Glib.Values;
with Error_Window_Pkg; use Error_Window_Pkg;
with Dialog_Event_Pkg; use Dialog_Event_Pkg;
with Draw_Results;
with Draw_Timing_Results;
with Clear_Timing_Results;
with Clear_Results;
with Resize_Timing_Results;
with Mast_Actions; use Mast_Actions;
with Mast_Parser_Error_Report;
with Mast_Results_Parser_Error_Report;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Directories;
with Var_Strings; use Var_Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body Gmast_Results_Pkg.Callbacks is

   use Gtk.Arguments;

   -----------------------------------
   -- On_Gmast_Results_Delete_Event --
   -----------------------------------

   function On_Gmast_Results_Delete_Event
     (Object : access Gtk_Widget_Record'Class;
      Params : Gtk.Arguments.Gtk_Args) return Boolean
   is
      Arg1 : Gdk_Event := To_Event (Params, 1);
   begin
      Gtk.Main.Main_Quit; -- Should return with an error indication
      return False;
   end On_Gmast_Results_Delete_Event;

   -----------------------------
   -- On_System_Open_Activate --
   -----------------------------

   procedure On_System_Open_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Name : Unbounded_String;
      Dialog : aliased Gtk_File_Chooser_Dialog;
      W1,w2 : Gtk_Widget;
      Success : Boolean;
   begin
      begin
	 Name:=To_Unbounded_String(Mast_Actions.Name_Of_System);
      exception
	 when No_System =>
	    Name:=To_Unbounded_String("");
      end;
      Dialog:= Gtk_File_Chooser_Dialog_New
	(Title => "System File",
	 Parent => Gmast_Results, 
	 Action => Action_Open);
      W1:=Dialog.Add_Button
	(Text        => Gtk.Stock.Stock_Cancel, 
	 Response_Id => Gtk.Dialog.Gtk_Response_Cancel);
      W2:=Dialog.Add_Button
	(Text        => Gtk.Stock.Stock_Open, 
	 Response_Id => Gtk.Dialog.Gtk_Response_Accept);
      
      if To_String(Name)/="" then
	 Success:=Set_Current_Folder
	   (Dialog, 
	    Ada.Directories.Containing_Directory(To_String(Name)));
      else
	 Success:=Set_Current_Folder
	   (Dialog, 
	    Ada.Directories.Current_Directory);	 
      end if;
	 
      if Dialog.Run = Gtk.Dialog.Gtk_Response_Accept then
	 declare
	    Filename : String := Dialog.Get_Filename;
	 begin
	    Mast_Actions.Read_System(Filename);
	    Clear_Results;
	    Set_Sensitive(Gmast_Results.System_Save_As,True);
	    Set_Sensitive(Gmast_Results.Results_Open,True);
	    Set_Text(Gmast_Results.Entry_Current_System,
		     To_String(The_System.Model_Name));
	    Set_Text(Gmast_Results.Entry_Model_Name,
		     To_String(The_System.Model_Name));
	    Set_Text(Gmast_Results.Entry_Model_Date,The_System.Model_Date);
	 exception
	    when Ada.Text_IO.Name_Error | Ada.Text_IO.Status_Error |
	      Ada.Text_IO.Use_Error =>
	       Gtk_New (Error_Window);
	       Set_Position(Error_Window,Win_Pos_Mouse);
	       Show_All (Error_Window);
	       Set_Text(Error_Window.Label_Error,"System File "&Filename&
			  " not found");
	       Set_Modal(Error_Window,True);
	 end;
      end if;
      Dialog.Destroy;
   exception
      when Mast_Parser_Error_Report.Syntax_Error =>
	 Gtk_New (Error_Window);
	 Set_Position(Error_Window,Win_Pos_Mouse);
	 Show_All (Error_Window);
	 Set_Text(Error_Window.Label_Error,
		  "Syntax Error. See mast_parser.lis");
	 Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.No_System =>
	 Gtk_New (Error_Window);
	 Set_Position(Error_Window,Win_Pos_Mouse);
	 Show_All (Error_Window);
	 Set_Text(Error_Window.Label_Error,
		  "No MAST system defined");
	 Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.Program_Not_Found =>
	 Gtk_New (Error_Window);
	 Set_Position(Error_Window,Win_Pos_Mouse);
	 Show_All (Error_Window);
	 Set_Text(Error_Window.Label_Error,
		  "mast_xml_convert program not found");
	 Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.Xml_Convert_Error =>
	 Gtk_New (Error_Window);
	 Set_Position(Error_Window,Win_Pos_Mouse);
	 Show_All (Error_Window);
	 Set_Text(Error_Window.Label_Error,
		  "Error detected while converting system from "&
		    "XML to text format");
	 Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Constraint_Error =>
	 Gtk_New (Error_Window);
	 Set_Position(Error_Window,Win_Pos_Mouse);
	 Show_All (Error_Window);
	 Set_Text(Error_Window.Label_Error,
		  "Input file has unrecognizable format");
	 Set_Modal(Error_Window,True);
	 Dialog.Destroy;
   end On_System_Open_Activate;

   --------------------------------
   -- On_System_Save_As_Activate --
   --------------------------------

   procedure On_System_Save_As_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Dialog : aliased Gtk_File_Chooser_Dialog;
      W1,w2 : Gtk_Widget;
   begin
      declare
         Name : String:=Mast_Actions.Name_Of_System;
	 Success : Boolean;
      begin
	 Dialog:= Gtk_File_Chooser_Dialog_New
	   (Title => "Save System File",
	    Parent => Gmast_Results, 
	    Action => Action_Save);
	 W1:=Dialog.Add_Button
	   (Text        => Gtk.Stock.Stock_Cancel, 
	    Response_Id => Gtk.Dialog.Gtk_Response_Cancel);
	 W2:=Dialog.Add_Button
	   (Text        => Gtk.Stock.Stock_Save, 
	    Response_Id => Gtk.Dialog.Gtk_Response_Accept);
	    
	 Dialog.Set_Do_Overwrite_Confirmation(True);
	 Dialog.Set_Current_Name (Ada.Directories.Simple_Name((Name&".bak")));
	 Success:=Set_Current_Folder
	   (Dialog, 
	    Ada.Directories.Containing_Directory(Name));
	 
	 if Dialog.Run = Gtk.Dialog.Gtk_Response_Accept then
	    declare
	       Filename : String := Dialog.Get_Filename;
	    begin
	       Mast_Actions.Save_System(Filename);
	    exception
	       when Ada.Text_IO.Name_Error | Ada.Text_IO.Status_Error |
		 Ada.Text_IO.Use_Error =>
		  Dialog.Destroy;
		  Gtk_New (Error_Window);
		  Set_Position(Error_Window,Win_Pos_Mouse);
		  Show_All (Error_Window);
		  Set_Text(Error_Window.Label_Error,
			   "Error while saving file in "&Filename);
	    end;
	 end if;
	 Dialog.Destroy;
      end;
   exception
      when Mast_Actions.No_System =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Set_Text(Error_Window.Label_Error,"No opened system");
         Set_Modal(Error_Window,True);
         Show_All (Error_Window);
   end On_System_Save_As_Activate;

   -----------------------
   -- On_Exit1_Activate --
   -----------------------

   procedure On_Exit1_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
   begin
      Gtk.Main.Main_Quit;
   end On_Exit1_Activate;

   ------------------------------
   -- On_Results_Open_Activate --
   ------------------------------

   procedure On_Results_Open_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Name : Unbounded_String;
      Dialog : aliased Gtk_File_Chooser_Dialog;
      W1,w2 : Gtk_Widget;
      Success : Boolean;
   begin   
      begin
	 Name:=To_Unbounded_String(Mast_Actions.Name_Of_System);
      exception
	 when No_System =>
	    Name:=To_Unbounded_String("");
      end;
      Dialog:= Gtk_File_Chooser_Dialog_New
	(Title => "Results File",
	 Parent => Gmast_Results, 
	 Action => Action_Open);
      W1:=Dialog.Add_Button
	(Text        => Gtk.Stock.Stock_Cancel, 
	 Response_Id => Gtk.Dialog.Gtk_Response_Cancel);
      W2:=Dialog.Add_Button
	(Text        => Gtk.Stock.Stock_Open, 
	 Response_Id => Gtk.Dialog.Gtk_Response_Accept);
      
      if To_String(Name)/="" then
	Success:=Set_Current_Folder(Dialog, 
	   Ada.Directories.Containing_Directory(To_String(Name)));
      end if;
	 
      if Dialog.Run = Gtk.Dialog.Gtk_Response_Accept then
	 declare
	    Filename : String := Dialog.Get_Filename;
	 begin
	    if Filename/="" then
	       Mast_Actions.Read_Results(Filename);
	       Set_Sensitive(Gmast_Results.Results_Save_As,True);
	       Draw_Results;
	    end if;
	 exception
	    when Ada.Text_IO.Name_Error | Ada.Text_IO.Status_Error |
	      Ada.Text_IO.Use_Error =>
	       Gtk_New (Error_Window);
	       Set_Position(Error_Window,Win_Pos_Mouse);
	       Show_All (Error_Window);
	       Set_Text(Error_Window.Label_Error,"Results File "&Filename&
			  " not found");
	       Set_Modal(Error_Window,True);
	 end;
      end if;
      Dialog.Destroy;
   exception  
      when Mast_Results_Parser_Error_Report.Syntax_Error =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "Syntax Error. See mast_results_parser.lis");
         Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.No_System =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "No MAST system defined");
         Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.No_Results =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "No MAST results defined");
         Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.Program_Not_Found =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "mast_xml_convert_results program not found");
         Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Mast_Actions.Xml_Convert_Error =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "Error detected while converting results from "&
                  "XML to text format");
         Set_Modal(Error_Window,True);
	 Dialog.Destroy;
      when Constraint_Error =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Show_All (Error_Window);
         Set_Text(Error_Window.Label_Error,
                  "Results file has unrecognizable format");
         Set_Modal(Error_Window,True);
	 Dialog.Destroy;
   end On_Results_Open_Activate;

   ---------------------------------
   -- On_Results_Save_As_Activate --
   ---------------------------------

   procedure On_Results_Save_As_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
      Dialog : aliased Gtk_File_Chooser_Dialog;
      W1,w2 : Gtk_Widget;
   begin
      declare
	 Name : String:=Mast_Actions.Name_Of_Results;
	 Success : Boolean;
      begin
	 Dialog:= Gtk_File_Chooser_Dialog_New
	   (Title => "Save Results File",
	    Parent => Gmast_Results, 
	    Action => Action_Save);
	 W1:=Dialog.Add_Button
	   (Text        => Gtk.Stock.Stock_Cancel, 
	    Response_Id => Gtk.Dialog.Gtk_Response_Cancel);
	 W2:=Dialog.Add_Button
	   (Text        => Gtk.Stock.Stock_Save, 
	    Response_Id => Gtk.Dialog.Gtk_Response_Accept);
	    
	 Dialog.Set_Do_Overwrite_Confirmation(True);
	 Dialog.Set_Current_Name (Ada.Directories.Simple_Name((Name&".bak")));
	 Success:=Set_Current_Folder
	   (Dialog, 
	    Ada.Directories.Containing_Directory(Name));
	 
	 if Dialog.Run = Gtk.Dialog.Gtk_Response_Accept then
	    declare
	       Filename: String := Dialog.Get_Filename;
	    begin
	       Mast_Actions.Save_Results(Filename);
	    exception
	       when Ada.Text_IO.Name_Error | Ada.Text_IO.Status_Error |
		 Ada.Text_IO.Use_Error =>
		  Dialog.Destroy;
		  Gtk_New (Error_Window);
		  Set_Position(Error_Window,Win_Pos_Mouse);
		  Show_All (Error_Window);
		  Set_Text(Error_Window.Label_Error,
			   "Error while saving file in "&Filename);
		  Set_Modal(Error_Window,True);
	    end;
	 end if;
	 Dialog.Destroy;
      end;
   exception
      when Mast_Actions.No_Results =>
         Gtk_New (Error_Window);
         Set_Position(Error_Window,Win_Pos_Mouse);
         Set_Text(Error_Window.Label_Error,"No opened results");
         Set_Modal(Error_Window,True);
         Show_All (Error_Window);
   end On_Results_Save_As_Activate;

   --------------------------
   -- On_Contents_Activate --
   --------------------------

   procedure On_Contents_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
   begin
      null;
   end On_Contents_Activate;

   -----------------------
   -- On_About_Activate --
   -----------------------

   procedure On_About_Activate
     (Object : access Gtk_Image_Menu_Item_Record'Class)
   is
   begin
      null;
   end On_About_Activate;

   ----------------------
   -- Create dialog event
   ----------------------

   procedure Create_Dialog_Event(Trans_Name : String) is
      Trans_Ref : Mast.Transactions.Transaction_Ref;
      Iterator : Mast.Transactions.Lists.Index;
      Index : Gint:=0;
   begin
      Gtk_New(Dialog_Event);
      Dialog_Event.Combo_Tr_Transaction.Append_Text("<View All>"); 
      Mast.Transactions.Lists.Rewind
        (Mast_Actions.The_System.Transactions,Iterator);
      for I in 1..Mast.Transactions.Lists.Size
        (Mast_Actions.The_System.Transactions)
      loop
         Mast.Transactions.Lists.Get_Next_Item
           (Trans_Ref,Mast_Actions.The_System.Transactions,Iterator);
         Dialog_Event.Combo_Tr_Transaction.Append_Text 
	   (To_String (Mast.Transactions.Name(Trans_Ref)));
	 if To_String(Mast.Transactions.Name(Trans_Ref))=Trans_Name then
	    Index:=Gint(I);
	 end if;
      end loop;
      Set_Active(Dialog_Event.Combo_Tr_Transaction,Index);
      Show_All(Dialog_Event);
      Resize_Timing_Results;
   end Create_Dialog_Event;

   ----------------------------------------
   -- On_Tree_Transactions_Row_Activated --
   ----------------------------------------

   procedure On_Tree_Transactions_Row_Activated
     (Object : access Gtk_Tree_View_Record'Class;
      Params : Glib.Values.GValues)
   is
      Path : Gtk_Tree_Path := 
	Convert (Glib.Values.Get_Address (Glib.Values.Nth (Params, 1)));
      Col :  Gtk_Tree_View_Column:= 
	Convert (Glib.Values.Get_Address
		   (Glib.Values.Nth (Params, 2)));
      Iter  : Gtk_Tree_Iter;
      Value : Glib.Values.GValue;
   begin
      Iter  := Get_Iter (Gmast_Results.Model_Transactions, Path);      
      if Col.Get_Title="Timing Results" then
	 Get_Value 
	   (Tree_Model	=> Gmast_Results.Model_Transactions,
	    Iter	=> Iter,
	    Column	=> 0,
	    Value       => Value);
	 Create_Dialog_Event(Glib.Values.Get_String(Value));
      end if;
   end On_Tree_Transactions_Row_Activated;

   ----------------------------------------
   -- On_Tree_Transactions_Click_Column --
   ----------------------------------------

   procedure On_Tree_Transactions_Click_Column
     (Object : access Gtk_Tree_View_Column_Record'Class)
   is
   begin
      Create_Dialog_Event("");
   end On_Tree_Transactions_Click_Column;

end Gmast_Results_Pkg.Callbacks;
