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
with Gtk.Window; use Gtk.Window;
with Gtk.Box; use Gtk.Box;
with Gtk.Alignment; use Gtk.Alignment;
with Gtk.Handle_Box; use Gtk.Handle_Box;
with Gtk.Menu_Bar; use Gtk.Menu_Bar;
with Gtk.Menu_Item; use Gtk.Menu_Item;
with Gtk.Menu; use Gtk.Menu;
with Gtk.Image_Menu_Item; use Gtk.Image_Menu_Item;
with Gtk.Image; use Gtk.Image;
with Gtk.Frame; use Gtk.Frame;
with Gtk.Tree_View; use Gtk.Tree_View;
with Gtk.Cell_Renderer_Text;   use Gtk.Cell_Renderer_Text;
with Gtk.Tree_Model;           use Gtk.Tree_Model;
--with Gtk.Tree_Selection;       use Gtk.Tree_Selection;
--with Gtk.Tree_Sortable;        use Gtk.Tree_Sortable;
with Gtk.Tree_Store;           use Gtk.Tree_Store;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Label; use Gtk.Label;
with Gtk.GEntry; use Gtk.GEntry;
with Glib.Unicode; use Glib.Unicode;
with Gdk.Pixbuf; use Gdk.Pixbuf;
with Gtk.Image; use Gtk.Image;
with Gtk.Notebook; use Gtk.Notebook;
with Gtk.Table; use Gtk.Table;
with Gtk.Scrolled_Window; use Gtk.Scrolled_Window;
with Gtk.Button; use Gtk.Button;
package Gmast_Results_Pkg is

   type Gmast_Results_Record is new Gtk_Window_Record with record
      Vbox1 : Gtk_Vbox;
      Hbox1 : Gtk_Hbox;
      Alignment1 : Gtk_Alignment;
      Vbox2 : Gtk_Vbox;
      Handlebox1 : Gtk_Handle_Box;
      Mainmenubar : Gtk_Menu_Bar;
      Systemfile : Gtk_Menu_Item;
      Systemfile_Menu : Gtk_Menu;
      System_Open : Gtk_Image_Menu_Item;
      Image7 : Gtk_Image;
      System_Save_As : Gtk_Image_Menu_Item;
      Image8 : Gtk_Image;
      Exit1 : Gtk_Image_Menu_Item;
      Image9 : Gtk_Image;
      Resultsfile : Gtk_Menu_Item;
      Resultsfile_Menu : Gtk_Menu;
      Results_Open : Gtk_Image_Menu_Item;
      Image10 : Gtk_Image;
      Results_Save_As : Gtk_Image_Menu_Item;
      Image11 : Gtk_Image;
      Help1 : Gtk_Menu_Item;
      Help1_Menu : Gtk_Menu;
      Contents : Gtk_Image_Menu_Item;
      Image12 : Gtk_Image;
      About : Gtk_Image_Menu_Item;
      Image13 : Gtk_Image;
      Frame3 : Gtk_Frame;
      Label30 : Gtk_Label;
      Frame4 : Gtk_Frame;
      Hbox2 : Gtk_Hbox;
      Label31 : Gtk_Label;
      Entry_Current_System : Gtk_Entry;
      Alignment2 : Gtk_Alignment;
      Frame1 : Gtk_Frame;
      Pixbuf_Logo : Gdk_Pixbuf;
      Image_Logo : Gtk_Image;
      Pixbuf_Name : Gdk_Pixbuf;
      Image_Name : Gtk_Image;
      Notebook1 : Gtk_Notebook;
      Frame2 : Gtk_Frame;
      Alignment3 : Gtk_Alignment;
      Table1 : Gtk_Table;
      Label8 : Gtk_Label;
      Label9 : Gtk_Label;
      Label10 : Gtk_Label;
      Label11 : Gtk_Label;
      Label12 : Gtk_Label;
      Label13 : Gtk_Label;
      Entry_Model_Name : Gtk_Entry;
      Entry_Model_Date : Gtk_Entry;
      Entry_Generation_Tool : Gtk_Entry;
      Entry_Generation_Profile : Gtk_Entry;
      Entry_Generation_Date : Gtk_Entry;
      Text_System_Slack : Gtk_Entry;
      Label1 : Gtk_Label;
      Scrolledwindow1 : Gtk_Scrolled_Window;
      Tree_Processing_Resources : Gtk_Tree_View;
      Model_Processing_Resources : Gtk_Tree_Store;
      Label2 : Gtk_Label;
      Scrolledwindow2 : Gtk_Scrolled_Window;
      Tree_Transactions : Gtk_Tree_View;
      Model_Transactions : Gtk_Tree_Store;
      Label3 : Gtk_Label;
      Label4 : Gtk_Label;
      Label5 : Gtk_Label;
      Label6 : Gtk_Label;
      Scrolledwindow3 : Gtk_Scrolled_Window;
      Tree_Shared_Resources : Gtk_Tree_View;
      Model_Shared_Resources : Gtk_Tree_Store;
      Scrolledwindow4 : Gtk_Scrolled_Window;
      Scrolledwindow5 : Gtk_Scrolled_Window;
   end record;
   type Gmast_Results_Access is access Gmast_Results_Record'Class;
   
   -- Processing resources columns
   PR_Name_Col             : constant:=0;
   PR_Type_Col             : constant:=1;
   PR_Slack_Col            : constant:=2;
   PR_Total_U_Col          : constant:=3;
   PR_App_U_Col            : constant:=4;
   PR_Switch_U_Col         : constant:=5;
   PR_Timer_U_Col          : constant:=6;
   PR_Driver_U_Col         : constant:=7;
   PR_Queue_Size_Col       : constant:=8;
   PR_Slack_Background_Col : constant:=9;
   PR_Util_Background_Col : constant:=10;
   
   -- Transactions columns
   TR_Name_Col             : constant:=0;
   TR_Type_Col             : constant:=1;
   TR_Slack_Col            : constant:=2;
   TR_Timing_Col           : constant:=3;
   TR_Slack_Background_Col : constant:=4;
   
   -- Shared resources columns
   SR_Name_Col             : constant:=0;
   SR_Type_Col             : constant:=1;
   SR_Ceil_Col             : constant:=2;
   SR_Total_U_Col          : constant:=3;
   SR_Queue_Size_Col       : constant:=4;
   
   procedure Gtk_New (Gmast_Results : out Gmast_Results_Access);
   procedure Initialize (Gmast_Results : access Gmast_Results_Record'Class);

   Gmast_Results : Gmast_Results_Access;

end Gmast_Results_Pkg;
