# Script
1;

# Para ejecutar las funciones de ejemplo, hay que ejecutar el comando:
# run nombre_archivo

#{
  Compara los índices con los rangos, donde el estadístico de Spearman es
  el coeficiente de correlación lineal entre el vector de rangos y el vector
  de índice.

  Para crear el vector de ragno, sea R = (r1, r2, ..., rn) de la muestra
  X = (x1, x2, ..., xn) el vector donde, una vez ordenada la muestra de menor
  a mayor, ri indica, la posición en la muestra ordenada para cada xi.

  Ejemplo:
    X = [5 1 4]
    X = [x1=5 x2=1 x3=4];
    Xord = [1 4 5];
    R = [x1=3 x2=1 x3= 2];
    R = [3 1 2]; -> O sea, indica que x1 está en la posición 3 de la muestra
                    ordenada.
#}

#{
  Obtiene los rangos de una muestra.

  Entrada -> Muestra en fila.
  Salida -> Vector de rangos.
#}
function rangos = ObtenerRangos(X)
  n = length(X);

  # Para obtener los rangos, haciendo la función sort, en el vector indicesOrd
  # se obtiene los índices de cada una de las observaciones.
  [a, indicesOrd] = sort(X);
  # Si aplicamos nuevamente obtenemos el vector rango.
  [a, rangos] = sort(indicesOrd);
endfunction;

#{
  Calcula el coeficiente de spearman para un vector de rangos e índices.


  Entrada ->  rangos: Vector fila de rangos.
  Salida -> coeficiente de spearman.
#}
function coeficiente = CalcularCoeficienteSpearman(rangos)
  n = length(rangos);

  coeficiente = 1-6*(sum((rangos-(1:n)).^2))/(n*(n^2-1));
endfunction;

#{
  Calcula el estimador de Spearman aproximando a la normal (para muestras con
  mas de 30 datos).

  Entrada ->  R: Coeficiente de Spearman.
              n: Tamaño del vector.
  Salida -> estimador de Spearman.
#}
function estimador = AproximacionSpearmanNormal(R, n)
  estimador = R*sqrt(n-1);
endfunction;

#{
  Realiza la prueba de Spearman para un conjunto de muestra.

  Entrada -> Muestra en fila.
  Salida -> sonDatosIid: Indica si los datos son iid.
            estimador: Coeficiente de Spearman.
#}
function [sonDatosIid, estimador] = PruebaSpearman(X)
  rangos = ObtenerRangos(X);
  coeficienteSpearman = CalcularCoeficienteSpearman(rangos);
  estimador = AproximacionSpearmanNormal(coeficienteSpearman, length(X));

  #{
    Para un alpha de 0.05, se tiene que alpha = 0.05 ==> Z_(1-alpha/2) = z ==>
    Z_(1-0.05/2) = z ==> Z_0.975 = z == buscando en la tabla ==> Z_0.975 = 1.96
  #}
  z = 1.96;
  if (coeficienteSpearman < 0)
    # alpha = P(Z<=z_L)
    sonDatosIid = ifelse((z <= estimador), 1, 0);
  else
    sonDatosIid = ifelse((z >= estimador), 1, 0);
  endif
endfunction;
