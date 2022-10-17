% Valores arbitrados para o trabalho:
    % alfa = 5*10^(-6)m^2/s
    % k = 30W/mK
    % h = 30W/m^2K
	
% x vai multiplicar o minimo de divisoes na malha.
% Quanto maior x, mais dividida a malha.
x = 13;
% Total de nos externos: 56x-4
% Total de nos internos: 68x^2-56x+4
nos_internos = ((68*x*x)-(56*x)+4);

dx = 0.5/x;

% Bi = h*dx/k
    % Para h = 30W/m^2K e k = 30W/mK, Bi = dx
% Criterio de estabilidade: Fo <= 1/(2*(1+Bi))
% Inicializando com a condicao limite
% Inicializando com 50% da condicao limite
Fo = 0.5*(1/(2*(1+dx)));

% Valor arbitrario para a diferenca entre a temperatura de um mesmo ponto
% em dois instantes consecutivos, o qual permite considerar que o sistema
% ja esta em estado estacionario
dif_minima = 0.01;

%forma geometrica (2 pixels pretos representando a borda)
malha = ones((10*x)+4,(14*x)+4);
%so pra deixar toda a imagem inicialmente branca 
malha = malha*950; 	%coloquei 950 como uma flag pra indicar 
						%branco na funcao temp_to_color_conv
% topo
malha(1:2,1:((8*x)+4)) = 900;
% lateral da ponta superior
malha(1:((2*x)+4), ((8*x)+3):((8*x)+4)) = 900;
% base da ponta superior
malha(((2*x)+3):((2*x)+4), ((4*x)+3):((8*x)+4)) = 900;
% lateral entre as duas pontas
malha(((2*x)+3):((5*x)+2), ((4*x)+3):((4*x)+4)) = 900;
% topo da ponta inferior
malha(((5*x)+1):((5*x)+2), ((4*x)+3):((14*x)+4)) = 900;
% lateral da ponta interior
malha(((5*x)+1):((7*x)+4),((14*x)+3):((14*x)+4)) = 900;
% base da ponta interior
malha(((7*x)+3):((7*x)+4),((4*x)+3):((14*x)+4)) = 900;
% lateral abaixo da ponta inferior
malha(((7*x)+3):((10*x)+4),((4*x)+3):((4*x)+4)) = 900;
% base
malha(((10*x)+3):((10*x)+4),1:((4*x)+4)) = 900;
% lateral esquerda
malha(1:((10*x)+4),1:2) = 900;

% Condicoes iniciais
	% temperatura topo: 150K
	malha(3,3:((8*x)+2)) = 150;
	% temperatura lateral da ponta superior: 50K
	malha(3:((2*x)+2), ((8*x)+2)) = 50;
	% temperatura base da ponta superior: 100K
	malha(((2*x)+2), ((4*x)+3):((8*x)+2)) = 100;
	% temperatura lateral entre as duas pontas: 100K
	malha(((2*x)+2):((5*x)+3), ((4*x)+2)) = 100;
	% temperatura topo da ponta inferior: 120K
	malha(((5*x)+3), ((4*x)+3):((14*x)+2)) = 120;
	% temperatura lateral da ponta interior: 50K
	malha(((5*x)+3):((7*x)+2),((14*x)+2)) = 50;
	% temperatura base da ponta interior: 120K
	malha(((7*x)+2),((4*x)+3):((14*x)+2)) = 120;
	% temperatura lateral abaixo da ponta inferior: 100K
	malha(((7*x)+2):((10*x)+2),((4*x)+2)) = 100;
	% temperatura base: 80K
	malha(((10*x)+2),3:((4*x)+2)) = 80;
	% temperatura lateral esquerda: 100K
	malha(3:((10*x)+2),3) = 100;
    
	% inicialmente dentro tudo 0K
	malha(4:((10*x)+1), 4:((4*x)+1)) = 0;
	malha(4:((2*x)+1), ((4*x)+2):((8*x)+1)) = 0;
	malha(((5*x)+4):((7*x)+1), ((4*x)+2):((14*x)+1)) = 0;
	malha(4:((2*x)+1), ((4*x)+2):((8*x)+1)) = 0;
	malha(((5*x)+4):((7*x)+1), ((4*x)+2):((14*x)+1)) = 0;
    
% Proxima temperatura 
	% vetor auxiliar temporario para o calculo da temperatura no instante seguinte
	aux = malha;
	% variavel auxiliar para calcular a diferenca entre a temperatura de um mesmo ponto
	% em dois instantes consecutivos
	diferenca = dif_minima + 1; % inicializado assim para garantir que nao ira comecar
								% ja satisfazendo a condicao de parada
	% contador pra saber quantas vezes a diferenca entre as temperaturas e menor do que um valor arbitrario 
	% (dif_minima), em um mesmo loop
	cont = 0;
    
	% i esta sendo usado so para saber a quantidade de iteracoes foram necessarias ate que a condicao de 
	% parada (diferenca <= dif_minima) fosse satisfeita. 
    i = 1;
        % Inicio da contagem de tempo
        tic
	while (cont ~= nos_internos)
		% Atualizacoes iniciais do loop 
		cont = 0;
        
        for n = 4:1:((2*x)+1)
            for m = 4:1:((8*x)+1)
                aux(n, m) = Fo*(malha(n-1, m)+malha(n+1, m)+malha(n, m-1)+malha(n, m+1))+ (1-4*Fo)*malha(n, m);
				diferenca = aux(n, m) - malha(n, m);
				if (abs(diferenca) < abs(dif_minima))
					cont = cont + 1;
                end
            end
        end
        for n = ((2*x)+2):1:((5*x)+3)
            for m = 4:1:((4*x)+1)
                aux(n, m) = Fo*(malha(n-1, m)+malha(n+1, m)+malha(n, m-1)+malha(n, m+1))+ (1-4*Fo)*malha(n, m);
				diferenca = aux(n, m) - malha(n, m);
				if (abs(diferenca) < abs(dif_minima))
					cont = cont + 1;
                end
            end
        end
        for n = ((5*x)+4):1:((7*x)+1)
            for m = 4:1:((14*x)+1)
                aux(n, m) = Fo*(malha(n-1, m)+malha(n+1, m)+malha(n, m-1)+malha(n, m+1))+ (1-4*Fo)*malha(n, m);
				diferenca = aux(n, m) - malha(n, m);
				if (abs(diferenca) < abs(dif_minima))
					cont = cont + 1;
                end
            end
        end
        for n = ((7*x)+2):1:((10*x)+1)
            for m = 4:1:((4*x)+1)
                aux(n, m) = Fo*(malha(n-1, m)+malha(n+1, m)+malha(n, m-1)+malha(n, m+1))+ (1-4*Fo)*malha(n, m);
				diferenca = aux(n, m) - malha(n, m);
				if (abs(diferenca) < abs(dif_minima))
					cont = cont + 1;
                end
            end
        end
        
		if (cont >= nos_internos)
			fprintf('Condicao de parada satisfeita em %d iterações\n', i)
            fprintf('Cont: %d\n', cont);
            % Finalizando da contagem de tempo
            tempo = toc;
            fprintf('Tempo de processamento: %d segundos\n', tempo);
            fprintf('Total de nos internos: %d\nx: %d\n', nos_internos,x);
		end
        
		% Atualizacoes finais do loop
		malha = aux;
		i = i+1;
    end