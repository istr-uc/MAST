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
with Gtk.Button; use Gtk.Button;

with Pt_Editor_Pkg; use Pt_Editor_Pkg;
with Pt_Editor_Intl; use Pt_Editor_Intl;
with Ada.Text_IO; use Ada.Text_IO;
with Dialog1_Pkg; use Dialog1_Pkg;
with Check_Operations;
with Mutex_Table;
with Task_Table;

with Ada.Characters.Handling; use Ada.Characters.Handling;

package body Usage_Table is

   Last_Usage : Natural:=0;

   ------------------
   -- Add_New_Usage --
   ------------------

   procedure Add_New_Usage (Name, Taskname, Mutexname, WCET : String) is
      Parent : Gtk_Tree_Iter := Null_Iter;
      Iter : Gtk_Tree_Iter:=Get_Iter_First(Pt_Editor.Usage_Treemodel);
   begin
      Last_Usage:=Last_Usage+1;
      Append(Pt_Editor.Usage_Treemodel, Iter, Parent);
      Set(Pt_Editor.Usage_Treemodel, Iter, Name_Col, -(Name));
      Set(Pt_Editor.Usage_Treemodel, Iter, Taskname_Col, -(Taskname));
      Set(Pt_Editor.Usage_Treemodel, Iter, Mutexname_Col, -(Mutexname));
      Set(Pt_Editor.Usage_Treemodel, Iter, WCET_Col, -(WCET));
      Set(Pt_Editor.Usage_Treemodel, Iter, Background_Col, "white");
   end Add_New_Usage;

   -------------------------
   -- Increase_Last_Usage --
   -------------------------

   procedure Increase_Last_Usage is
   begin
      Last_Usage:=Last_Usage+1;
   end Increase_Last_Usage;

   --------------------
   -- Task Is in Use --
   --------------------

   function Task_Is_In_Use
     (Name : String)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      -- Iterate over the rows
      for Row in 1..Usage_Table.Num_Usages loop
         Iter:=Nth_Child(Pt_Editor.Usage_Treemodel,Parent,Gint(Row-1));
         if To_Lower(Get_String(Pt_Editor.Usage_Treemodel,Iter,Taskname_Col))=
           To_Lower(Name)
         then
            return True;
         end if;
      end loop;
      return False;
   end Task_Is_In_Use;

   ---------------------
   -- Mutex Is in Use --
   ---------------------

   function Mutex_Is_In_Use
     (Name : String)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      -- Iterate over the rows
      for Row in 1..Usage_Table.Num_Usages loop
         Iter:=Nth_Child(Pt_Editor.Usage_Treemodel,Parent,Gint(Row-1));
         if To_Lower(Get_String(Pt_Editor.Usage_Treemodel,Iter,Mutexname_Col))=
           To_Lower(Name)
         then
            return True;
         end if;
      end loop;
      return False;
   end Mutex_Is_In_Use;

   --------------------------
   -- Usage Name Is in Use --
   --------------------------

   function Usage_Name_Is_In_Use
     (Name : String)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      -- Iterate over the rows
      for Row in 1..Usage_Table.Num_Usages loop
         Iter:=Nth_Child(Pt_Editor.Usage_Treemodel,Parent,Gint(Row-1));
         if To_Lower(Get_String(Pt_Editor.Usage_Treemodel,Iter,Name_Col))=
           To_Lower(Name)
         then
            return True;
         end if;
      end loop;
      return False;
   end Usage_Name_Is_In_Use;

   --------------------------
   -- Usage Name Is Unique --
   --------------------------

   function Usage_Name_Is_Unique
     (Name : String; In_Row : Positive)
     return Boolean
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      if In_Row>Num_Usages then
         raise Incorrect_Row;
      end if;
      -- Iterate over the rows
      for Row in 1..Usage_Table.Num_Usages loop
         if Row/=In_Row then
            Iter:=Nth_Child(Pt_Editor.Usage_Treemodel,Parent,Gint(Row-1));
            if To_LOwer(Get_String(Pt_Editor.Usage_Treemodel,Iter,Name_Col))=
              To_Lower(Name)
            then
               return False;
            end if;
         end if;
      end loop;
      return True;
   end Usage_Name_Is_Unique;


   --------------------
   -- Get_Last_Usage --
   --------------------

   function Get_Last_Usage return Natural
   is
   begin
      return Last_Usage;
   end Get_Last_Usage;

   --------------
   -- Get_Usage --
   --------------

   procedure Get_Usage
     (Row : Positive; Name, Taskname, Mutexname, WCET : out Var_String)
   is
      Iter : Gtk_Tree_Iter;
      Parent : Gtk_Tree_Iter := Null_Iter;
   begin
      if Row>Num_Usages then
         raise Incorrect_Row;
      end if;
      Iter:=Nth_Child(Pt_Editor.Usage_Treemodel,Parent,Gint(Row-1));
      Name:=To_Var_String
        (Get_String(Pt_Editor.Usage_Treemodel,Iter,Name_Col));
      Taskname:=To_Var_String
        (Get_String(Pt_Editor.Usage_Treemodel,Iter,Taskname_Col));
      Mutexname:=To_Var_String
        (Get_String(Pt_Editor.Usage_Treemodel,Iter,Mutexname_Col));
      WCET:=To_Var_String
        (Get_String(Pt_Editor.Usage_Treemodel,Iter,WCET_Col));
   end Get_Usage;


   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      Clear(Pt_Editor.Usage_Treemodel);
   end Initialize;


   ---------------
   -- Num_Usages --
   ---------------

   function Num_Usages return Natural is
   begin
      return Natural(N_Children(Pt_Editor.Usage_Treemodel));
   end Num_Usages;


   --------------------------
   -- Delete_Selected_Usage --
   --------------------------

   procedure Delete_Selected_Usage (Deleted : out Boolean) is
      Selection : Gtk_Tree_Selection;
      Iter : Gtk_Tree_Iter;
      Model : Gtk_Tree_Model;
   begin
      -- Get the selected row
      Selection:=Get_Selection(Pt_Editor.Usage_Treeview);
      Get_Selected(Selection,Model,Iter);
      if Iter/=Null_Iter then
         Remove(Pt_Editor.Usage_Treemodel,Iter);
         Deleted:=True;
      else
         Deleted:=False;
      end if;
   end Delete_Selected_Usage;

   -----------------
   -- Set_Buttons --
   -----------------

   procedure Set_Buttons is
   begin
      if Mutex_Table.Num_Mutexes>0 and then Task_Table.Num_Tasks > 0 then
         Set_Sensitive(Pt_Editor.Add_Usage_Button,True);
      else
         Set_Sensitive(Pt_Editor.Add_Usage_Button,False);
      end if;
   end Set_Buttons;


end Usage_Table;
