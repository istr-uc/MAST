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
with Gtk.Tree_View;            use Gtk.Tree_View;
with Gtk.Tree_Model;           use Gtk.Tree_Model;
with Gtk.Tree_View_Column;     use Gtk.Tree_View_Column;
with Gtk.Tree_Store;           use Gtk.Tree_Store;
with Gtk.Tree_Selection;       use Gtk.Tree_Selection;
with Gtk.Label; use Gtk.Label;
with Gtk.Dialog; use Gtk.Dialog;
with Gtk.Widget; use Gtk.Widget;
with Gtk.Tree_Model; use Gtk.Tree_Model;

with Pt_Editor_Pkg; use Pt_Editor_Pkg;
with Pt_Editor_Intl; use Pt_Editor_Intl;

with Ada.Text_IO; use Ada.Text_IO;
with Dialog1_Pkg; use Dialog1_Pkg;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;

package body Task_Table is

   Last_Task : Natural:=0;

   ------------------
   -- Add_New_Task --
   ------------------

   procedure Add_New_Task (WCET, T, D, Prio : String) is
   begin
      loop
        declare
           Num : String:=Integer'Image(Last_Task+1);
        begin
           if Task_Name_Is_In_Use("T"&Num(Num'First+1..Num'Last)) then
              Last_Task:=Last_Task+1;
           else
              Add_New_Task("T"&Num(Num'First+1..Num'Last),WCET, T, D, Prio);
              exit;
           end if;
        end;
      end loop;
   end Add_New_Task;

   ------------------
   -- Add_New_Task --
   ------------------

   procedure Add_New_Task (Name, WCET, T, D, Prio : String) is
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First(Pt_Editor.Task_Treemodel);
   begin
      Last_Task:=Last_Task+1;
      Append(Pt_Editor.Task_Treemodel, Iter, Parent);
      Set(Pt_Editor.Task_Treemodel, Iter, Name_Col, -(Name));
      Set(Pt_Editor.Task_Treemodel, Iter, C_Col, -(WCET));
      Set(Pt_Editor.Task_Treemodel, Iter, T_Col, -(T));
      Set(Pt_Editor.Task_Treemodel, Iter, D_Col, -(D));
      Set(Pt_Editor.Task_Treemodel, Iter, Prio_Col, -(Prio));
      Set(Pt_Editor.Task_Treemodel, Iter, Background_Col, "white");
   end Add_New_Task;

   --------------------------
   -- Task Name Is in Use --
   --------------------------

   function Task_Name_Is_In_Use
     (Name : String)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      -- Iterate over the rows
      for Row in 1..Task_Table.Num_Tasks loop
         Iter:=Nth_Child(Pt_Editor.Task_Treemodel,Parent,Gint(Row-1));
         if To_Lower(Get_String(Pt_Editor.Task_Treemodel,Iter,Name_Col))=
           To_Lower(Name)
         then
            return True;
         end if;
      end loop;
      return False;
   end Task_Name_Is_In_Use;

   -------------------------
   -- Task_Name_Is_Unique --
   -------------------------

   function Task_Name_Is_Unique
     (Name : String; In_Row : Positive)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      if In_Row>Num_Tasks then
         raise Incorrect_Row;
      end if;
      -- Iterate over the rows
      for Row in 1..Task_Table.Num_Tasks loop
         if Row/=In_Row then
            Iter:=Nth_Child(Pt_Editor.Task_Treemodel,Parent,Gint(Row-1));
            if To_Lower(Get_String(Pt_Editor.Task_Treemodel,Iter,Name_Col))=
              To_Lower(Name)
            then
               return False;
            end if;
         end if;
      end loop;
      return True;
   end Task_Name_Is_Unique;

   ---------------------
   -- Fill_Task_Names --
   ---------------------

   procedure Fill_Task_Names (Combo : in out Gtk_Combo_Box_Text) is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      for Row in 1..N_Children(Get_Model(Combo)) loop
         Remove(Combo,0);
      end loop;
      for Row in 1..Task_Table.Num_Tasks loop
         Iter:=Nth_Child(Pt_Editor.Task_Treemodel,Parent,Gint(Row-1));
         Append_Text
           (Combo,Get_String(Pt_Editor.Task_Treemodel,Iter,Name_Col));
      end loop;
      if Task_Table.Num_Tasks>0 then
         Set_Active(Combo,0);
      end if;
   end Fill_Task_Names;

   --------------
   -- Get_Task --
   --------------

   procedure Get_Task
     (Row : Positive; Name, WCET, T, D, Prio : out Var_String)
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      if Row>Num_Tasks then
         raise Incorrect_Row;
      end if;
      Iter:=Nth_Child(Pt_Editor.Task_Treemodel,Parent,Gint(Row-1));
      Name:=To_Var_String
        (Get_String(Pt_Editor.Task_Treemodel,Iter,Name_Col));
      WCET:=To_Var_String
        (Get_String(Pt_Editor.Task_Treemodel,Iter,C_Col));
      T:=To_Var_String
        (Get_String(Pt_Editor.Task_Treemodel,Iter,T_Col));
      D:=To_Var_String
        (Get_String(Pt_Editor.Task_Treemodel,Iter,D_Col));
      Prio:=To_Var_String
        (Get_String(Pt_Editor.Task_Treemodel,Iter,Prio_Col));
   end Get_Task;


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First(Pt_Editor.Task_Treemodel);
   begin
      -- Clear the model
      Clear(Pt_Editor.Task_Treemodel);
   end Initialize;


   ---------------
   -- Num_Tasks --
   ---------------

   function Num_Tasks return Natural is
   begin
      return Natural(N_Children(Pt_Editor.Task_Treemodel));
   end Num_Tasks;


   --------------------------
   -- Delete_Selected_Task --
   --------------------------

   procedure Delete_Selected_Task (Deleted : out Boolean) is
      Selection : Gtk_Tree_Selection;
      Iter : Gtk_Tree_Iter;
      Model : Gtk_Tree_Model;
   begin
      Deleted:=False;
      -- Get the selected row
      Selection:=Get_Selection(Pt_Editor.Task_Treeview);
      if Count_Selected_Rows(Selection)=1 then
         Get_Selected(Selection,Model,Iter);
         if Iter/=Null_Iter then
            Remove(Pt_Editor.Task_Treemodel,Iter);
            Deleted:=True;
         else
            Ada.Text_IO.Put_Line("No selected row");
         end if;
      else
            Ada.Text_IO.Put_Line("No single selected row");
      end if;
   end Delete_Selected_Task;

   ------------------------
   -- Selected_Task_Name --
   ------------------------

   function Selected_Task_Name return String is
      Selection : Gtk_Tree_Selection;
      Iter : Gtk_Tree_Iter;
      Model : Gtk_Tree_Model;
   begin
      -- Get the selected row
      Selection:=Get_Selection(Pt_Editor.Task_Treeview);
      if Count_Selected_Rows(Selection)=1 then
         Get_Selected(Selection,Model,Iter);
         if Iter=Null_Iter then
            return "";
         else
            return Get_String(Pt_Editor.Task_Treemodel,Iter,Name_Col);
         end if;
      else
         return "";
      end if;
   end Selected_Task_Name;

   ------------------
   -- Set_Priority --
   ------------------

   procedure Set_Priority(Name : String; Prio : Natural) is
      Iter : Gtk_Tree_Iter;
   begin
      Iter:=Get_Iter_First(Pt_Editor.Task_Treemodel);
      while Iter/=Null_Iter loop
         if To_Lower(Get_String(Pt_Editor.Task_Treemodel,Iter,Name_Col))=
           To_Lower(Name)
         then
            -- Name was found; change priority and exit loop
            Set(Pt_Editor.Task_Treemodel,Iter,Prio_Col,
              -(Trim(Natural'Image(Prio),Both)));
            exit;
         end if;
         Next(Pt_Editor.Task_Treemodel,Iter);
      end loop;
   end Set_Priority;


end Task_Table;
