1;

# ---------------- ESTIMACIÓN PUNTUAL ----------------

# /*************** ESTIMACION DATOS < 30. ***************/
# Se conoce la distribución pero no se conoce los parámetros.

# DATOS POISSION:
#{
  -> Esperanza de la frecuencia observada (E_f_obs):

      E_f_obs = nP(X=x) = (n*lambda^x*e^-lambda)/(x!)
      Haciendo logaritmo de ambos lados obtenemos que:

        log(E_f_obs) + log(x!) ~~ a + bx

      Donde:
        a = log(n)-lambda
        b = log(lambda)

      Por tanto si graficamos log(f_obs)+log(x!) respecto a x y los datos son
      Poisson, entonces el gráfico debería ser aproximadamente una recta con
      pendiente log(lambda) e intersecto log(n)-lambda.

      Al tener una sola muestra tenemos que E_f_obs = f_obs.
#}
# Generamos datos Possion.
lambda = 2;
X = poissrnd(lambda, 1, 25)
# Grafico la frecuencia observada vs x.
[y, x] = hist(X, unique(X));
scatter(x, y, 'r', 'filled');
# Grafico log(f_obs)+log(x!)
plot(log(y)+log(factorial(x))); # Podemos ver que se aproxima bastante a una
                                # recta.

# DATOS EXPONENCIALES
#{
  -> Esperanza de la frecuencia observada (E_f_obs):

    E_f_obs = n*lambda*e^(-lambda*x)
    Haciendo logaritmo de ambos lados obtenemos que:

      log(f_obs) - log(n) ~~ log(lambda) - lambda*x = a + bx

    Donde:
      a = log(lambda)
      b = -lambda

    Por lo tanto el gráfico de log(f_obs) - log(n) deberá ser aproximadamente
    una recta de pendiente b = -lambda e intersecto a = log(lambda).
#}
lambda = 1.3;
X = exprnd(lambda, 1, 25)
# Grafico la frecuencia observada vs x.
[y, x] = hist(X, sqrt(length(X)));
scatter(x, y, 'r', 'filled');
# Grafico log(f_obs)+log(x!)
plot(log(lambda) - lambda*x); # Podemos ver que se aproxima bastante a una
                                # recta.

# DATOS NORMALES
#{
  -> Esperanza de la frecuencia observada (E_f_obs):

    E_f_obs = n*fx(x)
    Haciendo logaritmo de ambos lados obtenemos que:

      log(f_obs)-log(n)+log(sqrt(2*pi)) ~~ -log(sigma)-((x-mu)^2/(2*sigma^2))

    Por lo tanto si los datos provienen de una función normal, al graficar
    log(f_obs) - log(n) + log(sqrt(2*pi)) se debería parecer a una parábola.
#}
mu = 0;
sigma = 1.4;
X = normrnd(mu, sigma, 1, 25)
# Grafico la frecuencia observada vs x.
[y, x] = hist(X, sqrt(length(X)));
scatter(x, y, 'r', 'filled');
# Grafico la paráboloa.
plot(log(y)-log(length(X))+log(sqrt(2*pi)));

# /*************** MÉTODO DE LOS MOMENTOS ***************/
# DISTRIBUCIÓN NORMAL
#{
  Supongamos que se tiene una muestra i.id {X_1, X_2, ..., X_n} donde
  X_i ~ N(mu,sigma).

  Llamamos momento de primer orden a E(X), momento de segundo orden a E(X^2),
  momento de tercer orden a E(X^3)...

  Sabemos que E(X)=mu y E(X^2)=sigma^2+mu^2.

  Por otra parte: E(X)~~(1/n)*(sum(i=1, i=n, Xi)) y
                  E(X^2)~~(1/n)*(sum(i=1, i=n, Xi^2))

  Entonces tenemos el sistema:

    mu=(1/n)*(sum(i=1, i=n, Xi))=mean(X)
    mu^2+sigma^2=(1/n)*(sum(i=1, i=n, Xi^2))

   Por lo tanto, estimamos mu mediante el promedio mean(X) y luego sustituimos
   en la segunda ecuación y estimamos sigma^2 mediante
   (1/n)*(sum(i=1, i=n, Xi^2)-mean(x)^2)
#}
mu = 1;
sigma = 2;
datos = normrnd(mu, sigma, 1, 10000);

estimador_mu = mean(datos)
estimador_sigma = sqrt(mean(datos.^2)-estimador_mu^2)

# DISTRIBUCION POISSON
#{
  E(X) = lambda y E(X) ~~ mean(X), estimaremos lambda mediante el promedio de los datos.
#}
lambda = 2;
datos = poissrnd(lambda, 1, 10000);

estimador_lambda = mean(datos)

# DISTRIBUCION UNIFORME
#{
  No funciona correctamente, ya que el parámetro b se estima como 2*mean(X).
  Si se hacen algunos ejemplos, caen datos que no están entre a y b.
#}

# Notas metodo de los momentos: Son estimadores sesgados pero consistentes. Son
# simples.

# /*************** MÉTODO DE MÁXIMA VEROSIMILITUD ***************/
#{
  Partiendo de la probabilidad conjunta de los datos se llega a que:

    fx(x_1, theta)*...*fx(x_n, theta)

  Como esta probabilidad depende de theta, la idea es ejegir aquel valor de
  theta que hace máxima la probabilidad de observar la muestra que tenemos.
  La función I(theta) = productoria(i=1, i=n, fx(x_i, theta) se denomina
  Función de verosimilitud (likelihood) de la muestra.

  O sea, se elije como theta al que haga máxima a la función anterior.
  Principio de máxima verosimilitud: La naturaleza prefiere los eventos de
  mayor probabilidad.
#}

# DATOS EXPONENCIALES
#{
  Supongamos una muestra M={X_1, ..., X_n} de datos exponenciales de parámetro
  lambda.

  Tenemos entonces que:
    I(lambda) = productoria(i=1, i=n, fx(X_i, lambda)
              = productoria(i=1, i=n, lambda^n*e^(-lambda*mean(X)))
              = lambda^n*e^(-n*lambda*mean(X))

  Buscamos maximizar dicha función, entonces I'(lambda)=0, utilizando logarimos
  para facilitar las cuentas (es más facil derivar una suma y el logaritmo de
  una función creciente tiene la misma preimagen) y tenemos que:

  EMV para lambda es 1/mean(M)
#}
lambda = 2;
datos = exprnd(1/lambda, 1, 10000);

emv_lambda = 1/mean(datos)

# DATOS UNIFORMES
#{
  EMV uniformes de a es el min(datos) y b es el máximo(datos).
#}
a = 1;
b = 100;
datos = unifrnd(a, b, 1, 10000);

emv_a = min(datos)
emv_b = max(datos)

# DATOS POISSON
#{
  EMV para lambda es mean(datos).
#}
lambda = 2;
datos = poissrnd(lambda, 1, 10000);

emv_lambda = mean(datos)

# DATOS BINOMIALES
#{
  EMV de p es p = mean(datos)/k
#}
k = 100;
p = 0.3;
datos = binornd(k, p, 1, 10000);

emv_p = mean(datos)/k

# DATOS NORMALES
#{
  Como son dos las variables, se hace lo mismo pero con derivadas parciales.

  EMV de mu es mean(datos)
  EMV de sigma^2 es la variana muestral, o sea sum(i=1, n, ((X_i-mu)^2)/n)
#}
mu = 1;
sigma = 2;
datos = normrnd(1, 2, 1, 10000);

emv_mu = mean(datos)
emv_sigma = sqrt(sum(((datos-emv_mu).^2)/length(datos)))


