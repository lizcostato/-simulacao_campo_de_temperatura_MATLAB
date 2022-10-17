% Valores arbitrados para o trabalho:
    % alfa = 5*10^(-6)m^2/s
    % k = 30W/mK
    % h = 30W/m^2K
	
% x vai multiplicar o minimo de divisoes na malha.
% Quanto maior x, mais dividida a malha.
x = 8;
% Total de nos externos: 56x-4
% Total de nos internos: 68x^2-56x+4
nos_internos = ((68*x*x)-(56*x)+4);

dx = 0.5/x;

% Bi = h*dx/k
    % Para h = 30W/m^2K e k = 30W/mK, Bi = dx
% Criterio de estabilidade: Fo <= 1/(2*(1+Bi))
% Inicializando com 50% da condicao limite
Fo = 0.5*(1/(2*(1+dx)));

% Valor arbitrario para a diferenca entre a temperatura de um mesmo ponto
% em dois instantes consecutivos, o qual permite considerar que o sistema
% ja esta em estado estacionario
dif_minima = 0.01;

% Perfis de temperatura
    % Horizontais
        % meio da ponta de cima (4 + (((2x+1)-4)/2)
        y_perfil1 = x + 3;
        perfil1 = zeros(50, 8*x);
        % meio entre as pontas (2x+2 + (((5x+3)-(2x+2))/2)
        y_perfil2 = 2*x+2 + floor(1.5*x+0.5);
        perfil2 = zeros(50, 4*x);
        % meio da ponta de baixo (5x+4 + (((7x+1)-(5x+4))/2)
        y_perfil3 = 6*x + 3;
        perfil3 = zeros(50, ((14*x)));
        % meio abaixo da ponta de baixo 7x+2 + (((10x+1)-(7x+2))/2)
        y_perfil4 = 7*x+2 + floor(1.5*x-0.5);
        perfil4 = zeros(50, 4*x);
    % Vertical
        % meio da parte sem pontas (4 + (((4x+1)-4)/2)
        x_perfil5 = 2*x + 3;
        perfil5 = zeros(50, 10*x);

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
    
	% grafico com formato e todas as temperaturas iniciais
    % vetor que vai receber as cores a serem plotadas
	malha_fig = ones(((10*x)+4),((14*x)+4),3);
    % Converte da temperatura pra cor em RGB
        for n = 1:1:((10*x)+4)
            for m = 1:1:((14*x)+4)
                [malha_fig(n,m,1), malha_fig(n,m,2), malha_fig(n,m,3)] = temp_to_color_conv(malha(n,m));
            end
        end
    figure('visible','off'),
    malha_fig_save = imshow(imresize(malha_fig, [520,720]));
    
% Colorbar das figuras
% Mapa de cores da barra de cores que aparecera ao lado das imagens
cmap = [[0 0 1];[0 0.05 0.95];[0 0.1 0.9];[0 0.15 0.85]
    [0 0.2 0.8];[0 0.25 0.75];[0 0.3 0.7];[0 0.35 0.65]
    [0 0.4 0.6];[0 0.45 0.55];[0 0.5 0.5];[0 0.55 0.45]
    [0 0.6 0.4];[0 0.65 0.35];[0 0.7 0.3];[0 0.75 0.25]
    [0 0.8 0.2];[0 0.85 0.15];[0 0.9 0.1];[0 0.95 0.05]
    [0 1 0];[0.05 0.95 0];[0.1 0.9 0];[0.15 0.85 0]
    [0.2 0.8 0];[0.25 0.75 0];[0.3 0.7 0];[0.35 0.65 0]
    [0.4 0.6 0];[0.45 0.55 0];[0.5 0.5 0];[0.55 0.45 0]
    [0.6 0.4 0];[0.65 0.35 0];[0.7 0.3 0];[0.75 0.25 0]
    [0.8 0.2 0];[0.85 0.15 0];[0.9 0.1 0];[0.95 0.05 0];[1 0 0]];
colormap(cmap);
h=colorbar;
caxis([0 20]);
set(h,'Ticks',[0 2 4 6 8 10 12 14 16 18 20],'TickLabels',{'0k', '15k', '30k', '45k', '60k', '75k', '90k', '105k', '120k', '135k', '150k'});

saveas(malha_fig_save, sprintf('Estado Inicial.png'));

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
	
    % vetores utilizados para plotar os perfis de temperatura
    eixo_perfil1 = 0:8*x*dx/(8*x-1):(8*x)*dx;
    eixo_perfil2e4 = 0:4*x*dx/(4*x-1):(4*x)*dx;
    eixo_perfil3 = 0:14*x*dx/(14*x-1):(14*x)*dx;
    eixo_perfil5 = 0:10*x*dx/(10*x-1):(10*x)*dx;
    
	% i esta sendo usado so para saber a quantidade de iteracoes foram necessarias ate que a condicao de 
	% parada (diferenca <= dif_minima) fosse satisfeita. 
	i = 1;
	
    % Inicio da contagem de tempo
        tic
	while (cont ~= nos_internos)
		% Atualizacoes iniciais do loop 
		cont = 0;
        
        % Atualizando as temperaturas das bordas dos perfis em cada instante de tempo
        perfil1(i, 1) = 100;
        perfil1(i, 8*x) = 50;
        perfil2(i, 1) = 100;
        perfil2(i, 4*x) = 100;
        perfil3(i, 1) = 100;
        perfil3(i, 14*x) = 50;
        perfil4(i, 1) = 100;
        perfil4(i, 4*x) = 100;
        perfil5(i, 1) = 150;
        perfil5(i, 10*x) = 80;
        
		% Calculo das temperaturas do proximo instante
        for n = 4:1:((2*x)+1)
            for m = 4:1:((8*x)+1)
				% Metodo das Diferencas Finitas
                aux(n, m) = Fo*(malha(n-1, m)+malha(n+1, m)+malha(n, m-1)+malha(n, m+1))+ (1-4*Fo)*malha(n, m);
				% Para saber se a condicao de parada foi satisfeita, sempre que a diferenca de temperatura for menor
				% que a diferenca minima estabelecida, o contador e incrementado
				diferenca = aux(n, m) - malha(n, m);
				if (abs(diferenca) < abs(dif_minima))
					cont = cont + 1;
                end
				% Atualizacao dos perfis de temperatura
                if n == y_perfil1
                    perfil1(i, m-2) = aux(n,m);
                end
                if m == x_perfil5
                    perfil5(i, n-2) = aux(n,m);
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
                if n == y_perfil2
                    perfil2(i, m-2) = aux(n,m);
                end
                if m == x_perfil5
                    perfil5(i, n-2) = aux(n,m);
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
                if n == y_perfil3
                    perfil3(i, m-2) = aux(n,m);
                end
                if m == x_perfil5
                    perfil5(i, n-2) = aux(n,m);
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
                if n == y_perfil4
                    perfil4(i, m-2) = aux(n,m);
                end
                if m == x_perfil5
                    perfil5(i, n-2) = aux(n,m);
                end
            end
        end

        % Converte da temperatura pra cor em RGB
        for n = 1:1:((10*x)+4)
            for m = 1:1:((14*x)+4)
                [malha_fig(n,m,1), malha_fig(n,m,2), malha_fig(n,m,3)] = temp_to_color_conv(malha(n,m));
            end
        end

        % Salvar a primeira iteração em imagens
        if (i == 1)
            figure('visible','off'), 
            malha_fig_save = imshow(imresize(malha_fig, [520,720]));
            colormap(cmap);
            h=colorbar;
            caxis([0 20]);
            set(h,'Ticks',[0 2 4 6 8 10 12 14 16 18 20],'TickLabels',{'0k', '15k', '30k', '45k', '60k', '75k', '90k', '105k', '120k', '135k','150k'});
            saveas(malha_fig_save,sprintf('%d.png', 0));
            grafico = figure('visible','off');
            plot(eixo_perfil1,perfil1(i,:));
            title('Perfil 1: y = 4.5m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil1 %d.png', 0));
            grafico = figure('visible','off');
            plot(eixo_perfil2e4,perfil2(i,:));
            title('Perfil 2: y = 3.25m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil2 %d.png', 0));
            grafico = figure('visible','off');
            plot(eixo_perfil1,perfil1(i,:));
            title('Perfil 3: y = 2m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil3 %d.png', 0));
            grafico = figure('visible','off');
            plot(eixo_perfil2e4,perfil4(i,:));
            title('Perfil 4: y = 0.75m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil4 %d.png', 0));
            grafico = figure('visible','off');
            %flip para a parte de baixo da figura ser plotada como y menor
            plot(flip(perfil5(i,:)), eixo_perfil5);
            title('Perfil 5: x = 1m'); 
            xlabel('Temperatura');
            ylabel('Eixo y');
            saveas(grafico, sprintf('perfil5 %d.png', 0));
        end
		
        % So vai salvar imagens a cada 20 iteracoes, a fim de economizar
        % tempo de processamento e memória
		if (mod(i,20) == 0)
            figure('visible','off'), 
            malha_fig_save = imshow(imresize(malha_fig, [520,720]));
            colormap(cmap);
            h=colorbar;
            caxis([0 20]);
            set(h,'Ticks',[0 2 4 6 8 10 12 14 16 18 20],'TickLabels',{'0k', '15k', '30k', '45k', '60k', '75k', '90k', '105k', '120k', '135k','150k'});
            saveas(malha_fig_save,sprintf('%d.png',(i/20)));
            grafico = figure('visible','off');
            plot(eixo_perfil1,perfil1(i,:));
            title('Perfil 1: y = 4.5m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil1 %d.png',(i/20)));
            grafico = figure('visible','off');
            plot(eixo_perfil2e4,perfil2(i,:));
            title('Perfil 2: y = 3.25m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil2 %d.png',(i/20)));
            grafico = figure('visible','off');
            plot(eixo_perfil1,perfil1(i,:));
            title('Perfil 3: y = 2m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil3 %d.png',(i/20)));
            grafico = figure('visible','off');
            plot(eixo_perfil2e4,perfil4(i,:));
            title('Perfil 4: y = 0.75m');
            xlabel('Eixo x'); 
            ylabel('Temperatura');
            saveas(grafico, sprintf('perfil4 %d.png',(i/20)));
            grafico = figure('visible','off');
            %flip para a parte de baixo da figura ser plotada como y menor
            plot(flip(perfil5(i,:)), eixo_perfil5);
            title('Perfil 5: x = 1m'); 
            xlabel('Temperatura');
            ylabel('Eixo y');
            saveas(grafico, sprintf('perfil5 %d.png',(i/20)));
        end
        
		if (cont >= nos_internos)
            %salva a ultima iteracao, caso ainda nao tenha sido salva
            if(mod(i,20)~=0)
                figure('visible','off'), 
                malha_fig_save = imshow(imresize(malha_fig, [520,720]));
                colormap(cmap);
                h=colorbar;
                caxis([0 20]);
                set(h,'Ticks',[0 2 4 6 8 10 12 14 16 18 20],'TickLabels',{'0k', '15k', '30k', '45k', '60k', '75k', '90k', '105k', '120k', '135k','150k'});
                saveas(malha_fig_save,sprintf('%d.png',floor(i/20)+1));
                grafico = figure('visible','off');
                plot(eixo_perfil1,perfil1(i,:));
                title('Perfil 1: y = 4.5m');
                xlabel('Eixo x'); 
                ylabel('Temperatura');
                saveas(grafico, sprintf('perfil1 %d.png',floor(i/20)+1));
                grafico = figure('visible','off');
                plot(eixo_perfil2e4,perfil2(i,:));
                title('Perfil 2: y = 3.25m');
                xlabel('Eixo x'); 
                ylabel('Temperatura');
                saveas(grafico, sprintf('perfil2 %d.png',floor(i/20)+1));
                grafico = figure('visible','off');
                plot(eixo_perfil1,perfil1(i,:));
                title('Perfil 3: y = 2m');
                xlabel('Eixo x'); 
                ylabel('Temperatura');
                saveas(grafico, sprintf('perfil3 %d.png',floor(i/20)+1));
                grafico = figure('visible','off');
                plot(eixo_perfil2e4,perfil4(i,:));
                title('Perfil 4: y = 0.75m');
                xlabel('Eixo x'); 
                ylabel('Temperatura');
                saveas(grafico, sprintf('perfil4 %d.png',floor(i/20)+1));
                grafico = figure('visible','off');
                %flip para a parte de baixo da figura ser plotada como y menor
                plot(flip(perfil5(i,:)), eixo_perfil5);
                title('Perfil 5: x = 1m'); 
                xlabel('Temperatura');
                ylabel('Eixo y');
                saveas(grafico, sprintf('perfil5 %d.png',floor(i/20)+1));
            end
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