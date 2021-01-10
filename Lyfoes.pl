% Remove primeiro elemento do tubo
remove_cabeca([H|T],H,T).

% Inserir novo elemento no inicio do tubo
inserir_cabeca(Tubo, Lyn, [Lyn|Tubo]).

% Verifica se o tubo só tem elementos da mesma cor ou está vazio.
tubo_limpo([]):-!.
tubo_limpo([_|[]]):-!.
tubo_limpo([[A1,_],[A2,_]|T]):- A1 =:= A2,
    tubo_limpo([[A2,_]|T]).

% Verifica se existe outro tubo que possue o mesmos valor informado,
% usado na situação onde tem dois tubos limpos com os mesmos valores.
tubos_iguais([],_):-!,fail.
tubos_iguais([H|T],[A,_]):- elem_iguais(H,A), tubo_limpo(H),
    H \= [],!; tubos_iguais(T,[A,_]).

% Verifica se o primeiro elemento do tubo é igual ao elemento que vai
% inserir ou se o tubo é vazio.
elem_iguais([],_).
elem_iguais([[E,_]|_],E).

% Contenar duas listas é necessario para conseguir inverter a lista
concatena([],List,List).
concatena([H1|T1], List2,[H1|R]):- concatena(T1,List2,R).

% Inverter a ordem dos tubos na lista
inverter_tubos([],[]).
inverter_tubos([H|T],R):- inverter_tubos(T,R2), concatena(R2,[H],R).


% Retirar elemento do tubo misto##
% Primeiro verifica se não foi retirado elemento dos tubos anteriores
% Verifica se o tubo está misto
% Retira primeiro elemento do tubo
% chama a troca novamente até achar um tubo limpo ou vazio
% a resposta retorna os tubos com a troca feita.
troca_tubo([H|T],R,[A,_]):- A =:= 0,
    not(tubo_limpo(H)),
    remove_cabeca(H,Elem2,Tubo),
    troca_tubo(T,R2,Elem2),
    R = [Tubo|R2],!;

% Situação usada para quando temos um tubo limpo com elementos e
% precisamos levar para outro tubo limpo com o mesmo tipo de elementos.
    tubo_limpo(H), H \= [], A =:= 0,
    length(H,Tam), Tam =< 2,
    remove_cabeca(H,Elem2,Tubo),
    tubos_iguais(T,Elem2),
    troca_tubo(T,R2,Elem2),
    R = [Tubo|R2],!.


% Inserir elemento em tubo limpo ou vazio##
% verifica se já foi removido elemento de algum tubo
% verifica se tubo ta limpo ou vazio depois verifica se elemento a ser
% inserido é igual aos que tem no tubo
% retorna o tubo inserido com o restantes dos tubos.
troca_tubo([H|T],R,[A,B]):- A \= 0,
    tubo_limpo(H), elem_iguais(H,A),
    inserir_cabeca(H,[A,B],Tubo),
    R = [Tubo|T],!.

troca_tubo([H|T],[H|R2],Elem):- troca_tubo(T,R2,Elem),!.

% Verifica se todos os tudos estão limpos, cheios ou vazio.
fim_do_jogo([]):-!.
fim_do_jogo([H|T]):- tubo_limpo(H),
                     length(H,Tam), (Tam =:= 4; Tam =:= 0),
                     fim_do_jogo(T).

% Verifica se jogo chegou ao fim,
% se não chegou realiza nova troca de tubos
lyfoes(Tubos,Tubos):- fim_do_jogo(Tubos).
lyfoes(Tubos,R):- troca_tubo(Tubos,R1,[0,0]),
   lyfoes(R1,R),!.
% Se de forma crescente não tiver alteração, inverte a lista de tubos
% para verificar de forma decrescente. Inverte de novo para manter a
% formação original dos tubos.
lyfoes(Tubos,R):- inverter_tubos(Tubos,R2), troca_tubo(R2,R3,[0,0]), inverter_tubos(R3,R4),
   lyfoes(R4,R).


%Testes:
%lynfoes([[[1,1],[2,2],[1,3],[3,4]],[[2,5],[2,6],[3,7],[3,8]],[[1,9],[1,10],[3,11],[2,12]],[],[]],R).
%troca_tubo([[],[[3,11],[3,4],[3,7],[3,8]],[[2,12]],[[1,10],[1,9],[1,3],[1,1]],[[2.6],[2,5],[2,2]]],R,[0,0]).
