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

with Doubly_Linked_Lists,List_Exceptions,Ada.Text_IO;
use List_Exceptions,Ada;

procedure Prueba_Listas_D is

   package Mi_Lista is new Doubly_Linked_Lists(Integer,"=");
   use Mi_Lista;

   procedure Espera is
   begin
      Text_IO.Put("Pulsa <return> para continuar");
      Text_IO.Skip_Line;
   end Espera;

   procedure Recorre (L : in out List) is
      Pos : Index;
      J : Integer;
   begin
      Text_IO.Put_Line("Recorre la lista");
      if Size(L)=0 then
         Text_IO.Put_Line("La lista esta vacia");
      else
         Text_IO.Put_Line("Principio lista");
         Rewind(L,Pos);
         for I in 1..Size(L) loop
            Get_Next_Item(J,L,Pos);
            Text_IO.Put_Line("Elemento : " & Integer'Image(I) &
                             " = " & Integer'Image(J));
         end loop;
         Text_IO.Put_Line("Final lista");
      end if;
   end Recorre;

   procedure Recorre2 (L : in out List) is
      Pos : Index; Elem : Integer;
   begin
      Text_IO.Put_Line("Recorre la lista");
      if Size(L)=0 then
         Text_IO.Put_Line("La lista esta vacia");
      else
         Text_IO.Put_Line("Principio lista");
         Rewind(L,Pos);
         for I in 1..Size(L) loop
            Get_Next_Item(Elem,L,Pos);
            Text_IO.Put_Line("Elemento : " & Integer'Image(I) &
                             " = " & Integer'Image(Elem));
         end loop;
         Text_IO.Put_Line("Final lista");
      end if;
   end Recorre2;

   -- variables del programa principal

   L1,L2 : List;
   Pos : Index;
   Elem : Integer;

begin
   Text_IO.Put_Line("Prueba de listas");
   Text_IO.Put_Line("recorre una lista vacia");
   Recorre(L1);

   Text_IO.Put_Line("siguiente al primero");
   begin
      Get_Next_Item(Elem,L1,Pos);
      Text_IO.Put_Line("OK");
   exception
      when No_More_Items =>
         Text_IO.Put_Line("Posicion Incorrecta");
   end;

   Text_IO.Put_Line("otro siguiente al primero");
   begin
      Get_Next_Item(Elem,L1,Pos);
      Text_IO.Put_Line("OK");
   exception
      when No_More_Items =>
         Text_IO.Put_Line("Posicion Incorrecta");
   end;

   Text_IO.Put_Line("anade 5 elementos (1,2,3,4,5)");
   for I in Integer range 1..5 loop
      Add(I,L1);
   end loop;

   Text_IO.Put_Line("inserta el elemento 200 al final");
   Add(200,L1);

   -- recorre la lista
   Recorre(L1);
   Espera;

   -- recorre la lista
   Text_IO.Put_Line("Vuelve a recorrer la lista");
   Recorre2(L1);

   Espera;

   Text_IO.Put_Line("cambia el tercer elemento");
   Rewind(L1,Pos);
   for I in 1..2 loop
      Get_Next_Item(Elem,L1,Pos);
   end loop;
   Update(Pos,103,L1);

   Recorre(L1);


   Pos:=Find(103,L1);
   if Pos=Null_Index then
      Text_IO.Put_Line("No encontrado");
   else
      Elem:=Item(Pos,L1);
      Text_IO.Put_Line("encontrado : "&Integer'Image(Elem));
   end if;

   Text_IO.Put_Line("borra el elemento 103");
   Delete(Pos,L1,Elem);
   Text_IO.Put_Line("borrado : "&Integer'Image(Elem));

   Recorre(L1);

   Text_IO.Put_Line("localiza elemento inexistente");

   Pos:=Find(1002,L1);
   if Pos=Null_Index then
      Text_IO.Put_Line("No encontrado");
   else
      Elem:=Item(Pos,L1);
      Text_IO.Put_Line("encontrado : "&Integer'Image(Elem));
   end if;

   Espera;

   Text_IO.Put_Line("Clonar");

   L2:=Clon(L1);

   Recorre(L2);

   Espera;


end Prueba_Listas_D;

