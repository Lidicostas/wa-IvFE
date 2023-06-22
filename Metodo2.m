pkg load io


################ - Definição de arquivos de leitura e escrita - ##############

# define o nome do arquivo a ser lido
#fileName = 'arquivo_entrada.csv';
#fileName = 'dataset_A_center_of_sets.csv';
#fileName = 'dataset_A_centroid.csv';

#fileName = 'dataset_B_center_of_sets.csv';
#fileName = 'dataset_B_centroid.csv';

#fileName = 'dataset_C_center_of_sets.csv';
#fileName = 'dataset_C_centroid.csv';

fileName = 'dataset_D_center_of_sets.csv';
#fileName = 'dataset_D_centroid.csv';

# define o nome da funcao de entropia para salvar no arquivo de saida
entropyFunctionName = 'Metodo2';

# define o nome do arquivo de saida
#outPutFileName = 'ResultadoPartes.csv';
#outPutFileName = 'Resultado_saida_A_center_of_sets.csv';
#outPutFileName = 'Resultado_saida_A_centroid.csv';

#outPutFileName = 'Resultado_saida_B_center_of_sets.csv';
#outPutFileName = 'Resultado_saida_B_centroid.csv';

#outPutFileName = 'Resultado_saida_C_center_of_sets.csv';
#outPutFileName = 'Resultado_saida_C_centroid.csv';

outPutFileName = 'Resultado_saida_D_center_of_sets.csv';
#outPutFileName = 'Resultado_saida_D_centroid.csv';

# definie se grava saidas parcias em arquivo de saída
salveResult = true;



if(salveResult)
 arqId = fopen(outPutFileName, 'w'); 
endif;

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

#obten a quantidade de linhas do arquivo
ln = countLinesFile(fileName);


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




# Calcula o diâmetro
function d = diametro(matriz)
   d = abs(matriz(1,2) - matriz(1,1));
endfunction

#Calcula Entropia
function E = entropia(A, k)
    if((2*A)<=1)
      E_inf = (2*A)*k;
      E_sup = 2*A;
    else
      E_inf = (2 - (2*A))*k;
      E_sup =  2 - (2*A);
    endif;
  E = [E_inf, E_sup];
endfunction;

#Adiciona hearder no arquivo de saida entropia geral
arqIdEntropia = fopen(outPutFileName, 'a');
strLinhaHeader = ['entropyFunctionName', ',', 'filename', ',', 'Ew_VLOW_INF', ',' , ' Ew_VLOW_SUP', ',', 'Ew_LOW_INF', ',' , ' Ew_LOW_SUP', ',','Ew_BREASONABLE_INF', ',' , ' Ew_BREASONABLE_SUP', ',', 'Ew_REASONABLE_INF', ',' , ' Ew_REASONABLE_SUP', ',','Ew_HIGH_INF', ',' , ' Ew_HIGH_SUP'];
fputs(arqIdEntropia, [strLinhaHeader, "\n"]);
fclose(arqIdEntropia);


# PROCESSAMENTO

median_very_low = 0;
median_low = 0;
median_bellow_reasonable = 0;
median_reasonable = 0;
median_high = 0;

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
    fprintf('O valor da matriz very low eh %d %d na linha %d \n', matriz_utilization_very_low(1,1), matriz_utilization_very_low(1,2), i);
    fprintf('O valor da matriz low eh %d %d na linha %d \n', matriz_utilization_low(1,1), matriz_utilization_low(1,2), i);
    fprintf('O valor da matriz bellow reasonable eh %d %d na linha %d \n', matriz_utilization_bellow_reasonable(1,1), matriz_utilization_bellow_reasonable(1,2), i);
    #fprintf('O valor da matriz reasonable eh %d %d na linha %d \n', matriz_utilization_reasonable(1,1), matriz_utilization_reasonable(1,2), i);
    #fprintf('O valor da matriz high eh %d %d na linha %d \n', matriz_utilization_high(1,1), matriz_utilization_high(1,2), i);
   endif;
  
    
  A_very_low(i) = rightAgregation(matriz_utilization_very_low);
  A_low(i) = rightAgregation(matriz_utilization_low);
  A_bellow_reasonable(i) = rightAgregation(matriz_utilization_bellow_reasonable);
  A_reasonable(i) = rightAgregation(matriz_utilization_reasonable);
  A_high(i) = rightAgregation(matriz_utilization_high);
endfor;

#Mediana de A(Xi)
median_very_low = median(A_very_low);
median_low = median(A_low);
median_bellow_reasonable = median(A_bellow_reasonable);
median_reasonable = median(A_reasonable);
median_high = median(A_high);
    
fprintf('Mediana de A(X) VERY LOW = %f \n', median_very_low);
fprintf('Mediana de A(X) LOW = %f \n', median_low);
fprintf('Mediana de A(X) BELLOW REASONABLE = %f \n', median_bellow_reasonable);
fprintf('Mediana de A(X) REASONABLE = %f \n', median_reasonable);
fprintf('Mediana de A(X) HIGH = %f \n', median_high);

IntMin_very_low = desagregation(median_very_low);
IntMin_low = desagregation(median_low);
IntMin_bellow_reasonable = desagregation(median_bellow_reasonable);
IntMin_reasonable = desagregation(median_reasonable);
IntMin_high = desagregation(median_high);
printf('A saida da funcao desagregação very low = [%0.8f, %0.8f] \n', IntMin_very_low);
printf('A saida da funcao desagregação low = [%0.8f, %0.8f] \n', IntMin_low);
printf('A saida da funcao desagregação bellow reasonable = [%0.8f, %0.8f] \n', IntMin_bellow_reasonable);

k_very_low = 1 - diametro(IntMin_very_low);
k_low = 1 - diametro(IntMin_low);
k_bellow_reasonable = 1 - diametro(IntMin_bellow_reasonable);
k_reasonable = 1 - diametro(IntMin_reasonable);
k_high = 1 - diametro(IntMin_high);
fprintf('K very low eh %f \n', k_very_low);
fprintf('K very low eh %f \n', k_low);
fprintf('K very low eh %f \n', k_bellow_reasonable);

Everylow = [0.0, 0.0];
Elow = [0.0, 0.0];
Ebellowreasonable = [0.0, 0.0];
Ereasonable = [0.0, 0.0];
Ehigh = [0.0, 0.0];

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
    
    
  A_very_low = rightAgregation(matriz_utilization_very_low);
  A_low = rightAgregation(matriz_utilization_low);
  A_bellow_reasonable = rightAgregation(matriz_utilization_bellow_reasonable);
  A_reasonable = rightAgregation(matriz_utilization_reasonable);
  A_high = rightAgregation(matriz_utilization_high);
  
##  fprintf('A(X) very low eh %f na linha %d \n', A_very_low, i);
##  fprintf('A(X) low eh %f na linha %d \n', A_low, i);
##  fprintf('A(X) bellow reasonable eh %f na linha %d \n', A_bellow_reasonable, i);
  
  Everylow = Everylow + entropia(A_very_low, k_very_low);
  Elow = Elow + entropia(A_low, k_low);
  Ebellowreasonable = Ebellowreasonable + entropia(A_bellow_reasonable, k_bellow_reasonable);
  Ereasonable = Ereasonable + entropia(A_reasonable, k_reasonable);
  Ehigh = Ehigh + entropia(A_high, k_high);
  
  
if(i==(ln - 1))
  fprintf('Everylow eh [%0.8f, %0.8f] na linha %d \n', Everylow, i);
  fprintf('Elow eh [%0.8f, %0.8f] na linha %d \n', Elow, i);
  fprintf('Ebellowreasonable eh [%0.8f, %0.8f] na linha %d \n', Ebellowreasonable, i);
endif;


endfor; 

#Função Ew
Ew_VeryLow_Inf = Everylow(1)/(ln - 1);
Ew_VeryLow_Sup = Everylow(2)/(ln - 1);
Ew_Low_Inf = Elow(1)/(ln - 1);
Ew_Low_Sup = Elow(2)/(ln - 1);
Ew_BellowReasonable_Inf = Ebellowreasonable(1)/(ln - 1);
Ew_BellowReasonable_Sup = Ebellowreasonable(2)/(ln - 1);
Ew_Reasonable_Inf = Ereasonable(1)/(ln - 1);
Ew_Reasonable_Sup = Ereasonable(2)/(ln - 1);
Ew_High_Inf = Ehigh(1)/(ln - 1);
Ew_High_Sup = Ehigh(2)/(ln - 1);
fprintf('Ew_VeryLow = [%f, %f] \n', Ew_VeryLow_Inf, Ew_VeryLow_Sup);
fprintf('Ew_Low = [%f, %f] \n', Ew_Low_Inf, Ew_Low_Sup);
fprintf('Ew_BellowReasonable = [%f, %f] \n', Ew_BellowReasonable_Inf, Ew_BellowReasonable_Sup);
fprintf('Ew_Reasonable = [%f, %f] \n', Ew_Reasonable_Inf, Ew_Reasonable_Sup);
fprintf('Ew_High = [%f, %f] \n', Ew_High_Inf, Ew_High_Sup);

   
    
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
