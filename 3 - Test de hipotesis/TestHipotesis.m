1;

# ------------------------- TEST DE HIPOTESIS -------------------------------- #
#{
  RAZONAMIENTO POR INPROBABLE: Suponer que una cierta hipótesis es verdadera,
  y a partir de esta suposición calcular la probabilidad de observar algo tanto
  o más extremo que lo observado.
  Si la probabilidad es muy baja, concluímos que la hipótesis es falsa, y al
  menos poco creible.

  Un principio general en ciencia es elegir siempre la hipótesis más simple
  capaz de explicar la realidad observada.
  Una hipótesis se contrasta comparando sus predicciones con la realidad: Si
  coinciden (dentro del margen de error adminsible), mantendremos la hipótesis,
  en caso contrario la rechazaremos y buscremos otra.

  Cuando las predicciones generadas por la hipótesis son en términos de
  probabilidad, la metodología empleada es la teorí de Test de Hipótesis o
  Contraste de Hipótesis.

  HIPÓTESIS NULA: Es la hipótesis a comprobar H0 y H1 es el complemento, o sea,
  la hipotesis es falta.

  HIPÓTESIS ESTADÍSTICA: Es una suposición que determina total o parcialmente
  la distribución de probabilidad de una o varias variables aleatorias.
  Pueden clasificarse en:
    - Paramétricas: La suposición se refiere al valor o valores de un parámetro
    o parámteros.
      - Bilateral: Desconocemos en que dirección puede ser falsa H0 y por lo
      tanto tendremos H1: theta != theta0.
      - Unilateral: Sabemos que si theta != theta0, forsosamente theta > theta0
      o bien theta < theta0)
    - No paramétricas: La suposición se refiere a la forma de la distribución
    de la variable aleatoria.

  RESUMEN:
    - En los test de hipótesis paramétricos, H0 suele ser que el parámetro es
    igual a un valor concreto que se toma como referencia.
    - Cuando comparamos poblaciones, H0 es que las poblaciones son iguales.
    - Cuando investigamos la forma de la distribución, H0 suele ser que los
    datos siguen una distribución conocida.

  METODOLOGÍA:
    1) Definir H0 y H1.
    2) Definir un estadístico para el test (función de los datos) cuyo valor
    servirá como media para evaluar si lo observado se comporta como debería
    si H0 fuese cierta.
    3) Decidir cuando una discrepancia se considera inadmisible, cuando es
    demasiado grande para ser creible como producto del azar.
    4) Tomar los datos, calcular el estadístico del test y ver si la
    discrepancia es aceptable o no. Si lo es, no rechazamos H0, caso contrario
    la rechazamos y aceptamos H1.

  estimador = abs((theta0 - theta_emv)/sigma_emv)

  En muestras grandes, el TCL (teorema central del límite) nos dice que la
  distribución de d es aproximadamente normal estandar, por lo que podemos
  usarla para calcular probabilidades.

  ERRORES TIPO I Y TIPO II:
  Si llamamos P(A|B) a la probabilidad de decidirnos por A cuando de hecho
  B es la opción correcta, tenemos que
    - ERROR TIPO I: Rechazar H0 cuando la misma es verdadera, o sea,
    alpha = P(H1|H0) - Condenar a alguien inocente.
    - ERROR TIPO II: No rechazar H0 cuando la misma es falsa, o sea,
    beta = P(H1|H0)
    - Potencia del test: Probabilidad de haber rechazado bien H0, o sea,
    1 - beta = P(H1|H1)

  P-VALOR:
  Nivel de credibilidad que tiene H0.
    - Es la probabilidad bajo H0 de obtener un valor mayor o igual al obtenido
    del estadístico.
    - Es la probabilidad de obtener una discrepancia mayor o igual que la
    obsevada en la muestra cuando H0 es cierta.
    - Es la probabilidad bajo H0 de observar algo tanto o más extremo que lo
    observado.
  Si estadisico_obs es el valor observado del estadistico, entonces:

  p = P(d >= estadisico_obs|H0)

  Cuanto menor sea p, menor es la probabilidad de aparición de una discrepancia
  como la observada, menor es la credibilidad de H0.
  Fijado un nivel de significación alpha, si el p-valor es inferior a alpha se
  rechaza H0.
#}

# DISTRIBUCIÓN BINOMIAL.
#{
  El objetivo es encontrar dos intervalos donde, una distribución Binomial,
  de parámetros (p, k), tiene la mayoría de sus datos (con un porcentaje de
  confianza). Para encontrar este intervalo, simplemente haciendo la inversa
  de dicha función para la confianza deseada obtenemos dichos intervalos.
  Una vez que obtuvimos estos intervalos, lo que hay que hacer es ver cuandos
  de los datos de la muestra están dentro de este intervalo. Si la cantidad
  es mayor a lo esperado, entonces se acepta la hiótesis nula.

  Fijando un alpha = 0.1, y un intervalo [a,b], implica que el 90 por ciento
  de los datos de la muestra debe caer dentro del intervalo para aceptar la
  hipotesis.

  Entrada:
    X -> Muestra en forma de fila.
    p -> Probabilidad del suceso.
    k -> Cantidad de intentos.
    aplha -> Error tipo 1.

  Salida:
    seAceptaHip -> Indica si se debe aceptar H0 o no (1|0 respectivamente)
    a -> Limite inferior del intervalo.
    b -> Limite superior del intervalo.
    test -> Cantidad de datos que pasaron el test.
#}
function [seAceptaHip, a, b, test] = TestHipotesisBinomial(X, p, k, alpha)
  n = length(X);

  # Primeramente buscamos los intervalos de la distribución Binomial.
  a = binoinv(alpha/2, k, p);
  b = binoinv(1-alpha/2, k, p);

  # Chequeamos la cantidad de datos de la muestra que está dentro del intervalo.
  test = nnz((a<X)&(b>X));

  # Si la cantidad es mayor a lo esperado, se acepta la hipótesis.
  seAceptaHip = ifelse((test/length(X))>(1-alpha), 1, 0);
endfunction;

#{
  Realiza un test de simulación para la distribución binomial. Esto es,
  genera datos con los parámetros en cuestión y grafica un histograma. Luego
  se grafica una linea. Viendo la gráfica podemos intuir si la media se mezcla
  con los datos o no. En caso positivo, podemos afirmar H0.

  Entrada:
    X -> Muestra en forma de fila.
    p -> Probabilidad del suceso.
    k -> Cantidad de intentos.
#}
function TestSimulacionBinomial(X, k, p)
  n = length(X);

  # Genero datos binomiales de parámetro k y p.
  muestras = binornd(k, p, 25, 10000);

  # Calculo el estimador de máxima verosimilitud para cada muestra.
  estimadores = mean(muestras)/k;

  # Grafico el histograma.
  hist(estimadores, sqrt(length(estimadores)));

  # Grafico una linea en donde se estima lambda
  hold;
  ylim = get(gca, 'YLim');
  line([mean(X)/k mean(X)/k], ylim, 'Color', 'red', 'LineWidth', 1);
  title(sprintf('Histograma EMV lambda con 25 muestras'));
  xlabel('Valor');
  ylabel('Frecuencia');
endfunction;

# DISTRIBUCIÓN NORMAL
#{
  Realiza el test de hipótesis para una distribución normal, donde H0 es los
  datos siguen una distribución normal de parámetro mu y sigma.

  Entrada:
    X -> Muestra en forma de fila.
    mu -> Media
    sigma -> Desviación estandar
    aplha -> Error tipo 1.

  Salida:
    seAceptaHip -> Indica si se debe aceptar H0 o no (1|0 respectivamente)
    a -> Limite inferior del intervalo.
    b -> Limite superior del intervalo.
    test -> Cantidad de datos que pasaron el test.
#}
function [seAceptaHip, a, b, test] = TestHipotesisNormal(X, mu, sigma, alpha)
  n = length(X);

  # Primeramente buscamos los intervalos de la distribución normal.
  a = norminv(alpha/2, mu, sigma);
  b = norminv(1-alpha/2, mu, sigma);

  # Chequeamos la cantidad de datos de la muestra que está dentro del intervalo.
  test = nnz((a<X)&(b>X));

  # Si la cantidad es mayor a lo esperado, se acepta la hipótesis.
  seAceptaHip = ifelse((test/length(X))>(1-alpha), 1, 0);
endfunction;

#{
  Realiza un test de simulación para la distribución binomial. Esto es,
  genera datos con los parámetros en cuestión y grafica un histograma. Luego
  se grafica una linea. Viendo la gráfica podemos intuir si la media se mezcla
  con los datos o no. En caso positivo, podemos afirmar H0.

  Entrada:
    X -> Muestra en forma de fila.
    mu -> Media
    sigma -> Desviación estandar
#}
function TestSimulacionNormal(X, mu, sigma)
  n = length(X);

  # Genero datos binomiales de parámetro k y p.
  muestras = normrnd(mu, sigma, 25, 10000);

  # Calculo el estimador de máxima verosimilitud para cada muestra.
  estimadores = mean(muestras);

  # Grafico el histograma.
  hist(estimadores, sqrt(length(estimadores)));

  # Grafico una linea en donde se estima lambda
  hold;
  ylim = get(gca, 'YLim');
  line([mean(X) mean(X)], ylim, 'Color', 'red', 'LineWidth', 1);
  title(sprintf('Histograma EMV lambda con 25 muestras'));
  xlabel('Valor');
  ylabel('Frecuencia');
endfunction;

# DISTRIBUCION EXPONENCIAL
#{
  Realiza el test de hipótesis para una distribución exponencial, donde
  H0 es los datos siguen una distribución exponencial con parámetro lambda.

  Entrada:
    X -> Muestra en forma de fila.
    lambda -> Parámetro de la distribución exponencial.
    aplha -> Error tipo 1.

  Salida:
    seAceptaHip -> Indica si se debe aceptar H0 o no (1|0 respectivamente)
    a -> Limite inferior del intervalo.
    b -> Limite superior del intervalo.
    test -> Cantidad de datos que pasaron el test.
#}
function [seAceptaHip, a, b, test] = TestHipotesisExponencial(X, lambda, alpha)
  n = length(X);

  # Primeramente buscamos los intervalos de la distribución exponencial.
  a = expinv(alpha/2, 1/lambda);
  b = expinv(1-alpha/2, 1/lambda);

  # Chequeamos la cantidad de datos de la muestra que está dentro del intervalo.
  test = nnz((a<X)&(b>X));

  # Si la cantidad es mayor a lo esperado, se acepta la hipótesis.
  seAceptaHip = ifelse((test/length(X))>(1-alpha), 1, 0);
endfunction;

#{
  Realiza un test de simulación para la distribución binomial. Esto es,
  genera datos con los parámetros en cuestión y grafica un histograma. Luego
  se grafica una linea. Viendo la gráfica podemos intuir si la media se mezcla
  con los datos o no. En caso positivo, podemos afirmar H0.

  Entrada:
    X -> Muestra en forma de fila.
    lambda -> Parámetro de la distribución exponencial.
#}
function TestSimulacionExponencial(X, lambda)
  n = length(X);

  # Genero datos binomiales de parámetro k y p.
  muestras = exprnd(1/lambda, 25, 10000);

  # Calculo el estimador de máxima verosimilitud para cada muestra.
  estimadores = 1./mean(muestras);

  # Grafico el histograma.
  hist(estimadores, sqrt(length(estimadores)));

  # Grafico una linea en donde se estima lambda
  hold;
  ylim = get(gca, 'YLim');
  line([1/mean(X) 1/mean(X)], ylim, 'Color', 'red', 'LineWidth', 1);
  title(sprintf('Histograma EMV lambda con 25 muestras'));
  xlabel('Valor');
  ylabel('Frecuencia');
endfunction;

# TEST DE HIPOTESIS SOBRE LA MEDIA
#{
  Se supone una muestra i.id M={x_1, ..., x_n} con distribución normal de
  parámetros desconocidos.

  Se dese acontrastar:  { H0: mu = mu_0
                        { H1: mu <> mu_0

  Hay dos casos, con varianza conocida o varianza desconocida.

  Varianza conocida (sigma):

    d = sqrt(n)*(mean(X)-mu_0)/sigma, con distribución estandar.


    Por lo tanto, fijando alhpa perteneciente al intervalo [0,1], la región
    crítica (o de rechazo) al nivel de alpha será el intervalo:

    R_alpha = (-Z_(alpha/2), Z_(alpha/2)), tal que:

    P(d pertenezca a R_alpha = 1 - alpha), o sea,
    P(d no pertenece R_alpha = alpha)

    Esto es, no rechazamos H0 si |mu-mu_0 <= Z_(alpha/2)*(sigma/sqrt(n))|

  Varianza desconocida (sigma):
    d = sqrt(n)*(mean(X)-mu_0)/S_n, con distribución t-student con n-1
    grados de libertad.

    Donde S_n es la desviación muestral y se calcula (std(X)):

      S_n = sqrt(sum(i=1, i=n, (X_i-mean(X))^2)/n-1)

    La región de aceptación será |mu-mu_0 <= T_(alhpa/2)*(S_n/sqrt(n))|

    Donde T_(alpha/2) tal que P(d pertenece a
      (-T_(alpha/2), T_(alpha/2)-1-alpha)

  Entrada:
    X -> Muestra en forma de fila.
    mu_0 -> Media a testear.
    sigma_0 ->  Varianza conocida o desconocida. Si es desconocida llamar con el
                valor ~.
    alpha -> Puede ser 0.05 o 0.1

  Salida:
    h -> Indica si se debe aceptar H0 o no (0|1 respectivamente)
    pval -> P-value
    d -> Estadistico (Z)

#}
function [h, pval, d] = TestSobreMedia(X, mu_0, sigma_0, alpha, sigmaConocido)
  n = length(X);
  Z_alphaMedios = ifelse(alpha = 0.05, 1.96, 1.64);

  # Consulto si sigma es conocida o desconocida.
  if sigmaConocido
    # Varianza conocida.
    # d = sqrt(n)*(mean(X)-mu_0)/sigma_0;
    # pval = 1-(max(normcdf(d),normcdf(-d))-min(normcdf(d),normcdf(-d)))
    # h = ifelse((pval < alpha), 1, 0);
    [h, pval, ~, d] = ztest(X, mu_0, sigma_0, "alpha", 0.1);
  else
    # Varianza desconocida.
    d = sqrt(n)*((mean(X)-mu_0)/std(X));
    pval = 1-(max(tcdf(d,n-1),tcdf(-d,n-1))-min(tcdf(d,n-1),tcdf(-d,n-1)));
    [h, pval] = ttest(X, mu_0);
  endif
endfunction;

# TEST DE HIPOTESIS SOBRE LA VARIANZA
#{
  En este caso se tiene que:  { H0: sigma^2 = sigma_0^2
                              { H1: sigma^2 <> sigma_0^2

  Bajo H0, el estadístico d = ((n-1)*varianzaMuestral^2)/sigma_0^2 tiene
  distribución Ji-Cuadrado con n-1 grados de libertad).

  Como esta distribucion no es simétrica, dado que alpha pertenece al intervalo
  [0,1] hallamos los valores X^2_(1-alpha/2) y X^2_(alpha/2) tal que
  P(d pertence a dicho intervalo) = 1 - alpha.

  Para H1: sigma^2 > sigma_0^2 la región de rechazo es d >= X^2_(alpha/2),
  mientras que para H1: sigma^2 < sigma_0^2 es d <= X^2_(1-alpha/2).

  Entrada:
    X -> Muestra en forma de fila.
    mu_0 -> Media a testear.
    sigma_0 ->  Varianza conocida o desconocida. Si es desconocida llamar con el
                valor ~.
    alpha -> Puede ser 0.05 o 0.1

  Salida:
    h -> Indica si se debe aceptar H0 o no (0|1 respectivamente)
    pval -> P-value
    d -> Estadistico (Z)
#}
function [h, pval, d] = TestSobreVarianza(X, sigma_0, alpha)
  n = length(X);

  # Calculo el estadistico.
  d = ((n-1)*std(X)^2)/sigma_0^2;
  pval = 1-(max(chi2cdf(d,n-1),chi2cdf(-d,n-1))-min(chi2cdf(d,n-1),chi2cdf(-d,n-1)));
  h = ifelse((pval < alpha), 1, 0);
endfunction;


