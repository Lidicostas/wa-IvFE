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
fileName = 'dataset_D_centroid.csv';

# define o nome da funcao de entropia para salvar no arquivo de saida
entropyFunctionName = 'Sxy';

# define o nome do arquivo de saida
#outPutFileName = 'results/saida_A_center_of_sets.csv';
#outPutFileName = 'results/saida_A_centroid.csv';

#outPutFileName = 'results/saida_B.csv';
#outPutFileName = 'results/saida_B_centroid.csv';

#outPutFileName = 'results/saida_C.csv';
#outPutFileName = 'results/saida_C_centroid.csv';

#outPutFileName = 'results/saida_D.csv';
outPutFileName = 'results/saida_D_centroid.csv';



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



# Calcula o ponto médio
function pm = pontomedio(matriz)
   pm = (matriz(1,1) + matriz(1,2))/2.0;
endfunction


# Calcula o diâmetro
function d = diametro(matriz)
   d = abs(matriz(1,2) - matriz(1,1));
endfunction


#Adiciona hearder no arquivo de saida entropia geral
arqIdEntropia = fopen(outPutFileName, 'a');
strLinhaHeader = ['entropyFunctionName', ',', 'filename', ',', 'lowerVeryLow', ',' , ' upperVeryLow', ',' , 'lowerLow', ',' , ' upperLow', ',', 'lowerBellowReasonable', ',' ,'upperBellowReasonable', ',', 'lowerReasonableNorm', ',' ,'upperReasonableNorm', ',', 'lowerHigh', ',' ,'upperHigh'];
fputs(arqIdEntropia, [strLinhaHeader, "\n"]);
fclose(arqIdEntropia);


# PROCESSAMENTO
 
 Acum_S_inf_VERY_LOW = 0; Acum_S_sup_VERY_LOW = 0;
 Acum_S_inf_LOW = 0; Acum_S_sup_LOW = 0;
 Acum_S_inf_BELLOW_REASONABLE = 0; Acum_S_sup_BELLOW_REASONABLE = 0;
## Acum_S_inf_REASONABLE = 0; Acum_S_sup_REASONABLE = 0;
## Acum_S_inf_HIGH = 0; Acum_S_sup_HIGH = 0;

  # obten a quantidade de linhas do arquivo
  ln = countLinesFile(fileName);


  #itera sobre as linhas do arquivo
  for i=1:(ln - 1)
    #https://octave.sourceforge.io/list_functions.php?q=dlmread&sort=package
    #                                                [linha, coluna, linha, coluna]
    matriz_utilization_very_low = dlmread(fileName, ',',  [i, 18, i, 19]);
    if (matriz_utilization_very_low(1,1) == 1.0)
      matriz_utilization_very_low(1,1) = 0.999999;
    endif;
    if (matriz_utilization_very_low(1,2) == 1.0)
      matriz_utilization_very_low(1,2) = 0.999999;
    endif;
    
    matriz_utilization_low = dlmread(fileName, ',',  [i, 20, i, 21]);
    if (matriz_utilization_low(1,1) == 1.0)
      matriz_utilization_low(1,1) = 0.999999;
    endif;
    if (matriz_utilization_low(1,2) == 1.0)
      matriz_utilization_low(1,2) = 0.999999;
    endif;

    matriz_utilization_bellow_reasonable = dlmread(fileName, ',',  [i, 22, i, 23]);
    if (matriz_utilization_bellow_reasonable(1,1) == 1.0)
      matriz_utilization_bellow_reasonable(1,1) = 0.999999;
    endif;
    if (matriz_utilization_bellow_reasonable(1,2) == 1.0)
      matriz_utilization_bellow_reasonable(1,2) = 0.999999;
    endif;
    
##    matriz_utilization_reasonable = dlmread(fileName, ',',  [i, 30, i, 31]);
##    if (matriz_utilization_reasonable(1,1) == 1.0)
##      matriz_utilization_reasonable(1,1) = 0.999999;
##    endif;
##    if (matriz_utilization_reasonable(1,2) == 1.0)
##      matriz_utilization_reasonable(1,2) = 0.999999;
##    endif;
##
##    matriz_utilization_high = dlmread(fileName, ',',  [i, 32, i, 33]);
##    if (matriz_utilization_high(1,1) == 1.0)
##      matriz_utilization_high(1,1) = 0.999999;
##    endif;
##    if (matriz_utilization_high(1,2) == 1.0)
##      matriz_utilization_high(1,2) = 0.999999;
##    endif;



   if(i<=3)
    fprintf('O valor da matriz very low eh %d %d na linha %d \n', matriz_utilization_very_low(1,1), matriz_utilization_very_low(1,2), i);
    fprintf('O valor da matriz low eh %d %d na linha %d \n', matriz_utilization_low(1,1), matriz_utilization_low(1,2), i);
    fprintf('O valor da matriz bellow reasonable eh %d %d na linha %d \n', matriz_utilization_bellow_reasonable(1,1), matriz_utilization_bellow_reasonable(1,2), i);
    #fprintf('O valor da matriz reasonable eh %d %d na linha %d \n', matriz_utilization_reasonable(1,1), matriz_utilization_reasonable(1,2), i);
    #fprintf('O valor da matriz high eh %d %d na linha %d \n', matriz_utilization_high(1,1), matriz_utilization_high(1,2), i);
   endif;

    
    # Negação
    matriz_utilization_very_low_N = negacao(matriz_utilization_very_low);
    matriz_utilization_low_N = negacao(matriz_utilization_low);
    matriz_utilization_bellow_reasonable_N = negacao(matriz_utilization_bellow_reasonable);
    #matriz_utilization_reasonable_N = negacao(matriz_utilization_reasonable);
    #matriz_utilization_high_N = negacao(matriz_utilization_high);
    %fprintf('NVLow_inf = %d, NVLow_sup = %d, NLow_inf = %d, NLow_sup = %d, NBReasonable_inf = %d, NBReasonable_sup = %d, NReasonable_inf = %d, NReasonable_sup = %d, NHigh_inf = %d, NHigh_sup = %d, na linha %d \n', matriz_utilization_very_low_N(1,1), matriz_utilization_very_low_N(1,2), matriz_utilization_low_N(1,1), matriz_utilization_low_N(1,2), matriz_utilization_bellow_reasonable_N(1,1), matriz_utilization_bellow_reasonable_N(1,2), matriz_utilization_reasonable_N(1,1), matriz_utilization_reasonable_N(1,2), matriz_utilization_high_N(1,1), matriz_utilization_high_N(1,2), i);

 
    # Ponto Médio
    pmvl= pontomedio(matriz_utilization_very_low);
    pmvlN= pontomedio(matriz_utilization_very_low_N);
    pml= pontomedio(matriz_utilization_low);
    pmlN= pontomedio(matriz_utilization_low_N);
    pmbr = pontomedio(matriz_utilization_bellow_reasonable);
    pmbrN = pontomedio(matriz_utilization_bellow_reasonable_N);
##    pmr = pontomedio(matriz_utilization_reasonable);
##    pmrN = pontomedio(matriz_utilization_reasonable_N);
##    pmh = pontomedio(matriz_utilization_high);
##    pmhN = pontomedio(matriz_utilization_high_N);
    %fprintf('pmvl = %d, pmvlN = %d, pml = %d, pmlN = %d, pmbr = %d, pmbrN = %d, pmr = %d, pmrN = %d, pmh = %d, pmhN = %d, na linha %d \n', pmvl, pmvlN, pml, pmlN, pmbr, pmbrN, pmr, pmrN, pmh, pmhN, i); 
    
      
    # Diâmetro
    dvl = diametro(matriz_utilization_very_low);
    dvlN = diametro(matriz_utilization_very_low_N);
    dl = diametro(matriz_utilization_low);
    dlN = diametro(matriz_utilization_low_N);
    dbr = diametro(matriz_utilization_bellow_reasonable);
    dbrN = diametro(matriz_utilization_bellow_reasonable_N);
##    dr = diametro(matriz_utilization_reasonable);
##    drN = diametro(matriz_utilization_reasonable_N);
##    dh = diametro(matriz_utilization_high);
##    dhN = diametro(matriz_utilization_high_N);
    %fprintf('dvl %d, dvlN %d, dl %d, dlN %d, dbr %d, dbrN %d, dr %d, drN %d, dh %d, dhN %d, na linha %d \n', dvl, dvlN, dl, dlN, dbr, dbrN, dr, drN, dh, dhN, i);

    #Função S
    S_inf_very_Low = (1.0 - abs(pmvl - pmvlN)) - ((dvl + dvlN)/2.0);
    S_sup_very_Low = 1.0 - abs(pmvl - pmvlN);
    S_inf_Low = (1.0 - abs(pml - pmlN)) - ((dl + dlN)/2.0);
    S_sup_Low = 1.0 - abs(pml - pmlN);
    S_inf_bellow_Reasonable = (1.0 - abs(pmbr - pmbrN)) - ((dbr + dbrN)/2.0);
    S_sup_bellow_Reasonable = 1.0 - abs(pmbr - pmbrN);
##    S_inf_Reasonable = (1.0 - abs(pmr - pmrN)) - ((dr + drN)/2.0);
##    S_sup_Reasonable = 1.0 - abs(pmr - pmrN);
##    S_inf_High = (1.0 - abs(pmh - pmhN)) - ((dh + dhN)/2.0);
##    S_sup_High = 1.0 - abs(pmh - pmhN);
    
##    fprintf('S_inf_very_Low = %d, S_sup_Low = %d \n', S_inf_very_Low, S_sup_very_Low);
##    fprintf('S_inf_Low = %d, S_sup_Low = %d \n', S_inf_Low, S_sup_Low);
##    fprintf('S_inf_bellow_Reasonable = %d, S_sup_bellow_Reasonable = %d \n', S_inf_bellow_Reasonable, S_sup_bellow_Reasonable);
##    fprintf('S_inf_Reasonable = %d, S_sup_Reasonable = %d \n', S_inf_Reasonable, S_sup_Reasonable);
##    fprintf('S_inf_High = %d, S_sup_High = %d \n', S_inf_High, S_sup_High);
    
    
    Acum_S_inf_VERY_LOW = Acum_S_inf_VERY_LOW + S_inf_very_Low;
    Acum_S_sup_VERY_LOW = Acum_S_sup_VERY_LOW + S_sup_very_Low;
    Acum_S_inf_LOW = Acum_S_inf_LOW + S_inf_Low;
    Acum_S_sup_LOW = Acum_S_sup_LOW + S_sup_Low;
    Acum_S_inf_BELLOW_REASONABLE = Acum_S_inf_BELLOW_REASONABLE + S_inf_bellow_Reasonable;
    Acum_S_sup_BELLOW_REASONABLE = Acum_S_sup_BELLOW_REASONABLE + S_sup_bellow_Reasonable;
##    Acum_S_inf_REASONABLE = Acum_S_inf_REASONABLE + S_inf_Reasonable;
##    Acum_S_sup_REASONABLE = Acum_S_sup_REASONABLE + S_sup_Reasonable;
##    Acum_S_inf_HIGH = Acum_S_inf_HIGH + S_inf_High;
##    Acum_S_sup_HIGH = Acum_S_sup_HIGH + S_sup_High;

 
 endfor;


  Es_inf_very_low = Acum_S_inf_VERY_LOW/(ln - 1);
  Es_sup_very_low = Acum_S_sup_VERY_LOW/(ln - 1);
  Es_inf_low = Acum_S_inf_LOW/(ln - 1);
  Es_sup_low = Acum_S_sup_LOW/(ln - 1);
  Es_inf_bellow_reasonable = Acum_S_inf_BELLOW_REASONABLE/(ln - 1);
  Es_sup_bellow_reasonable = Acum_S_sup_BELLOW_REASONABLE/(ln - 1);
##  Es_inf_reasonable = Acum_S_inf_REASONABLE/(ln - 1);
##  Es_sup_reasonable = Acum_S_sup_REASONABLE/(ln - 1);
##  Es_inf_high = Acum_S_inf_HIGH/(ln - 1);
##  Es_sup_high = Acum_S_sup_HIGH/(ln - 1);

  fprintf('Entropia Intervalar VERY LOW = [%d, %d] \n', Es_inf_very_low, Es_sup_very_low);
  fprintf('Entropia Intervalar LOW = [%d, %d] \n', Es_inf_low, Es_sup_low);
  fprintf('Entropia Intervalar BELLOW REASONABLE = [%d, %d] \n', Es_inf_bellow_reasonable, Es_sup_bellow_reasonable);
  #fprintf('Entropia Intervalar REASONABLE = [%d, %d] \n', Es_inf_reasonable, Es_sup_reasonable);
  #fprintf('Entropia Intervalar HIGH = [%d, %d] \n', Es_inf_high, Es_sup_high);
    
 if(salveResult)
 fclose(arqId);
 endif;


 arqIdEntropia = fopen(outPutFileName, 'a');

  strLinhaEntropia = [entropyFunctionName, ',', fileName, ',', num2str(Es_inf_very_low), ',' , num2str(Es_sup_very_low), ',' , num2str(Es_inf_low), ',' , num2str(Es_sup_low), ',', num2str(Es_inf_bellow_reasonable), ',' ,num2str(Es_sup_bellow_reasonable)];

 
 #strLinhaEntropia = [entropyFunctionName, ',', fileName, ',', num2str(Es_inf_very_low), ',' , num2str(Es_sup_very_low), ',' , num2str(Es_inf_low), ',' , num2str(Es_sup_low), ',', num2str(Es_inf_bellow_reasonable), ',' ,num2str(Es_sup_bellow_reasonable), ',', num2str(Es_inf_reasonable), ',' ,num2str(Es_sup_reasonable), ',', num2str(Es_inf_high), ',' ,num2str(Es_sup_high) ];
 fputs(arqIdEntropia, [strLinhaEntropia, "\n"]);
 
 fclose(arqIdEntropia);


fprintf('Processamento realizado! \n');
