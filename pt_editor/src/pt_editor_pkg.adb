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

with Ada.Text_IO;

with Glib; use Glib;
with Gtk; use Gtk;
with Gdk.Types; use Gdk.Types;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Frame;    use Gtk.Frame;
with Gtk.Cell_Renderer_Text;   use Gtk.Cell_Renderer_Text;
with Gtk.Cell_Renderer;   use Gtk.Cell_Renderer;
with Gtk.Tree_View;            use Gtk.Tree_View;
with Gtk.Tree_Model;           use Gtk.Tree_Model;
with Gtk.Tree_Sortable;        use Gtk.Tree_Sortable;
with Gtk.Tree_Selection; use Gtk.Tree_Selection;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Bin; use Gtk.Bin;
with Glib.Properties;
with Gtkada.Handlers; use Gtkada.Handlers;
with Callbacks_pt_editor; use Callbacks_pt_editor;
with Pt_Editor_Pkg.Callbacks; use Pt_Editor_Pkg.Callbacks;
with pt_editor_Intl; use pt_editor_Intl;
with Task_Table;
with Mutex_Table;
with Usage_Table;
with Results_Table;
with Var_Strings; use Var_Strings;

package body Pt_Editor_Pkg is

   Frame1, Frame2, Frame3, Frame4 : Gtk_Frame;


procedure Gtk_New (Pt_Editor : out Pt_Editor_Access) is
begin
   Pt_Editor := new Pt_Editor_Record;
   Pt_Editor_Pkg.Initialize (Pt_Editor);
end Gtk_New;

procedure Initialize_Task_Model
  (Pt_Editor : access Pt_Editor_Record'Class)
is

   Col      : Gtk_Tree_View_Column;
   Num      : Gint;
   Text_Render_Name,
   Text_Render_C,
   Text_Render_T,
   Text_Render_D,
   Text_Render_Prio : Gtk_Cell_Renderer_Text;

   Parent : Gtk_Tree_Iter := Null_Iter;
   Iter : Gtk_Tree_Iter;
   pragma Unreferenced (Num);
   pragma Warnings (Off, Iter);

begin

   Gtk_New (Pt_Editor.Task_Treemodel,
            (Task_Table.Name_Col       => GType_String,
             Task_Table.C_Col          => GType_String,
             Task_Table.T_Col          => GType_String,
             Task_Table.D_Col          => GType_String,
             Task_Table.Prio_Col       => GType_String,
             Task_Table.Background_Col => GType_String));
   Gtk_New (Pt_Editor.Task_Treeview, Pt_Editor.Task_Treemodel);


   -- Name column
   Gtk_New (Text_Render_Name);
   Set_Property
     (Text_Render_Name,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_Name,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Task_Treeview, Col);
   Set_Sort_Column_Id (Col, Task_Table.Name_Col); -- sortable
   Set_Title (Col, "Task Name");
   Pack_Start (Col, Text_Render_Name, True);
   Set_Sizing (Col, Tree_View_Column_AutoSize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_Name, "text", Task_Table.Name_Col);
   Add_Attribute
     (Col, Text_Render_Name, "background", Task_Table.Background_Col);

   -- WCET Column
   Gtk_New (Text_Render_C);
   Set_Property
     (Text_Render_C,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_C,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Task_Treeview, Col);
   Set_Sort_Column_Id (Col, Task_Table.C_Col); -- sortable
   Set_Title (Col, "WCET");
   Pack_Start (Col, Text_Render_C, True);
   --Set_Sizing (Col, Tree_View_Column_Autosize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_C, "text", Task_Table.C_Col);
   Add_Attribute
     (Col, Text_Render_C, "background", Task_Table.Background_Col);

   -- Period Column
   Gtk_New (Text_Render_T);
   Set_Property
     (Text_Render_T,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_T,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Task_Treeview, Col);
   Set_Sort_Column_Id (Col, Task_Table.T_Col); -- sortable
   Set_Title (Col, "Period");
   Pack_Start (Col, Text_Render_T, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_T, "text", Task_Table.T_Col);
   Add_Attribute
     (Col, Text_Render_T, "background", Task_Table.Background_Col);

   -- Deadline Column
   Gtk_New (Text_Render_D);
   Set_Property
     (Text_Render_D,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_D,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Task_Treeview, Col);
   Set_Sort_Column_Id (Col, Task_Table.D_Col); -- sortable
   Set_Title (Col, "Deadline");
   Pack_Start (Col, Text_Render_D, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_D, "text", Task_Table.D_Col);
   Add_Attribute
     (Col, Text_Render_D, "background", Task_Table.Background_Col);

   -- Prio Column
   Gtk_New (Text_Render_Prio);
   Set_Property
     (Text_Render_Prio,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_Prio,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Task_Treeview, Col);
   Set_Sort_Column_Id (Col, Task_Table.Prio_Col); -- sortable
   Set_Title (Col, "Priority");
   Pack_Start (Col, Text_Render_Prio, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_Prio, "text", Task_Table.Prio_Col);
   Add_Attribute
     (Col, Text_Render_Prio, "background", Task_Table.Background_Col);

   Set_Headers_Clickable (Pt_Editor.Task_Treeview, True);

   -- connect signals
   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_Name, "edited", Text_Edited_Callback_Name'Access,
      Slot_Object => Pt_Editor.Task_Treemodel);

   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_C, "edited", Text_Edited_Callback_C'Access,
      Slot_Object => Pt_Editor.Task_Treemodel);

   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_T, "edited", Text_Edited_Callback_T'Access,
      Slot_Object => Pt_Editor.Task_Treemodel);

   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_D, "edited", Text_Edited_Callback_D'Access,
      Slot_Object => Pt_Editor.Task_Treemodel);

   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_Prio, "edited", Text_Edited_Callback_Prio'Access,
      Slot_Object => Pt_Editor.Task_Treemodel);


end Initialize_Task_Model;

procedure Initialize_Mutex_Model
  (Pt_Editor : access Pt_Editor_Record'Class)
is

   Col      : Gtk_Tree_View_Column;
   Num      : Gint;
   Text_Render_Name,
   Text_Render_Prio : Gtk_Cell_Renderer_Text;

   Parent : Gtk_Tree_Iter := Null_Iter;
   Iter : Gtk_Tree_Iter;
   pragma Unreferenced (Num);
   pragma Warnings (Off, Iter);

begin

   Gtk_New (Pt_Editor.Mutex_Treemodel,
            (Mutex_Table.Name_Col       => GType_String,
             Mutex_Table.Prio_Col       => GType_String,
             Mutex_Table.Background_Col => GType_String));
   Gtk_New (Pt_Editor.Mutex_Treeview, Pt_Editor.Mutex_Treemodel);


   -- Name column
   Gtk_New (Text_Render_Name);
   Set_Property
     (Text_Render_Name,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_Name,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Mutex_Treeview, Col);
   Set_Sort_Column_Id (Col, Mutex_Table.Name_Col); -- sortable
   Set_Title (Col, "Mutex Name");
   Pack_Start (Col, Text_Render_Name, True);
   Set_Sizing (Col, Tree_View_Column_AutoSize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_Name, "text", Mutex_Table.Name_Col);
   Add_Attribute
     (Col, Text_Render_Name, "background", Mutex_Table.Background_Col);

   -- Prio Column
   Gtk_New (Text_Render_Prio);
   Set_Property
     (Text_Render_Prio,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_Prio,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Mutex_Treeview, Col);
   Set_Sort_Column_Id (Col, Mutex_Table.Prio_Col); -- sortable
   Set_Title (Col, "Priority Ceiling");
   Pack_Start (Col, Text_Render_Prio, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_Prio, "text", Mutex_Table.Prio_Col);
   Add_Attribute
     (Col, Text_Render_Prio, "background", Mutex_Table.Background_Col);

   Set_Headers_Clickable (Pt_Editor.Mutex_Treeview, True);

   -- connect signals
   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_Name, "edited", Mutex_Edited_Callback_Name'Access,
      Slot_Object => Pt_Editor.Mutex_Treemodel);

   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_Prio, "edited", Mutex_Edited_Callback_Prio'Access,
      Slot_Object => Pt_Editor.Mutex_Treemodel);

end Initialize_Mutex_Model;

procedure Initialize_Usage_Model
  (Pt_Editor : access Pt_Editor_Record'Class)
is

   Col      : Gtk_Tree_View_Column;
   Num      : Gint;
   Text_Render_Name,
   Text_Render_Taskname,
   Text_Render_Mutexname,
   Text_Render_WCET : Gtk_Cell_Renderer_Text;

   Parent : Gtk_Tree_Iter := Null_Iter;
   Iter : Gtk_Tree_Iter;
   pragma Unreferenced (Num);
   pragma Warnings (Off, Iter);

begin

   Gtk_New (Pt_Editor.Usage_Treemodel,
            (Usage_Table.Name_Col       => GType_String,
             Usage_Table.Taskname_Col   => GType_String,
             Usage_Table.Mutexname_Col  => GType_String,
             Usage_Table.WCET_Col       => GType_String,
             Usage_Table.Background_Col => GType_String));
   Gtk_New (Pt_Editor.Usage_Treeview, Pt_Editor.Usage_Treemodel);


   -- Name column
   Gtk_New (Text_Render_Name);
   Set_Property
     (Text_Render_Name,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_Name,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Usage_Treeview, Col);
   Set_Sort_Column_Id (Col, Usage_Table.Name_Col); -- sortable
   Set_Title (Col, "Operation Name");
   Pack_Start (Col, Text_Render_Name, True);
   Set_Sizing (Col, Tree_View_Column_AutoSize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_Name, "text", Usage_Table.Name_Col);
   Add_Attribute
     (Col, Text_Render_Name, "background", Usage_Table.Background_Col);

   -- Taskname Column
   Gtk_New (Text_Render_Taskname);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Usage_Treeview, Col);
   Set_Sort_Column_Id (Col, Usage_Table.Taskname_Col); -- sortable
   Set_Title (Col, "Task Name");
   Pack_Start (Col, Text_Render_Taskname, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_Taskname, "text", Usage_Table.Taskname_Col);
   Add_Attribute
     (Col, Text_Render_Taskname, "background", Usage_Table.Background_Col);

   -- Mutexname Column
   Gtk_New (Text_Render_Mutexname);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Usage_Treeview, Col);
   Set_Sort_Column_Id (Col, Usage_Table.Mutexname_Col); -- sortable
   Set_Title (Col, "Mutex Name");
   Pack_Start (Col, Text_Render_Mutexname, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_Mutexname, "text",
                  Usage_Table.Mutexname_Col);
   Add_Attribute
     (Col, Text_Render_Mutexname, "background", Usage_Table.Background_Col);

   -- WCET Column
   Gtk_New (Text_Render_WCET);
   Set_Property
     (Text_Render_WCET,Gtk.Cell_Renderer.Mode_Property,
      Cell_Renderer_Mode_Editable);
   Glib.Properties.Set_Property
     (Text_Render_WCET,Gtk.Cell_Renderer_Text.Editable_Property,True);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Usage_Treeview, Col);
   Set_Sort_Column_Id (Col, Usage_Table.WCET_Col); -- sortable
   Set_Title (Col, "WCET");
   Pack_Start (Col, Text_Render_WCET, True);
   --Set_Sizing (Col, Tree_View_Colum_Autosize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_WCET, "text", Usage_Table.WCET_Col);
   Add_Attribute
     (Col, Text_Render_WCET, "background", Usage_Table.Background_Col);


   Set_Headers_Clickable (Pt_Editor.Task_Treeview, True);

   -- connect signals
   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_Name, "edited", Usage_Edited_Callback_Name'Access,
      Slot_Object => Pt_Editor.Usage_Treemodel);

   Callbacks_Pt_Editor.Object_Callback.Object_Connect
     (Text_Render_WCET, "edited", Usage_Edited_Callback_WCET'Access,
      Slot_Object => Pt_Editor.Usage_Treemodel);

end Initialize_Usage_Model;


procedure Initialize_Results_Model
  (Pt_Editor : access Pt_Editor_Record'Class)
is

   Col      : Gtk_Tree_View_Column;
   Num      : Gint;
   Text_Render_Name,
   Text_Render_B,
   Text_Render_D,
   Text_Render_R,
   Text_Render_Slack : Gtk_Cell_Renderer_Text;

   Parent : Gtk_Tree_Iter := Null_Iter;
   Iter : Gtk_Tree_Iter;
   pragma Unreferenced (Num);
   pragma Warnings (Off, Iter);

begin

   Gtk_New (Pt_Editor.Results_Treemodel,
            (Results_Table.Name_Col       => GType_String,
             Results_Table.B_Col          => GType_String,
             Results_Table.D_Col          => GType_String,
             Results_Table.R_Col          => GType_String,
             Results_Table.Slack_Col      => GType_String,
             Results_Table.Background_Col => GType_String));
   Gtk_New (Pt_Editor.Results_Treeview, Pt_Editor.Results_Treemodel);


   -- Name column
   Gtk_New (Text_Render_Name);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Results_Treeview, Col);
   Set_Sort_Column_Id (Col, Results_Table.Name_Col); -- sortable
   Set_Title (Col, "Task Name");
   Pack_Start (Col, Text_Render_Name, True);
   Set_Sizing (Col, Tree_View_Column_AutoSize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_Name, "text", Results_Table.Name_Col);
   Add_Attribute
     (Col, Text_Render_Name, "background", Results_Table.Background_Col);

   -- B Column
   Gtk_New (Text_Render_B);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Results_Treeview, Col);
   Set_Sort_Column_Id (Col, Results_Table.B_Col); -- sortable
   Set_Title (Col, "Blocking Time");
   Pack_Start (Col, Text_Render_B, True);
   --Set_Sizing (Col, Tree_View_Column_Autosize);
   Set_Resizable(Col, True);
   Add_Attribute (Col, Text_Render_B, "text", Results_Table.B_Col);
   --Add_Attribute
   --  (Col, Text_Render_B, "background", Results_Table.Background_Col);

   -- D Column
   Gtk_New (Text_Render_D);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Results_Treeview, Col);
   Set_Sort_Column_Id (Col, Results_Table.D_Col); -- sortable
   Set_Title (Col, "Deadline");
   Pack_Start (Col, Text_Render_D, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_D, "text", Results_Table.D_Col);
   --Add_Attribute
   --  (Col, Text_Render_D, "background", Results_Table.Background_Col);

   -- Response time Column
   Gtk_New (Text_Render_R);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Results_Treeview, Col);
   Set_Sort_Column_Id (Col, Results_Table.R_Col); -- sortable
   Set_Title (Col, "Response Time");
   Pack_Start (Col, Text_Render_R, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_R, "text", Results_Table.R_Col);
   Add_Attribute
     (Col, Text_Render_R, "background", Results_Table.Background_Col);

   -- Slack Column
   Gtk_New (Text_Render_Slack);

   Gtk_New (Col);
   Num := Append_Column (Pt_Editor.Results_Treeview, Col);
   Set_Sort_Column_Id (Col, Results_Table.Slack_Col); -- sortable
   Set_Title (Col, "Slack");
   Pack_Start (Col, Text_Render_Slack, True);
   Set_Sizing (Col, Tree_View_Column_Autosize);
   Add_Attribute (Col, Text_Render_Slack, "text", Results_Table.Slack_Col);
   Add_Attribute
     (Col, Text_Render_Slack, "background", Results_Table.Background_Col);

   Set_Headers_Clickable (Pt_Editor.Results_Treeview, True);
   Set_Mode(Get_Selection(Pt_Editor.Results_Treeview), Selection_None);

end Initialize_Results_Model;


procedure Initialize (Pt_Editor : access Pt_Editor_Record'Class) is
   pragma Suppress (All_Checks);
   Pixmaps_Dir : constant String := "pixmaps/";
   Vbox12_Group : Widget_SList.GSList;
   Cswitch_Spinbutton_Adj : Gtk_Adjustment;
   Ticker_Spinbutton_Adj : Gtk_Adjustment;

begin
   Gtk.Window.Initialize (Pt_Editor, Window_Toplevel);
   Set_Title (Pt_Editor, -"MAST Periodic Task Editor");
   Set_Default_Size (Pt_Editor, 600, 400);

   Gtk_New_Vbox (Pt_Editor.Vbox1, False, 0);

   Gtk_New (Pt_Editor.Menubar1);

   Gtk_New_With_Mnemonic (Pt_Editor.Menuitem1, -("_File"));

   Gtk_New (Pt_Editor.Menu1);

   Gtk_New_From_Stock (Pt_Editor.New_Menuitem1, "gtk-new",null);
   Append (Pt_Editor.Menu1, Pt_Editor.New_Menuitem1);
   
   Gtk_New_From_Stock (Pt_Editor.Open_Menuitem2, "gtk-open",null);
   Append (Pt_Editor.Menu1, Pt_Editor.Open_Menuitem2);
   
   Gtk_New_From_Stock (Pt_Editor.Save_Menuitem3, "gtk-save",null);
   Append (Pt_Editor.Menu1, Pt_Editor.Save_Menuitem3);
   
   Gtk_New_From_Stock (Pt_Editor.Save_As_Menuitem4, "gtk-save-as",null);
   Append (Pt_Editor.Menu1, Pt_Editor.Save_As_Menuitem4);
   
   Gtk_New (Pt_Editor.Separatormenuitem1);

   Append (Pt_Editor.Menu1, Pt_Editor.Separatormenuitem1);
   
   Gtk_New_From_Stock (Pt_Editor.Quit_Menuitem5, "gtk-quit",null);
   Append (Pt_Editor.Menu1, Pt_Editor.Quit_Menuitem5);
   
   Set_Submenu (Pt_Editor.Menuitem1, Pt_Editor.Menu1);
   Pt_Editor.Menuitem1.Set_Tooltip_Text
            (-"Manage the file containing the Periodic Task model");
   Append (Pt_Editor.Menubar1, Pt_Editor.Menuitem1);
   
   --  Gtk_New_With_Mnemonic (Pt_Editor.Menuitem3, -("_View"));
   --  Append (Pt_Editor.Menubar1, Pt_Editor.Menuitem3);
   
   Gtk_New_With_Mnemonic (Pt_Editor.Menuitem4, -("_Help"));
   Gtk_New (Pt_Editor.Menu3);
   
   Gtk_New_From_Stock (Pt_Editor.About_Menuitem10, "gtk-about",null);
   Append (Pt_Editor.Menu3, Pt_Editor.About_Menuitem10);
   
   Set_Submenu (Pt_Editor.Menuitem4, Pt_Editor.Menu3);
   Append (Pt_Editor.Menubar1, Pt_Editor.Menuitem4);
   Pack_Start
     (Pt_Editor.Vbox1,
      Pt_Editor.Menubar1,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Pt_Editor.Notebook1);

   Gtk_New_Vbox (Pt_Editor.Vbox2, False, 0);

   Gtk_New_Hbox (Pt_Editor.Hbox3, False, 0);

   Gtk_New(Frame1, "Scheduling Policy");
   Set_Shadow_Type (Frame1, Gtk.Enums.Shadow_In);

   Gtk_New
     (Pt_Editor.Alignment1, 0.5, 0.5, 0.2,
      0.2);

   Gtk_New_Vbox (Pt_Editor.Vbox12, False, 0);

   Frame1.Set_Tooltip_Text(-"Scheduling Policy used by the system scheduler");
   Gtk_New (Pt_Editor.Fixed_Prio_Radiobutton, Pt_Editor.Edf_Radiobutton, 
	    -("Fixed Priority"));

   Pack_Start
     (Pt_Editor.Vbox12,
      Pt_Editor.Fixed_Prio_Radiobutton,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pt_Editor.Fixed_Prio_Radiobutton.Set_Tooltip_Text
     (-"Fixed Priorities Scheduling Policy");
   Gtk_New (Pt_Editor.Edf_Radiobutton, Pt_Editor.Fixed_Prio_Radiobutton, 
	    -("EDF"));

   Pack_Start
     (Pt_Editor.Vbox12,
      Pt_Editor.Edf_Radiobutton,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pt_Editor.Edf_Radiobutton.Set_Tooltip_Text
            (-"Earliest Deadline First Scheduling Policy");
   Add (Pt_Editor.Alignment1, Pt_Editor.Vbox12);

   Add(Frame1,Pt_Editor.Alignment1);

   Pack_Start
     (Pt_Editor.Hbox3,
      Frame1,
      Expand  => True,
      Fill    => True,
      Padding => 10);
   Gtk_New
     (Pt_Editor.Alignment2, 0.5, 0.5, 0.2,
      0.2);

   Gtk_New(Frame2, -("Context Switch Time"));
   Set_Shadow_Type (Frame2, Gtk.Enums.Shadow_In);



   Gtk_New_Vbox (Pt_Editor.Vbox13, False, 0);

   Frame2.Set_Tooltip_Text
            (-"Time needed to switch form one task to another");
   Gtk_New (Cswitch_Spinbutton_Adj, 0.0, 0.0, 100.0, 1.0, 0.0, 0.0);
   Gtk_New (Pt_Editor.Cswitch_Spinbutton, Cswitch_Spinbutton_Adj, 1.0, 1);
   Set_Invisible_Char (Pt_Editor.Cswitch_Spinbutton, UTF8_Get_Char ("@"));
   Set_Numeric(Pt_Editor.Cswitch_Spinbutton,True);
   Set_Digits(Pt_Editor.Cswitch_Spinbutton,6);

   Pack_Start
     (Pt_Editor.Vbox13,
      Pt_Editor.Cswitch_Spinbutton,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pt_Editor.Cswitch_Spinbutton.Set_Tooltip_Text
            (-"The task context switch time in the processor");
   Add (Pt_Editor.Alignment2, Pt_Editor.Vbox13);

   Add(Frame2,Pt_Editor.Alignment2);

   Pack_Start
     (Pt_Editor.Hbox3,
      Frame2,
      Expand  => True,
      Fill    => True,
      Padding => 10);

   Pack_Start
     (Pt_Editor.Vbox2,
      Pt_Editor.Hbox3,
      Expand  => True,
      Fill    => True,
      Padding => 10);
   Gtk_New_Hbox (Pt_Editor.Hbox4, False, 0);

   Gtk_New(Frame3, -("Model Name"));
   Set_Shadow_Type (Frame3, Gtk.Enums.Shadow_In);


   Gtk_New
     (Pt_Editor.Alignment3, 0.5, 0.5, 0.2,
      0.2);

   Gtk_New (Pt_Editor.Label9, -(""));

   Frame3.Set_Tooltip_Text
            (-("The name of the modelled system;"&
              " it is defined by the input file name"));
   Add (Pt_Editor.Alignment3, Pt_Editor.Label9);

   Add(Frame3,Pt_Editor.Alignment3);

   Pack_Start
     (Pt_Editor.Hbox4,
      Frame3,
      Expand  => True,
      Fill    => True,
      Padding => 10);

   Gtk_New(Frame4, -("Timer Jitter"));
   Set_Shadow_Type (Frame4, Gtk.Enums.Shadow_In);

   Gtk_New
     (Pt_Editor.Alignment4, 0.5, 0.5, 0.2,
      0.2);

   Gtk_New_Vbox (Pt_Editor.Vbox14, False, 0);

   Frame4.Set_Tooltip_Text
            (-("The jitter introduced by the system timer, "&
                "usually in a ""ticker"" implementation"));
   Gtk_New (Ticker_Spinbutton_Adj, 0.0, 0.0, 100.0, 1.0, 0.0, 0.0);
   Gtk_New (Pt_Editor.Ticker_Spinbutton, Ticker_Spinbutton_Adj, 1.0, 1);
   Set_Invisible_Char (Pt_Editor.Ticker_Spinbutton, UTF8_Get_Char ("@"));
   Set_Numeric(Pt_Editor.Ticker_Spinbutton,True);
   Set_Digits(Pt_Editor.Ticker_Spinbutton,6);

   Pack_Start
     (Pt_Editor.Vbox14,
      Pt_Editor.Ticker_Spinbutton,
      Expand  => False,
      Fill    => False,
      Padding => 0);

   Add (Pt_Editor.Alignment4, Pt_Editor.Vbox14);

   Add (Frame4, Pt_Editor.Alignment4);

   Pack_Start
     (Pt_Editor.Hbox4,
      Frame4,
      Expand  => True,
      Fill    => True,
      Padding => 10);
   Pack_Start
     (Pt_Editor.Vbox2,
      Pt_Editor.Hbox4,
      Expand  => True,
      Fill    => True,
      Padding => 10);
   Gtk_New (Pt_Editor.Label1, -("Configuration"));
   Append_Page (Pt_Editor.Notebook1, Pt_Editor.Vbox2, Pt_Editor.Label1);
   --Set_Tab (Pt_Editor.Notebook1,0, Pt_Editor.Label1);

   Pt_Editor.Label1.Set_Tooltip_Text
            (-"Configuration of Scheduling Policy and General Overheads");
   Gtk_New_Vbox (Pt_Editor.Vbox5, False, 3);

   Gtk_New (Pt_Editor.Scrolledwindow1);

   Gtk_New (Pt_Editor.Task_Treeview);
   Initialize_Task_Model(Pt_Editor);

   Add (Pt_Editor.Scrolledwindow1, Pt_Editor.Task_Treeview);
   Pack_Start
     (Pt_Editor.Vbox5,
      Pt_Editor.Scrolledwindow1,
      Expand  => True,
      Fill    => True,
      Padding => 10);
   Gtk_New
     (Pt_Editor.Alignment5, 1.0, 1.0, 0.5,
      0.0);

   Gtk_New_Hbox (Pt_Editor.Hbox1, False, 10);

   Gtk_New (Pt_Editor.Add_Task_Button, -"Add 1 Task");

   Pack_Start
     (Pt_Editor.Hbox1,
      Pt_Editor.Add_Task_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Add_Task_Button.Set_Tooltip_Text
            (-"Add one line at the end of the table, for a new task");
   Gtk_New (Pt_Editor.Delete_Task_Button, -"Delete Selected");

   Pack_Start
     (Pt_Editor.Hbox1,
      Pt_Editor.Delete_Task_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Delete_Task_Button.Set_Tooltip_Text
            (-"delete the selected task");
   Gtk_New (Pt_Editor.Assign_Prio_Button, -"Assign Priorities/Levels");

   Pack_Start
     (Pt_Editor.Hbox1,
      Pt_Editor.Assign_Prio_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Assign_Prio_Button.Set_Tooltip_Text
            (-("Perform an automatic priority or preemption level assignment;"&
                " it is also possible to assign priorities or levels "&
                "manually"));
   Add (Pt_Editor.Alignment5, Pt_Editor.Hbox1);
   Pack_Start
     (Pt_Editor.Vbox5,
      Pt_Editor.Alignment5,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Pt_Editor.Label2, -("Periodic Tasks"));
   Append_Page (Pt_Editor.Notebook1, Pt_Editor.Vbox5, Pt_Editor.Label2);
   --Set_Tab_Label_Packing (Pt_Editor.Notebook1, Pt_Editor.Vbox5, True, False, Pack_Start);
   --Set_Tab (Pt_Editor.Notebook1, 1, Pt_Editor.Label2);

   Pt_Editor.Label2.Set_Tooltip_Text
            (-"Edit the parameters describing the periodic task set");
   Gtk_New_Vbox (Pt_Editor.Vbox6, False, 3);

   Gtk_New (Pt_Editor.Scrolledwindow2);

   Gtk_New (Pt_Editor.Mutex_Treeview);
   Initialize_Mutex_Model(Pt_Editor);

   Add (Pt_Editor.Scrolledwindow2, Pt_Editor.Mutex_Treeview);
   Pack_Start
     (Pt_Editor.Vbox6,
      Pt_Editor.Scrolledwindow2,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Gtk_New
     (Pt_Editor.Alignment9, 1.0, 1.0, 0.5,
      0.0);

   Gtk_New_Hbox (Pt_Editor.Hbox2, False, 10);

   Gtk_New (Pt_Editor.Add_Mutex_Button, -"Add 1 Mutex");

   Pack_Start
     (Pt_Editor.Hbox2,
      Pt_Editor.Add_Mutex_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Add_Mutex_Button.Set_Tooltip_Text
            (-"Add one line at the end of the table, for a new mutex");
   Gtk_New (Pt_Editor.Delete_Mutex_Button, -"Delete Selected Mutex");

   Pack_Start
     (Pt_Editor.Hbox2,
      Pt_Editor.Delete_Mutex_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Delete_Mutex_Button.Set_Tooltip_Text
            (-"delete the selected mutex");
   Gtk_New (Pt_Editor.Assign_Ceilings_Button, -"Assign Ceilings/Levels");

   Pack_Start
     (Pt_Editor.Hbox2,
      Pt_Editor.Assign_Ceilings_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Assign_Ceilings_Button.Set_Tooltip_Text
            (-("Perform an automatic assignment of ceilings or preemption"&
                " levels; it is also possible to assign ceilings or levels"&
                " manually"));
   Add (Pt_Editor.Alignment9, Pt_Editor.Hbox2);
   Pack_Start
     (Pt_Editor.Vbox6,
      Pt_Editor.Alignment9,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Pt_Editor.Label3, -("Mutual Exclusion" & ASCII.LF
& "      Resources"));
   Append_Page (Pt_Editor.Notebook1, Pt_Editor.Vbox6,Pt_Editor.Label3);
   --Set_Tab_Label_Packing (Pt_Editor.Notebook1, Pt_Editor.Vbox6, False, False, Pack_Start);
   --Set_Tab (Pt_Editor.Notebook1, 2, Pt_Editor.Label3);

   Pt_Editor.Label3.Set_Tooltip_Text
            (-("Edit the parameters describing the mutexes or resources"&
                " shared in mutual exclusion"));
   Gtk_New_Vbox (Pt_Editor.Vbox3, False, 0);

   Gtk_New (Pt_Editor.Scrolledwindow3);

   Gtk_New (Pt_Editor.Usage_Treeview);
   Initialize_Usage_Model(Pt_Editor);

   Add (Pt_Editor.Scrolledwindow3, Pt_Editor.Usage_Treeview);
   Pack_Start
     (Pt_Editor.Vbox3,
      Pt_Editor.Scrolledwindow3,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Gtk_New
     (Pt_Editor.Alignment8, 1.0, 1.0, 0.5,
      0.0);

   Gtk_New_Hbox (Pt_Editor.Hbox5, False, 10);

   Gtk_New (Pt_Editor.Add_Usage_Button, -"Add 1 Mutex Usage");
   Set_Sensitive(Pt_Editor.Add_Usage_Button,False);

   Pack_Start
     (Pt_Editor.Hbox5,
      Pt_Editor.Add_Usage_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Add_Usage_Button.Set_Tooltip_Text
            (-("Add one line at the end of the table, "&
                "for a new mutex usage item"));
   Gtk_New (Pt_Editor.Delete_Usage_Button, -"Delete Selected Usage");

   Pack_Start
     (Pt_Editor.Hbox5,
      Pt_Editor.Delete_Usage_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Delete_Usage_Button.Set_Tooltip_Text
            (-"delete the selected mutex usage item");
   Add (Pt_Editor.Alignment8, Pt_Editor.Hbox5);
   Pack_Start
     (Pt_Editor.Vbox3,
      Pt_Editor.Alignment8,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Pt_Editor.Label4, -("Mutex Usage"));
   Append_Page (Pt_Editor.Notebook1, Pt_Editor.Vbox3, Pt_Editor.Label4);
   --Set_Tab_Label_Packing (Pt_Editor.Notebook1, Pt_Editor.Vbox3, False, False, Pack_Start);
   --Set_Tab (Pt_Editor.Notebook1, 3, Pt_Editor.Label4);

   Pt_Editor.Label4.Set_Tooltip_Text
            (-("Edit the parameters describing the usage of mutexes"&
              " by the different tasks"));
   Gtk_New_Vbox (Pt_Editor.Vbox4, False, 0);

   Gtk_New_Vbox (Pt_Editor.Vbox7, False, 0);

   Gtk_New (Pt_Editor.Scrolledwindow4);

   Gtk_New (Pt_Editor.Results_Treeview);
   Initialize_Results_Model(Pt_Editor);

   Add (Pt_Editor.Scrolledwindow4, Pt_Editor.Results_Treeview);
   Pack_Start
     (Pt_Editor.Vbox7,
      Pt_Editor.Scrolledwindow4,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Gtk_New
     (Pt_Editor.Alignment7, 1.0, 1.0, 0.5,
      0.0);

   Gtk_New_Hbox (Pt_Editor.Hbox7, False, 0);

   Gtk_New_Vbox (Pt_Editor.Vbox8, False, 0);

   Gtk_New (Pt_Editor.Label6, -("System Utilization"));

   Pack_Start
     (Pt_Editor.Vbox8,
      Pt_Editor.Label6,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pt_Editor.Label6.Set_Tooltip_Text
            (-"Percentage of utilization of the system processor");
   Gtk_New (Pt_Editor.Utilization_Entry);
   Set_Invisible_Char (Pt_Editor.Utilization_Entry, UTF8_Get_Char ("@"));
   Set_Editable (Pt_Editor.Utilization_Entry, False);

   Pack_Start
     (Pt_Editor.Vbox8,
      Pt_Editor.Utilization_Entry,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pack_Start
     (Pt_Editor.Hbox7,
      Pt_Editor.Vbox8,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Vbox8.Set_Tooltip_Text
            (-"Percentage of utilization of the system processor");
   Gtk_New_Vbox (Pt_Editor.Vbox9, False, 0);

   Gtk_New (Pt_Editor.Label7, -("System Slack"));

   Pack_Start
     (Pt_Editor.Vbox9,
      Pt_Editor.Label7,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Pt_Editor.Slack_Entry);
   Set_Invisible_Char (Pt_Editor.Slack_Entry, UTF8_Get_Char ("@"));
   Set_Editable (Pt_Editor.Slack_Entry, False);

   Pack_Start
     (Pt_Editor.Vbox9,
      Pt_Editor.Slack_Entry,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Pack_Start
     (Pt_Editor.Hbox7,
      Pt_Editor.Vbox9,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Vbox9.Set_Tooltip_Text
            (-("If positive: Percentage by which the execution times of the"&
                "tasks may be increased while keeping the system schedulable"&
                "; If negative: Percentage by which the execution times of"&
                " the tasks must be decreased to make the system schedulable"));
   Add (Pt_Editor.Alignment7, Pt_Editor.Hbox7);
   Pack_Start
     (Pt_Editor.Vbox7,
      Pt_Editor.Alignment7,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pack_Start
     (Pt_Editor.Vbox4,
      Pt_Editor.Vbox7,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Gtk_New_Hseparator (Pt_Editor.Hseparator1);

   Pack_Start
     (Pt_Editor.Vbox4,
      Pt_Editor.Hseparator1,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New
     (Pt_Editor.Alignment6, 1.0, 1.0, 0.5,
      1.0);

   Gtk_New_Hbox (Pt_Editor.Hbox6, False, 10);

   Gtk_New (Pt_Editor.Assign_Params_Button,
            -"Assign Priorities and Ceilings/Levels");

   Pack_Start
     (Pt_Editor.Hbox6,
      Pt_Editor.Assign_Params_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Assign_Params_Button.Set_Tooltip_Text
            (-("Perform an automatic assignment of priorities and ceilings"&
                " or preemption levels; it is also possible to assign "&
                "priorities ceilings or preemption levels manually "&
                "(in the corresponding tabs)"));
   Gtk_New (Pt_Editor.Do_Analysis_Button, -"Do Schedulability Analysis");

   Pack_Start
     (Pt_Editor.Hbox6,
      Pt_Editor.Do_Analysis_Button,
      Expand  => False,
      Fill    => False,
      Padding => 10);
   Pt_Editor.Do_Analysis_Button.Set_Tooltip_Text
            (-"Make a schedulability analysis and display the results");
   Add (Pt_Editor.Alignment6, Pt_Editor.Hbox6);
   Pack_Start
     (Pt_Editor.Vbox4,
      Pt_Editor.Alignment6,
      Expand  => False,
      Fill    => False,
      Padding => 0);
   Gtk_New (Pt_Editor.Label5, -("Analysis Results"));
   Append_Page (Pt_Editor.Notebook1, Pt_Editor.Vbox4, Pt_Editor.Label5);
   --Set_Tab_Label_Packing (Pt_Editor.Notebook1, Pt_Editor.Vbox4, False, False, Pack_Start);
   --Set_Tab (Pt_Editor.Notebook1, 4, Pt_Editor.Label5);

   Pt_Editor.Label5.Set_Tooltip_Text
            (-"View the results of schedulability analysis");
   Pack_Start
     (Pt_Editor.Vbox1,
      Pt_Editor.Notebook1,
      Expand  => True,
      Fill    => True,
      Padding => 0);
   Add (Pt_Editor, Pt_Editor.Vbox1);

   --  Connect signals

   Image_Menu_Item_Callback.Connect
     (Pt_Editor.New_Menuitem1, "activate",
      Image_Menu_Item_Callback.To_Marshaller (On_New_Menuitem1_Activate'Access), False);
   Image_Menu_Item_Callback.Connect
     (Pt_Editor.Open_Menuitem2, "activate",
      Image_Menu_Item_Callback.To_Marshaller (On_Open_Menuitem2_Activate'Access), False);
   Image_Menu_Item_Callback.Connect
     (Pt_Editor.Save_Menuitem3, "activate",
      Image_Menu_Item_Callback.To_Marshaller (On_Save_Menuitem3_Activate'Access), False);
   Image_Menu_Item_Callback.Connect
     (Pt_Editor.Save_As_Menuitem4, "activate",
      Image_Menu_Item_Callback.To_Marshaller (On_Save_As_Menuitem4_Activate'Access), False);
   Image_Menu_Item_Callback.Connect
     (Pt_Editor.Quit_Menuitem5, "activate",
      Image_Menu_Item_Callback.To_Marshaller (On_Quit_Menuitem5_Activate'Access), False);
   Image_Menu_Item_Callback.Connect
     (Pt_Editor.About_Menuitem10, "activate",
      Image_Menu_Item_Callback.To_Marshaller (On_About_Menuitem10_Activate'Access), False);
   Radio_Button_Callback.Connect
     (Pt_Editor.Fixed_Prio_Radiobutton, "toggled",
      Radio_Button_Callback.To_Marshaller (On_Fixed_Prio_Radiobutton_Toggled'Access), False);
   Radio_Button_Callback.Connect
     (Pt_Editor.Edf_Radiobutton, "toggled",
      Radio_Button_Callback.To_Marshaller (On_Edf_Radiobutton_Toggled'Access), False);
   Spin_Button_Callback.Connect
     (Pt_Editor.Cswitch_Spinbutton, "value_changed",
      Spin_Button_Callback.To_Marshaller (On_Cswitch_Spinbutton_Value_Changed'Access), False);
   Spin_Button_Callback.Connect
     (Pt_Editor.Ticker_Spinbutton, "value_changed",
      Spin_Button_Callback.To_Marshaller (On_Ticker_Spinbutton_Value_Changed'Access), False);
   Tree_View_Callback.Connect
     (Pt_Editor.Task_Treeview, "columns_changed",
      Tree_View_Callback.To_Marshaller (On_Task_Treeview_Columns_Changed'Access), False);

   Button_Callback.Connect
     (Pt_Editor.Add_Task_Button, "pressed",
      Button_Callback.To_Marshaller (On_Add_Task_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Delete_Task_Button, "pressed",
      Button_Callback.To_Marshaller (On_Delete_Task_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Assign_Prio_Button, "pressed",
      Button_Callback.To_Marshaller (On_Assign_Prio_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Add_Mutex_Button, "pressed",
      Button_Callback.To_Marshaller (On_Add_Mutex_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Delete_Mutex_Button, "pressed",
      Button_Callback.To_Marshaller (On_Delete_Mutex_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Assign_Ceilings_Button, "pressed",
      Button_Callback.To_Marshaller (On_Assign_Ceilings_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Add_Usage_Button, "pressed",
      Button_Callback.To_Marshaller (On_Add_Usage_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Delete_Usage_Button, "pressed",
      Button_Callback.To_Marshaller (On_Delete_Usage_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Assign_Params_Button, "pressed",
      Button_Callback.To_Marshaller (On_Assign_Params_Button_Pressed'Access), False);
   Button_Callback.Connect
     (Pt_Editor.Do_Analysis_Button, "pressed",
      Button_Callback.To_Marshaller (On_Do_Analysis_Button_Pressed'Access), False);
   Return_Callback.Connect
     (Pt_Editor, "delete_event", On_Pt_Editor_Delete_Event'Access, False);
end Initialize;

end Pt_Editor_Pkg;
