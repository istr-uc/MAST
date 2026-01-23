-----------------------------------------------------------------------
--                              Mast                                 --
--     Modelling and Analysis Suite for Real-Time Applications       --
--                                                                   --
--                       Copyright (C) 2000-2002                     --
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

with Associations,List_Exceptions,Ada.Text_IO;
use List_Exceptions,Ada;

procedure Prueba_Assoc is

   package Mi_Assoc is new Associations(Integer,"=");
   use Mi_Assoc;

   procedure Espera is
   begin
      Text_IO.Put("Pulsa <return> para continuar");
      Text_IO.Skip_Line;
   end Espera;

   procedure Recorre (L : in out Relation_Sets.List) is
      J : Integer;
      Pos:Relation_Sets.Index;
      It : Relation_Sets.Iteration_Object;
   begin
      Text_IO.Put_Line("Recorre la lista");
      if Relation_Sets.Size(L)=0 then
         Text_IO.Put_Line("La lista esta vacia");
      else
         Text_IO.Put_Line("Principio lista");
         Relation_Sets.Rewind(L,Pos);
         for I in 1..Relation_Sets.Size(L) loop
            Relation_Sets.Get_Next_Item(J,L,Pos);
            Text_IO.Put_Line("Elemento : " & Integer'Image(I) &
                             " = " & Integer'Image(J));
         end loop;
         Text_IO.Put_Line("Final lista");
      end if;
   end Recorre;

   procedure Recorre (A: in out Association) is
      Set : Relation_Set_Ref;
      It : Rel_Set_Iteration_Object;
   begin
      Text_IO.Put_Line("Recorre la lista");
      if Num_Of_Relation_Sets(A)=0 then
         Text_IO.Put_Line("La lista esta vacia");
      else
         Text_IO.Put_Line("Principio lista");
         Rewind_Relation_Sets(A,It);
         for I in 1..Num_Of_Relation_Sets(A) loop
            Get_Next_Relation_Set(A,Set,It);
            Recorre(Set.all);
         end loop;
         Text_IO.Put_Line("Final lista");
      end if;
   end Recorre;

   -- variables del programa principal

   A : Association;
   Elem : Integer;
   I : Integer:=0;

begin
   Init(A);
   Text_IO.Put_Line("Prueba de asociacion");
   Text_IO.Put_Line("recorre una associacion vacia");
   Recorre(A);

   Text_IO.Put_Line("Anadir (1-2, 4-5, 2-3, 6-7, "&
                    "2-6, 5-6, 4-8, 1-2, 9-10)");
   Add_Relation(1,2,A);
   Recorre(A);
   Espera;

   Add_Relation(4,5,A);
   Recorre(A);
   Espera;

   Add_Relation(2,3,A);
   Recorre(A);
   Espera;

   Add_Relation(6,7,A);
   Recorre(A);
   Espera;

   Add_Relation(2,6,A);
   Recorre(A);
   Espera;

   Add_Relation(5,6,A);
   Recorre(A);
   Espera;

   Add_Relation(4,8,A);
   Recorre(A);
   Espera;

   Add_Relation(1,2,A);
   Recorre(A);
   Espera;

   Add_Relation(9,10,A);

   Recorre(A);
   Espera;


end Prueba_Assoc;

