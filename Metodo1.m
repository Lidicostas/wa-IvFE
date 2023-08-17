pkg load io


################ - Definição de arquivos de leitura e escrita - ##############

# define o nome do arquivo a ser lido
#fileName = 'dataset_A_center_of_sets.csv';
#fileName = 'dataset_A_centroid.csv';

#fileName = 'dataset_B_center_of_sets.csv';
#fileName = 'dataset_B_centroid.csv';

#fileName = 'dataset_C_center_of_sets.csv';
#fileName = 'dataset_C_centroid.csv';

#fileName = 'dataset_D_center_of_sets.csv';
#fileName = 'dataset_D_centroid.csv';

# define o nome da funcao de entropia para salvar no arquivo de saida
entropyFunctionName = 'Metodo1';

# define o nome do arquivo de saida
#outPutFileName = 'Resultado/saidaSaidas_A_center_of_sets.csv';
#outPutFileName = 'resultados/saida_A_centroid.csv';

#outPutFileName = 'Resultado/saidaSaidas_B_center_of_sets.csv';
#outPutFileName = 'resultados/saida_B_centroid.csv';

#outPutFileName = 'Resultado/saidaSaidas_C_center_of_sets.csv';
#outPutFileName = 'resultados/saida_C_centroid.csv';

#outPutFileName = 'Resultado/saidaSaidas_D_center_of_sets.csv';
#outPutFileName = 'resultados/saida_D_centroid.csv';



#definie se grava saidas parcias em arquivo de saída
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

# obten a quantidade de linhas do arquivo
ln = countLinesFile(fileName);
fprintf('Numero de Linhas = %d \n', ln);

#Cria arquivo de saida
function cf = createOutPutFile(pathFileName)
 cf = fopen(pathFileName, 'w');
endfunction;


### Grava uma linha no arquivo de saida
function arqId = writeLine(fileName, linha)
   arqId = fopen(fileName, 'a');
   fputs(arqId, [linha, "\n"]);
   #fputs(arqId, linha);
   fclose(arqId);
endfunction;



   #Calcula o K
function k = diametro(matriz)
    k = matriz(1,2) - matriz(1,1);
endfunction;



function E = entropia(matriz, k)
    if(matriz(1,1) + matriz(1,2)<=1)
      E_inf = (matriz(1,1) + matriz(1,2))*k;
      E_sup = matriz(1,1) + matriz(1,2);
    else
      E_inf = (2 - (matriz(1,1) + matriz(1,2)))*k;
      E_sup = 2 - (matriz(1,1) + matriz(1,2));
    endif;
  E = [E_inf, E_sup];
endfunction;


#Adiciona hearder no arquivo de saida entropia geral
arqIdEntropia = fopen(outPutFileName, 'a');
strLinhaHeader = ['entropyFunctionName', ',', 'filename', ',', 'lowerVeryLow', ',' , ' upperVeryLow', ',' , 'lowerLow', ',' , ' upperLow', ',', 'lowerBellowReasonable', ',' ,'upperBellowReasonable', ',', 'lowerReasonableNorm', ',' ,'upperReasonableNorm', ',', 'lowerHigh', ',' ,'upperHigh'];
fputs(arqIdEntropia, [strLinhaHeader, "\n"]);
fclose(arqIdEntropia);


# PROCESSAMENTO

somaDiametros_very_low =0;
somaDiametros_low = 0;
somaDiametros_bellow_reasonable = 0;
#somaDiametros_reasonable = 0;
#somaDiametros_high = 0;
  


  #itera sobre as linhas do arquivo
  for i=1:(ln - 1)
    #https://octave.sourceforge.io/list_functions.php?q=dlmread&sort=package
    #                                                [linha, coluna, linha, coluna]
    matriz_utilization_very_low = dlmread(fileName, ',',  [i, 18, i, 19]);
    matriz_utilization_low = dlmread(fileName, ',',  [i, 20, i, 21]);
    matriz_utilization_bellow_reasonable = dlmread(fileName, ',',  [i, 22, i, 23]);
    #matriz_utilization_reasonable = dlmread(fileName, ',',  [i, 130, i, 131]);
    #matriz_utilization_high = dlmread(fileName, ',',  [i, 132, i, 133]);


   if(i<=3)
    fprintf('O valor da matriz very low eh %d %d na linha %d \n', matriz_utilization_very_low(1,1), matriz_utilization_very_low(1,2), i);
    fprintf('O valor da matriz low eh %d %d na linha %d \n', matriz_utilization_low(1,1), matriz_utilization_low(1,2), i);
    fprintf('O valor da matriz bellow reasonable eh %d %d na linha %d \n', matriz_utilization_bellow_reasonable(1,1), matriz_utilization_bellow_reasonable(1,2), i);
    #fprintf('O valor da matriz reasonable eh %d %d na linha %d \n', matriz_utilization_reasonable(1,1), matriz_utilization_reasonable(1,2), i);
    #fprintf('O valor da matriz high eh %d %d na linha %d \n', matriz_utilization_high(1,1), matriz_utilization_high(1,2), i);
   endif;

    somaDiametros_very_low = somaDiametros_very_low + diametro(matriz_utilization_very_low);
    somaDiametros_low = somaDiametros_low + diametro(matriz_utilization_low);
    somaDiametros_bellow_reasonable = somaDiametros_bellow_reasonable + diametro(matriz_utilization_bellow_reasonable);
    #somaDiametros_reasonable = somaDiametros_reasonable + diametro(matriz_utilization_reasonable);
    #somaDiametros_high = somaDiametros_high + diametro(matriz_utilization_high);
  endfor;


   kw_very_low =  1 - (somaDiametros_very_low/(ln - 1));
   kw_low = 1 - (somaDiametros_low/(ln - 1));
   kw_bellow_reasonable =  1 - (somaDiametros_bellow_reasonable/(ln - 1));
   #kw_reasonable =  1 - (somaDiametros_reasonable/(ln - 1));
   #kw_high =  1 - (somaDiametros_high/(ln - 1));
   
   fprintf('k VERY LOW = %d \n', kw_very_low);
   fprintf('k LOW = %d \n', kw_low);
   fprintf('k BELLOW REASONABLE = %d \n', kw_bellow_reasonable);
   #fprintf('k REASONABLE = %d \n', kw_reasonable);
   #fprintf('k HIGH = %d \n', kw_high);
   

   E_VeryLowInf = 0; E_VeryLowSup = 0;
   E_LowInf = 0; E_LowSup = 0;
   E_BellowReasonableInf = 0; E_BellowReasonableSup = 0;
   #E_ReasonableInf = 0; E_ReasonableSup = 0;
   #E_HighInf = 0; E_HighSup = 0;


  for i=1:(ln - 1)

    matriz_utilization_very_low = dlmread(fileName, ',',  [i, 24, i, 25]);
    matriz_utilization_low = dlmread(fileName, ',',  [i, 26, i, 27]);
    matriz_utilization_bellow_reasonable = dlmread(fileName, ',',  [i, 28, i, 29]);
    #matriz_utilization_reasonable = dlmread(fileName, ',',  [i, 30, i, 31]);
    #matriz_utilization_high = dlmread(fileName, ',',  [i, 32, i, 33]);


    E_VeryLow = entropia(matriz_utilization_very_low, kw_very_low);
    E_Low = entropia(matriz_utilization_low, kw_low);
    E_BellowReasonable = entropia(matriz_utilization_bellow_reasonable, kw_bellow_reasonable);
    #E_Reasonable = entropia(matriz_utilization_reasonable, kw_reasonable);
    #E_High = entropia(matriz_utilization_high, kw_high);
    
    if(i<=2)
      fprintf('E_VeryLow(1) %d na linha %d \n', E_VeryLow(1), i);
      fprintf('E_VeryLow(2) %d na linha %d \n', E_VeryLow(2), i);
      fprintf('E_Low(1) %d na linha %d \n', E_Low(1), i);
      fprintf('E_Low(2) %d na linha %d \n', E_Low(2), i);
      fprintf('E_BellowReasonable(1) %d na linha %d \n', E_BellowReasonable(1), i);
      fprintf('E_BellowReasonable(2) %d na linha %d \n', E_BellowReasonable(2), i);
##      fprintf('E_Reasonable(1) %d na linha %d \n', E_Reasonable(1), i);
##      fprintf('E_Reasonable(2) %d na linha %d \n', E_Reasonable(2), i);
##      fprintf('E_High(1) %d na linha %d \n', E_High(1), i);
##      fprintf('E_High(2) %d na linha %d \n', E_High(2), i);
    endif;


    E_VeryLowInf = E_VeryLowInf + E_VeryLow(1);
    E_VeryLowSup = E_VeryLowSup + E_VeryLow(2);

    E_LowInf = E_LowInf + E_Low(1);
    E_LowSup = E_LowSup + E_Low(2);

    E_BellowReasonableInf = E_BellowReasonableInf + E_BellowReasonable(1);
    E_BellowReasonableSup = E_BellowReasonableSup + E_BellowReasonable(2);

##    E_ReasonableInf = E_ReasonableInf + E_Reasonable(1);
##    E_ReasonableSup = E_ReasonableSup + E_Reasonable(2);
##
##    E_HighInf = E_HighInf + E_High(1);
##    E_HighSup = E_HighSup + E_High(2);
    
    
    if(i<=2)
      fprintf('E_VeryLowInf %d na linha %d \n', E_VeryLowInf, i);
      fprintf('E_VeryLowSup %d na linha %d \n', E_VeryLowSup, i);
      fprintf('E_LowInf %d na linha %d \n', E_LowInf, i);
      fprintf('E_LowSup %d na linha %d \n', E_LowSup, i);
      fprintf('E_BellowReasonableInf %d na linha %d \n', E_BellowReasonableInf, i);
      fprintf('E_BellowReasonableSup %d na linha %d \n', E_BellowReasonableSup, i);
##      fprintf('E_ReasonableInf %d na linha %d \n', E_ReasonableInf, i);
##      fprintf('E_ReasonableSup %d na linha %d \n', E_ReasonableSup, i);
##      fprintf('E_HighInf %d na linha %d \n', E_HighInf, i);
##      fprintf('E_HighSup %d na linha %d \n', E_HighSup, i);
    endif;
    

   endfor;
   
  Entropia_VeryLow_Inf = E_VeryLowInf/(ln - 1);
  Entropia_VeryLow_Sup = E_VeryLowSup/(ln - 1);

  Entropia_Low_Inf = E_LowInf/(ln - 1);
  Entropia_Low_Sup = E_LowSup/(ln - 1);

  Entropia_BellowReasonable_Inf = E_BellowReasonableInf/(ln - 1);
  Entropia_BellowReasonable_Sup = E_BellowReasonableSup/(ln - 1);

##  Entropia_Reasonable_Inf = E_ReasonableInf/(ln - 1);
##  Entropia_Reasonable_Sup = E_ReasonableSup/(ln - 1);
##
##  Entropia_High_Inf = E_HighInf/(ln - 1);
##  Entropia_High_Sup = E_HighSup/(ln - 1);

  fprintf('Entropia Intervalar VERY LOW = [%d, %d] \n', Entropia_VeryLow_Inf, Entropia_VeryLow_Sup);
  fprintf('Entropia Intervalar LOW = [%d, %d] \n', Entropia_Low_Inf, Entropia_Low_Sup);
  fprintf('Entropia Intervalar BELLOW REASONABLE = [%d, %d] \n', Entropia_BellowReasonable_Inf, Entropia_BellowReasonable_Sup);
  #fprintf('Entropia Intervalar REASONABLE = [%d, %d] \n', Entropia_Reasonable_Inf, Entropia_Reasonable_Sup);
  #fprintf('Entropia Intervalar HIGH = [%d, %d] \n', Entropia_High_Inf, Entropia_High_Sup);


  
  


    
 if(salveResult)
 fclose(arqId);
 endif;


 arqIdEntropia = fopen(outPutFileName, 'a');

 strLinhaEntropia = [entropyFunctionName, ',', fileName, ',', num2str(Entropia_VeryLow_Inf), ',' , num2str(Entropia_VeryLow_Sup), ',' , num2str(Entropia_Low_Inf), ',' , num2str(Entropia_Low_Sup), ',', num2str(Entropia_BellowReasonable_Inf), ',' ,num2str(Entropia_BellowReasonable_Sup), ',', num2str(Entropia_Reasonable_Inf), ',' ,num2str(Entropia_Reasonable_Sup), ',', num2str(Entropia_High_Inf), ',' ,num2str(Entropia_High_Sup) ];
 fputs(arqIdEntropia, [strLinhaEntropia, "\n"]);
 
fclose(arqIdEntropia);


fprintf('Processamento realizado! \n');
