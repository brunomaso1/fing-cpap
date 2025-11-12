# Script
1;

# Para ejecutar las funciones de ejemplo, hay que ejecutar el comando:
# run nombre_archivo

#{
  Muestra aleatorea simple: datos iid -> independientes y con la misma
  distribución.

  Hay dos tipos de pruebas:
    1 - Rachas up-down.
    2 - Coeficiente de corelación de spearman.

  Supongamos que se tiene una muestra X_1, X_2, ..., X_n. Definimos las
  variables Y_1, Y_2, ..., Y_(n-1 ) de la siguiente forma:
    Y_i = 1_{X_i<X_(i+1)}

   Y es una muestra de 0s y 1s, donde es 1s cuando el X actual es menor al X
   siguiente. En otro caso, es 0.

   Si las rachas son muy pocas o muchas, se toma como evidencia en contra de la hipótesis
   de aleatoriedad (se rechaza la hipótesis de que los datos son iid).

   Estadístico: Número total de rachas:

      R = 1 + sum(n-2, i=1, 1_{Y_i!=Y_(i+1)}) # La suma desde i = 1 hasta n-2
                                                de los cambios de valores.
#}

#{
  Calcula el número de rachas de una muestra.

  Entrada -> Muestra en forma de fila.
  Salida -> Número de rachas.
#}
function nroRachas = CalcularRachas(X)
  n = length(X);

  #{
  # Otra forma de hacer...
  for i = 1:length(X)-1
    Y(i) = ifelse(X(i)<X(i+1), 1, 0);
  endfor

  sum = 1;
  for i = 1:length(Y)-1
    sum += ifelse(Y(i)==Y(i+1), 0, 1);
  endfor
  #}

  # Comparo con el mismo vector pero corrido un lugar.
  R = X(1:n-1) < X(2:n);

  nr = length(R);
  # Comparo con el mismo vector pero corrido un lugar para comparar si
  # x_i = x_(i+1). Si son distintos, pongo un uno, significa que cambió la racha
  # racha.
  Y = R(2:nr) != R(1:nr-1);

  sum = 1 + sum(Y);

  nroRachas = sum;
endfunction;

#{
  Realiza la aproximación normal del número de rachas para el caso de que una
  muestra tenga más de 25 datos.

  Entrada -> Número de rachas.
  Salida -> z_L, donde aplha = P(Z<=z_L).
            z_R, donde alpha = P(Z>= z_R)
#}
function [z_L, z_R] = AproximacionRachasNormal(R, n)
  z_L = (R+0.5-((2*n-1)/3))/(sqrt((16*n-29)/90));
  z_R = (R-0.5-((2*n-1)/3))/(sqrt((16*n-29)/90));
endfunction;

#{
  Realiza la prueba de reachas para una muestra con más de 25 datos con un 95%
  de confianza.

  Entrada -> Muestra en forma de fila.
  Salida -> Indica si los datos son iid o no.
#}
function [sonDatosIid, z_L, z_R] = PruebaRachas(X)
  n = length(X);
  nroRachas = CalcularRachas(X);
  [z_L, z_R] = AproximacionRachasNormal(nroRachas, length(X));

  #{
    Para un alpha de 0.05, se tiene que alpha = 0.05 ==> Z_(1-alpha/2) = z ==>
    Z_(1-0.05/2) = z ==> Z_0.975 = z == buscando en la tabla ==> Z_0.975 = 1.96
  #}
  z = 1.96;
  if (nroRachas < (2*n-1)/3)
    # alpha = P(Z<=z_L)
    sonDatosIid = ifelse((z <= z_L), 1, 0);
  else
    sonDatosIid = ifelse((z >= z_R), 1, 0);
  endif
endfunction;
