%funcao para converter o valor da temperatura em uma cor em RGB
function [R, G, B] = temp_to_color_conv(temp)
    %usando esse caso para o preto das bordas do desenho
    if temp == 900
        R = 0;
        G = 0;
        B = 0;
    %usando esse caso para o branco do fundo do desenho
    elseif temp == 950
        R = 1;
        G = 1;
        B = 1;   
    elseif temp <= 75
		R = 0;
		G = (temp/75);
		B = 1 - (temp/75);
	elseif temp <= 150
		R = (temp/75)-1;
		G = 2-(temp/75);
		B = 0;
    else
        R = 1;
        G = 1;
        B = 1;
    end
end