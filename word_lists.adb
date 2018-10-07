with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Ada.Unchecked_Deallocation;
package body Word_Lists is
   package ATIO renames Ada.Text_IO;
   use type ASU.Unbounded_String;
   
   --Compruebo si la lista está vacía
   function Is_Empty(List: Word_List_Type) return Boolean is
   begin
     return List = null;
   end Is_Empty;

	procedure Free is new Ada.Unchecked_Deallocation(Cell, Word_List_Type);

   procedure Add_Word(List: in out Word_List_Type;
                      Word: in ASU.Unbounded_String) is
      P_Aux: Word_List_Type;--Creador de celdas
		P_Aux_2: Word_List_Type;--Recorre la lista
      Found: Boolean := False;
   begin
		P_Aux := List;
		if Is_Empty(List) then
			P_Aux := new Cell;
			P_Aux.Word := Word;
   	   P_Aux.Count := P_Aux.Count + 1;
   	   P_Aux.Next := List;
   	   List := P_Aux;
		else
			--not Found -> Encontrado
		   while not Found and P_Aux /= null loop
				if P_Aux.Word = Word then
			      P_Aux.Count := P_Aux.Count + 1;
					Found := True;
		    	end if;
				P_Aux_2 := P_Aux;
				P_Aux := P_Aux.Next;
			end loop;
			--Ahora not Found -> No ha sido encontrado,
			--porque Found fue iniciado a False y cambio a True
			if not Found then
				P_Aux := new Cell'(Word, 1, null);
				P_Aux_2.Next := P_Aux;
			end if;
		end if;
   end Add_Word;

   procedure Delete_Word (List: in out Word_List_Type; 
			                 Word: in ASU.Unbounded_String) is
		P_Aux: Word_List_Type;
		P_Aux_2: Word_List_Type;
      Found: Boolean := False;
	begin
		P_Aux := List;
		P_Aux_2 := P_Aux;
		while not Found and P_Aux /= null loop
		   --Si la palabra es la primera de la lista, List
		   --apunta al siguiente y se borra la primera celda
			if P_Aux.Word = Word and P_Aux = List then
				List := P_Aux.Next;
				Free(P_Aux);
				Found := True;
				ATIO.Put_Line("|" & ASU.To_String(Word) & "| deleted");
         elsif P_Aux.Word = Word and P_Aux /= List then
            P_Aux_2.Next := P_Aux.Next;
            Free(P_Aux);
            P_Aux := P_Aux_2.Next;
            Found := True;
				ATIO.Put_Line("|" & ASU.To_String(Word) & "| deleted");
			else
				P_Aux_2 := P_Aux;
				P_Aux := P_Aux.Next;
			end if;
		end loop;
      
	   if not Found then
	      ATIO.Put_Line("This word is not in the list");
	   end if;
	end Delete_Word;

	procedure Search_Word (List: in Word_List_Type;
			                 Word: in ASU.Unbounded_String;
			                 Count: out Natural) is
		P_Aux: Word_List_Type;
		Searched_Word: ASU.unbounded_String;
		Found: Boolean;
	begin
		P_Aux := List;
		Found := False;
		Count := 0;
		while not Found and P_Aux /= null loop
		--Si lo encuentra y existe la lista, lo muestra.
		--Si no, continua recorriendo la lista
			if P_Aux.Word = Word then
				Searched_Word := P_Aux.Word;
				Count := P_Aux.Count;
				Found := True;
				ATIO.Put_Line("|" & ASU.To_String(Searched_Word)
									& "| - " & Natural'Image(Count));
			else
				P_Aux := P_Aux.Next;
			end if;
		end loop;
		if Found = False then
			ATIO.Put_Line("The word you are searching is not in the list");
		end if;
	end Search_Word;

	procedure Max_Word (List: in Word_List_Type;
	                    Word: out ASU.Unbounded_String;
		                 Count: out Natural) is
		P_Aux: Word_List_Type;
	begin
		P_Aux := List;
		Word := P_Aux.Word;
		Count := P_Aux.Count;
		while P_Aux /= null loop
		--Va comparando cada campo Count con el Count de la siguiente celda,
		--si el de la siguiente celda es mayor, se lo guarda y continua
		--hasta que llega al final de la lista
			if Count < P_aux.Count then
				Word := P_Aux.Word;
				Count := P_Aux.Count;
			else
				P_Aux := P_Aux.Next;
			end if;
		end loop;
		ATIO.Put("The most frequent word: |" & ASU.To_String(Word)
					& "| - " & Natural'Image(Count));
	end Max_Word;

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
