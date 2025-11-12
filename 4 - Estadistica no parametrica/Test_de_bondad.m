# Script
1;

# Para ejecutar las funciones de ejemplo, hay que ejecutar el comando:
# run nombre_archivo

#{
  Función de distribución empírica.

  Entrada: X -> Muestra - Vector fila de números.
  Salida: Gráfica.
#}
function FDE(X)
  n = length(X);

  # Como es una función con saltos. Cada punto lo necesitamos dos veces.
  # Entonces los duplicamos y los ordenamos.
  eje_x = sort([X X]);

  #{
    Calculamos las alturas con un espacio de 0.1.
    Como figuran dos veces, duplico las alturas y las ordeno.
    Me queda algo del estilo:
      x_1  x_1  x_2  x_2  x_3  x_3  x_4  x_4 ... x_n
      0  0.1 0.1 0.2 0.2 0.3 0.3 0.4 0.4 0.5 ...  1
    El salto se hace con el tamaño de 1 hasta (n-1), cada uno dividido n.
   #}
  eje_y = sort([0 (1:(n-1))/n (1:(n-1))/n 1]);

  # Grafico.
  plot(eje_x, eje_y);
endfunction;

#{
  Usa la convergencia de la función de distribución empírica a la función de
  distribución teórica y calcula el estadistico de Kolmogorov-Smirnov. Esto es
  el supremo de la diferencia. Para datos provenientes de una distribución
  normal.

  Entrada:  X-> Muestra - Vector fila de números.
            mu -> Media.
            sigma -> Desviación estandar.
  Salida:   estadistico -> Estadístico de Kolmogorov-Smirnov
#}
function estadistico = EstadisticoKSNormal(X, mu, sigma)
  n = length(X);

  eje_x = sort([X X]);
  Fn = sort([0 (1:(n-1))/n (1:(n-1))/n 1]);
  F = normcdf(eje_x, mu, sigma);

  # Calculo el máximo de la diferencia.
  estadistico = max(abs(Fn-F));
endfunction;

#{
  Usa la convergencia de la función de distribución empírica a la función de
  distribución teórica y calcula el estadistico de Kolmogorov-Smirnov. Esto es
  el supremo de la diferencia. Para datos provenientes de una distribución
  exponencial.

  Entrada:  X-> Muestra - Vector fila de números.
            lambda -> Parámetro de la distribución exponencial.
  Salida:   estadistico -> Estadístico de Kolmogorov-Smirnov
#}
function estadistico = EstadisticoKSExp(X, lambda)
  n = length(X);

  eje_x = sort([X X]);
  Fn = sort([0 (1:(n-1))/n (1:(n-1))/n 1]);
  F = expcdf(eje_x, 1/lambda); # F = 1 - exp(-lambda*eje_x);

  # Calculo el máximo de la diferencia.
  estadistico = max(abs(Fn-F));
endfunction;

#{
 Realiza la prueba de Kolmogorov-Smirnov para datos mayores a 35 de una
 distribución normal.

 Entrada:   X-> Muestra - Vector fila de números.
            mu -> Media.
            sigma -> Desviación estandar.
  Salida:   esNormal -> 1 si los datos provienen de
              una distribución normal, 0 en otro caso.
#}
function esNormal = PruebaKSNormal(X, mu, sigma)
  n = length(X);

  # Calculo el estadístico.
  estadistico = EstadisticoKSNormal(X, mu, sigma);

  # Comparo el estadístico con el caso de la tabla de Kolmogorov-Smirnov para
  # mayores de 35. Si el estadistico es mayor, se rechaza H0, o sea, no es
  # una distribución normal. Se lo contrario, se acepta.
  esNormal = ifelse((1.36/sqrt(n)) < estadistico, 0, 1);
 endfunction;

#{
 Realiza la prueba de Kolmogorov-Smirnov para datos mayores a 35 de una
 distribución exponencial.

 Entrada:   X-> Muestra - Vector fila de números.
            mu -> Media.
            sigma -> Desviación estandar.
  Salida:   esExp -> 1 si los datos provienen de
              una distribución exponencial, 0 en otro caso.
#}
function esExp = PruebaKSExp(X, lambda)
  n = length(X);

  # Calculo el estadístico.
  estadistico = EstadisticoKSExp(X, lambda);

  # Comparo el estadístico con el caso de la tabla de Kolmogorov-Smirnov para
  # mayores de 35. Si el estadistico es mayor, se rechaza H0, o sea, no es
  # una distribución exponencial. Se lo contrario, se acepta.
  esExp = ifelse((1.36/sqrt(n)) < estadistico, 0, 1);
 endfunction;

 #{
 Realiza la prueba de Lilliefors para datos mayores a 35 de una
 distribución exponencial.

 Entrada:   X-> Muestra - Vector fila de números.
  Salida:   esExp -> 1 si los datos provienen de
              una distribución exponencial, 0 en otro caso.
#}
function esExp = PruebaLillieforsExp(X)
  n = length(X);

  # Calculo el estadístico.
  estadistico = EstadisticoKSExp(X, 1/mean(X));

  # Comparo el estadístico con el caso de la tabla de Kolmogorov-Smirnov para
  # mayores de 35. Si el estadistico es mayor, se rechaza H0, o sea, no es
  # una distribución exponencial. Se lo contrario, se acepta.
  esExp = ifelse((1.06/sqrt(n)) < estadistico, 0, 1);
 endfunction;

# Realiza un ejemplo de la función de distribución empírica vs la teórica.
function ejemploFDE()
  # Crea una muestra normal de mu = 3 y sigma = 2 con 10 datos.
  X = 3+2*randn(1,100);

  # Graficamos FDE.
  FDE(X);

  # Graficamos la función teórica.
  # Creamos un vector desde -2 a 10.
  t = -2:.01:10;
  # Obtenemos la función de distribución estandarizada (restando a t la media
  # y dividiendo por la desviación estandar.
  F = normcdf((t-3)/2); # Igual a F = normcdf(t,3,2);
  # Graficamos en el mismo gráfico.
  hold;
  plot(t,F,'r');
endfunction;

# Realiza un ejemplo de la prueba de Kolmogorov-Smirnov para una normal.
function ejemploKSNormal()
  X = 3+2*randn(1,100000);

  esNormal = PruebaKSNormal(X, 3, 2);
  if (esNormal == 1)
    printf("Es normal\n");
  else
    print("No es normal\n");
  endif
 endfunction;

# Realiza un ejemplo de la prueba de Kolmogorov-Smirnov para una exponencial.
function ejemploKSExp()
  # Genera una exponencial de lambda = 5.
  X = exprnd(5, 1, 10);

  esExp = PruebaKSExp(X, 5);
  if (esExp == 1)
    printf("Es exponencial\n");
  else
    print("No es exponencial\n");
  endif
 endfunction;

# Realiza un ejemplo de la prueba de Lilliefors.
function ejemploLillieforsExp()
  # La realización de esta prueba es exactamente la misma que la de Kolmogorov-
  # Smirov solamente que se utiliza el estimador de lambda para el caso de las
  # exponenciales, esto es: 1/media(X). También hay que fijarse en otra tabla.
  # Genera una exponencial de lambda = 5.
  X = exprnd(5, 1, 10);

  esExp = PruebaLillieforsExp(X);
  if (esExp == 1)
    printf("Es exponencial\n");
  else
    print("No es exponencial\n");
  endif
endfunction;
