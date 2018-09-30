with Ada.Strings.Unbounded;
with Ada.Text_IO;

package body Word_Lists is
   package ATIO renames Ada.Text_IO;
   
   
   --Compruebo si la lista está vacía
   function Is_Empty(List: Word_List_Type) return Boolean is
   begin
     return List = null;
   end Is_Empty;
   
   --Añado palabra a la lista
   procedure Add_Word(List: in out Word_List_Type;
                      Word: in ASU.Unbounded_String) is
      P_Aux: Word_List_Type;
      Found: Boolean := False;
   begin
		if Is_Empty(List) then
			P_Aux := new Cell;
			P_Aux.Word := Word;
   	   P_Aux.Count := P_Aux.Count + 1;
   	   List := P_Aux;
		else
			P_Aux := new Cell;
			P_Aux.Word := Word;
			P_Aux.Count := P_Aux.Count + 1;
			List.Next := P_Aux;
		end if;
--      while not Found and P_Aux /= Null loop
--         P_Aux := new Cell;
--         P_Aux.Word := Word;
--         P_Aux.Count := P_Aux.Count + 1;
--         List.Next := P_Aux;
--         P_Aux := List;
--      end loop;
--       if Found then
--         P_Aux.Count := P_Aux.Count + 1;
--       end if;
   end Add_Word;

   --Imprime todas las palabras de la lista
   procedure Print_All (List: in Word_List_Type) is
      P_Aux: Word_List_Type;
   begin
      if Is_Empty(List) then
         ATIO.Put_Line("No words.");
      else
         P_Aux := List;
         while not Is_Empty(P_Aux) loop
            ATIO.Put("|" & ASU.To_String(P_Aux.Word) & "| - ");
            ATIO.Put_Line(Natural'Image(P_Aux.Count));
            P_Aux := P_Aux.Next;
         end loop;
      end if;
   end;
end;
