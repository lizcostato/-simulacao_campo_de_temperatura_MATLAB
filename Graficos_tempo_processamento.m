nos_sem = [16 164 448 868 1424 2116 2944 3908 5008 6244 7616 9124 10768];
nos_com = [16 164 448 868 1424 2116 2944 3908];
% tempo em milissegundos
tempo_sem = [0.9776000 5.411200 18.7945 52.70090 111.6886 218.1690 382.8296 634.2052 923.8358 1320.416 1857.146 2457.647 3178.681];
% tempo em segundos
tempo_com = [9.016405 32.40357 69.96083 117.9710 192.1146 281.5058 397.5227 615.2655];

% Grafico salvando imagens
figure, plot(nos_com, tempo_com);
title('Tempo de processamento quando as imagens são salvas')
xlabel('Número de nós') 
ylabel('Tempo (segundos)') 
% Grafico sem salvar imagens
figure, plot(nos_sem, tempo_sem);
title('Tempo de processamento sem geração de arquivos')
xlabel('Número de nós') 
ylabel('Tempo (milissegundos)') 