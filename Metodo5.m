pkg load io

################ - Definição de arquivos de leitura e escrita - ##############

# define o nome do arquivo a ser lido
#fileName = 'dataset_A_center_of_sets.csv';
#fileName = 'dataset_A_centroid.csv';

#fileName = 'dataset_B_center_of_sets.csv';
#fileName = 'dataset_B_centroid.csv';

#fileName = 'dataset_C_center_of_sets.csv';
#fileName = 'dataset_C_centroid.csv';

fileName = 'dataset_D_center_of_sets.csv';
#fileName = 'dataset_D_centroid.csv';

# define o nome da funcao de entropia para salvar no arquivo de saida
entropyFunctionName = 'Metodo5';

# define o nome do arquivo de saida
#outPutFileName = 'results/saida_A_center_of_sets.csv';
#outPutFileName = 'results/saida_A_centroid.csv';

#outPutFileName = 'results/saida_B.csv';
#outPutFileName = 'results/saida_B_centroid.csv';

#outPutFileName = 'results/saida_C.csv';
#outPutFileName = 'results/saida_C_centroid.csv';

outPutFileName = 'results/saida_D.csv';
#outPutFileName = 'results/saida_D_centroid.csv';

# definie se grava saidas parcias em arquivo de saída
salveResult = true;



if(salveResult)
 arqId = fopen(outPutFileName, 'w'); 
endif;


################ - Inicializa variáveis globais - ###############



################# - Definicao de funções - ######################

# Conta a quantidade de linhas do arquivo
function lines = countLinesFile(fileName)
  arqId = fopen(fileName, "r");
  if(arqId == -1)
    fprintf("Erro o arquivo %s, nao foi localizado!\n", fileName);
    return;
  else
     fprintf("O arquivo %s foi localizado, processando!\n", fileName);
     cont_lines=0;
     while (!feof(arqId))
       cont_lines++;
       linha = fgets(arqId);
       #fprintf('%s', linha);
     endwhile;
   fprintf('Total de linhas do arquivo eh %d \n',cont_lines);
   lines = cont_lines;
   fclose(arqId);
  endif;
endfunction;


# Cria arquivo de saida
function cf = createOutPutFile(pathFileName)
 cf = fopen(pathFileName, 'w');
endfunction;


# Grava uma linha no arquivo de saida
function arqId = writeLine(fileName, linha)
   arqId = fopen(fileName, 'a');
   fputs(arqId, [linha, "\n"]);
   #fputs(arqId, linha);
   fclose(arqId);
endfunction;

function result = rightAgregation(matriz)
  #converter os valores para string considerando 6 casas decimais
  strValInf = num2str(matriz(1,1), '%0.6f');
  strValSup = num2str(matriz(1,2), '%0.6f');

  result = strcat('0.', strValInf(3), strValSup(3), strValInf(4), strValSup(4), strValInf(5), strValSup(5), strValInf(6), strValSup(6), strValInf(7), strValSup(7), strValInf(8), strValSup(8));
  
  result = str2num(result);
endfunction

function result = leftAgregation(matriz)
  #converter os valores para string considerando 6 casas decimais
  strValInf = num2str(matriz(1,1), '%0.6f');
  strValSup = num2str(matriz(1,2), '%0.6f');

  result = strcat('0.', strValSup(3), strValInf(3), strValSup(4), strValInf(4), strValSup(5), strValInf(5), strValSup(6), strValInf(6), strValSup(7), strValInf(7), strValSup(8), strValInf(8));
  
  result = str2num(result);
endfunction


function IntervaloX =  desagregation(value)
  #converte value para string
  strValue = num2str(value, '%0.12f');
  
  if (str2num(strValue(3)) < str2num(strValue(4)))
     xInf = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
     xSup = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
  elseif (str2num(strValue(3)) > str2num(strValue(4)))
     xInf = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
     xSup = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
  elseif (str2num(strValue(3)) == str2num(strValue(4)))
     if (str2num(strValue(5)) < str2num(strValue(6)))
       xInf = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
       xSup = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
     elseif (str2num(strValue(5)) > str2num(strValue(6)))
       xInf = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
       xSup = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
     elseif (str2num(strValue(5)) == str2num(strValue(6)))
       if (str2num(strValue(7)) < str2num(strValue(8)))
         xInf = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
         xSup = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
       elseif (str2num(strValue(7)) > str2num(strValue(8))) 
         xInf = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
         xSup = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
       elseif (str2num(strValue(7)) == str2num(strValue(8)))
           xInf = strcat('0.', strValue(3), strValue(5), strValue(7), strValue(9), strValue(11), strValue(13));
           xSup = strcat('0.', strValue(4), strValue(6), strValue(8), strValue(10), strValue(12), strValue(14));
           fprintf('ENTROU AQUI IGUAIS \n');
       endif
     endif
  endif

  IntervaloX = [str2num(xInf), str2num(xSup)];
endfunction




#Calcula a Negação Intervalar
function Na = negacao(matriz)
  if(matriz(1,1)<=0.8);
    Na = desagregation((1 - (0.25*(rightAgregation(matriz)))));
  else
    Na = desagregation(4*(1 - rightAgregation(matriz)));
  endif;
  %fprintf('NA = [%f, %f] \n', Na);
endfunction




#Calcula a Negação Fuzzy
function Nef = fuzzynegation(value)
  if(value<=0.8);
    Nef = 1 - (0.25*value);
  else
    Nef = 4 - (4*value);
  endif;
  %fprintf('Negação Fuzzy = %f \n', Nef);
endfunction


# Calcula o diâmetro
function d = diametro(matriz)
   d = abs(matriz(1,2) - matriz(1,1));
endfunction





#Calcula função R
function R = entropia(matriz)
  R_inf = max(0, fuzzynegation(abs(rightAgregation(matriz) - rightAgregation(negacao(matriz)))) - max(diametro(matriz), diametro(negacao(matriz))));
  R_sup = fuzzynegation(abs(rightAgregation(matriz) - rightAgregation(negacao(matriz))));
  R = [R_inf, R_sup];
endfunction;



#Adiciona hearder no arquivo de saida entropia geral
arqIdEntropia = fopen(outPutFileName, 'a');
strLinhaHeader = ['entropyFunctionName', ',', 'filename', ',', 'lowerVeryLow', ',' , ' upperVeryLow', ',' , 'lowerLow', ',' , ' upperLow', ',', 'lowerBellowReasonable', ',' ,'upperBellowReasonable', ',', 'lowerReasonableNorm', ',' ,'upperReasonableNorm', ',', 'lowerHigh', ',' ,'upperHigh'];
fputs(arqIdEntropia, [strLinhaHeader, "\n"]);
fclose(arqIdEntropia);


# PROCESSAMENTO
 

  # obten a quantidade de linhas do arquivo
  ln = countLinesFile(fileName);

  R_very_Low = [0.0, 0.0];
  R_Low = [0.0, 0.0];
  R_bellow_Reasonable = [0.0, 0.0];
  R_Reasonable = [0.0, 0.0];
  R_High = [0.0, 0.0];


#itera sobre as linhas do arquivo
for i=1:(ln - 1)
  #https://octave.sourceforge.io/list_functions.php?q=dlmread&sort=package
  #                                                [linha, coluna, linha, coluna]
  matriz_utilization_very_low = dlmread(fileName, ',',  [i, 124, i, 125]);
  if (matriz_utilization_very_low(1,1) == 1.0)
    matriz_utilization_very_low(1,1) = 0.999999;
  endif;
  if (matriz_utilization_very_low(1,2) == 1.0)
    matriz_utilization_very_low(1,2) = 0.999999;
  endif;
  
  matriz_utilization_low = dlmread(fileName, ',',  [i, 126, i, 127]);
  if (matriz_utilization_low(1,1) == 1.0)
    matriz_utilization_low(1,1) = 0.999999;
  endif;
  if (matriz_utilization_low(1,2) == 1.0)
    matriz_utilization_low(1,2) = 0.999999;
  endif;

  matriz_utilization_bellow_reasonable = dlmread(fileName, ',',  [i, 128, i, 129]);
  if (matriz_utilization_bellow_reasonable(1,1) == 1.0)
    matriz_utilization_bellow_reasonable(1,1) = 0.999999;
  endif;
  if (matriz_utilization_bellow_reasonable(1,2) == 1.0)
    matriz_utilization_bellow_reasonable(1,2) = 0.999999;
  endif;
  
  matriz_utilization_reasonable = dlmread(fileName, ',',  [i, 130, i, 131]);
  if (matriz_utilization_reasonable(1,1) == 1.0)
    matriz_utilization_reasonable(1,1) = 0.999999;
  endif;
  if (matriz_utilization_reasonable(1,2) == 1.0)
    matriz_utilization_reasonable(1,2) = 0.999999;
  endif;

  matriz_utilization_high = dlmread(fileName, ',',  [i, 132, i, 133]);
  if (matriz_utilization_high(1,1) == 1.0)
    matriz_utilization_high(1,1) = 0.999999;
  endif;
  if (matriz_utilization_high(1,2) == 1.0)
    matriz_utilization_high(1,2) = 0.999999;
  endif;



 if(i<=3)
  fprintf('O valor da matriz very low eh %f %f na linha %d \n', matriz_utilization_very_low(1,1), matriz_utilization_very_low(1,2), i);
  fprintf('O valor da matriz low eh %f %f na linha %d \n', matriz_utilization_low(1,1), matriz_utilization_low(1,2), i);
  fprintf('O valor da matriz bellow reasonable eh %d %d na linha %d \n', matriz_utilization_bellow_reasonable(1,1), matriz_utilization_bellow_reasonable(1,2), i);
  fprintf('O valor da matriz reasonable eh %f %f na linha %d \n', matriz_utilization_reasonable(1,1), matriz_utilization_reasonable(1,2), i);
  fprintf('O valor da matriz high eh %f %f na linha %d \n', matriz_utilization_high(1,1), matriz_utilization_high(1,2), i);
 endif;
 
 
 
## if(i<=3)
##  fprintf('Diâmetro da matriz very low eh %f na linha %d \n', diametro(matriz_utilization_very_low), i);
##  
##  fprintf('Diâmetro da negação da matriz very low eh %f na linha %d \n', diametro(negacao(matriz_utilization_very_low)), i);
##  
##  fprintf('MAXIMO ENTRE Diâmetros matriz very low eh %f na linha %d \n', max(diametro(matriz_utilization_very_low), diametro(negacao(matriz_utilization_very_low))), i);
##  
##  fprintf('Agrega matriz matriz very low eh %f na linha %d \n', rightAgregation(matriz_utilization_very_low), i);
##  fprintf('Agrega NEGACAO da matriz very low eh %f na linha %d \n', rightAgregation(negacao(matriz_utilization_very_low)), i);
##  fprintf('RESULTADO do Módulo na matriz very low eh %f na linha %d \n', abs(rightAgregation(matriz_utilization_very_low) - rightAgregation(negacao(matriz_utilization_very_low))), i);
##  fprintf('NEGACAO FUZZY da matriz very low eh %f na linha %d \n', fuzzynegation(abs(rightAgregation(matriz_utilization_very_low) - rightAgregation(negacao(matriz_utilization_very_low)))), i);
##  fprintf('O valor da matriz very low eh %f na linha %d \n', fuzzynegation(abs(rightAgregation(matriz_utilization_very_low) - rightAgregation(negacao(matriz_utilization_very_low)))), i);
##  fprintf('O valor da matriz very low eh %f na linha %d \n', fuzzynegation(abs(rightAgregation(matriz_utilization_very_low) - rightAgregation(negacao(matriz_utilization_very_low)))), i);

## endif;
 
  
  #Função S
  R_very_Low = R_very_Low + entropia(matriz_utilization_very_low);
  R_Low = R_Low + entropia(matriz_utilization_low);
  R_bellow_Reasonable = R_bellow_Reasonable + entropia(matriz_utilization_bellow_reasonable);
  R_Reasonable = R_Reasonable + entropia(matriz_utilization_reasonable);
  R_High = R_High + entropia(matriz_utilization_high);

 
    fprintf('R_very_Low = [%f, %f] \n', R_very_Low);
    fprintf('R_Low = [%f, %f] \n', R_Low);
    fprintf('R_bellow_Reasonable = [%f, %f] \n', R_bellow_Reasonable);
    fprintf('R_Reasonable = [%f, %f] \n', R_Reasonable);
    fprintf('R_High = [%f, %f] \n', R_High);

endfor  


    #Função Ew
    Ew_VeryLow_Inf = R_very_Low(1)/(ln - 1);
    Ew_VeryLow_Sup = R_very_Low(2)/(ln - 1);
    fprintf('Entropia Intervalar VERY LOW = [%f, %f] \n', Ew_VeryLow_Inf, Ew_VeryLow_Sup);
    
    Ew_Low_Inf = R_Low(1)/(ln - 1);
    Ew_Low_Sup = R_Low(2)/(ln - 1);
    fprintf('Entropia Intervalar LOW = [%f, %f] \n', Ew_Low_Inf, Ew_Low_Sup);
    
    Ew_BellowReasonable_Inf = R_bellow_Reasonable(1)/(ln - 1);
    Ew_BellowReasonable_Sup = R_bellow_Reasonable(2)/(ln - 1);
    fprintf('Entropia Intervalar BELLOW REASONABLE = [%f, %f] \n', Ew_BellowReasonable_Inf, Ew_BellowReasonable_Sup);
    
    Ew_Reasonable_Inf = R_Reasonable(1)/(ln - 1);
    Ew_Reasonable_Sup = R_Reasonable(2)/(ln - 1);
    fprintf('Entropia Intervalar REASONABLE = [%f, %f] \n', Ew_Reasonable_Inf, Ew_Reasonable_Sup);
    
    Ew_High_Inf = R_High(1)/(ln - 1);
    Ew_High_Sup = R_High(2)/(ln - 1);
    fprintf('Entropia Intervalar HIGH = [%f, %f] \n', Ew_High_Inf, Ew_High_Sup);


    
 if(salveResult)
 fclose(arqId);
 endif;


 arqIdEntropia = fopen(outPutFileName, 'a');

strLinhaEntropia = [entropyFunctionName, ',', fileName, ',' , num2str(Ew_VeryLow_Inf), ',' , num2str(Ew_VeryLow_Sup), ',' , num2str(Ew_Low_Inf), ',' , num2str(Ew_Low_Sup), ',', num2str(Ew_BellowReasonable_Inf), ',' , num2str(Ew_BellowReasonable_Sup), ',', num2str(Ew_Reasonable_Inf), ',' , num2str(Ew_Reasonable_Sup), ',' , num2str(Ew_High_Inf), ',' , num2str(Ew_High_Sup) ];
fputs(arqIdEntropia, [strLinhaEntropia, "\n"]);
 
 
##strLinhaEntropia = [entropyFunctionName, ',' ,fileName, ',' , num2str(Ew_VeryLow_Inf), ',' , num2str(Ew_VeryLow_Sup), ',' , num2str(Ew_Low_Inf), ',' , num2str(Ew_Low_Sup), ',' , num2str(Ew_BellowReasonable_Inf), ',' , num2str(Ew_BellowReasonable_Sup) ];
##fputs(arqIdEntropia, [strLinhaEntropia, "\n"]);

 
 fclose(arqIdEntropia);


fprintf('Processamento realizado! \n');
