1;

# DISTRIBUCIONES EN OCTAVE:
#{
  Beta Distribution	                    betarnd
  Binomial Distribution	                binornd
  Cauchy Distribution	                  cauchy_rnd
  Chi-Square Distribution	              chi2rnd
  Univariate Discrete Distribution	    discrete_rnd
  Empirical Distribution	              empirical_rnd
  Exponential Distribution	            exprnd
  F Distribution	                      frnd
  Gamma Distribution	                  gamrnd
  Geometric Distribution	              geornd
  Hypergeometric Distribution	          hygernd
  Laplace Distribution	                laplace_rnd
  Logistic Distribution	                logistic_rnd
  Log-Normal Distribution	              lognrnd
  Pascal Distribution	                  nbinrnd
  Univariate Normal Distribution	      normrnd
  Poisson Distribution	                poissrnd
  Standard Normal Distribution	        stdnormal_rnd
  t (Student) Distribution	            trnd
  Univariate Discrete Distribution	    unidrnd
  Uniform Distribution	                unifrnd
  Weibull Distribution	                wblrnd
  Wiener Process	                      wienrnd
#}

# VARIABLE UNIFORME:
#{
  Intervalo [a, b]
    -> Notación: U ~ U[a,b];  una variable se distribuye uniforme dentro del
                                intervalo a, b.

    -> Función de densidad: f(x) =  1/b-a si x pertenece al intervalo [a,b]
                                    0 en caso contrario.

    -> Función de distribucion: Fu(x) = P{U<=x} = { 0 si x < a
                                                  { (x-a)/(b-a) si  x pertenece
                                                                    a [a,b]
                                                  { 1 si x >= b

    -> Media: (a+b)/2

    -> Mediana: (a+b)/2

    -> Varianza: ((b-a)^2)/12

  Intervalo [0,1]
    -> Notación: U ~ U[0,1];  una variable se distribuye uniforme dentro del
                              intervalo 0, 1.

    -> Función de densidad: f(x) =  1 si x pertenece al intervalo [0,1]
                                    0 en caso contrario.

    -> Función de distribucion: Fu(x) = P{U<=x} = { 0 si x < 0
                                                  { x si x pertenece a [0,1]
                                                  { 1 si x > 1

  Valor esperado = 1/2
#}
# Generar datos uniformes:
a = 0;
b = 1;
n = 10;
m = 1;
U = unifrnd(a, b, n ,m) # Crea un vector de datos uniformes en [0,1].

# VARIABLE BERNOULI:
#{
  Indica que el valor de éxito 1 ocurre con probabilidad p y el valor de fracaso
  0 ocurre con probabilidad q = 1-p

    -> Notación B ~ B(p); una variable se distribuye Bernoulli con parámetro p.

    -> Función de probabilidad: P[X=x] = (p^x)(1-p)^(1-x) o sea

                                P[X=x] =  { 1-p si x = 0
                                          { p si x = 1

    -> Función de distribucion: F(x) =  {0 si x < 0
                                        { 1-p si 0 < 0 < 1
                                        { 1 si x >= 1

    -> Media: p

    -> Mediana: No aplica

    -> Varianza: p(1-p)

  Generación de distribución:
    Si el punto p pertenece al intervalo [0,1] se tiene que:

      Fu(p) = P{U<=p} = p

    De modo que la variable aleatoria indique si U es menor o igual que p es:

      X = 1[0,p](U) = { 1 si U <= p
                      { 0 si U > p

    Para generar una variable aleatoria con distribución Bernoulli, lo que hay que
    hacer es generar una variable uniforme en el intervalo [0,1] y pasarla por
    el filtro anterior (de p).

    Valor esperado = p
#}
# Generar datos bernouli.
p = 0.3;
Ber = U < p


# VARIABLES BINOMIALES:
#{
  Cuenta el número de éxitos en una secuencia de n ensayos de Bernoulli
  independientes entre sí con una probabilidad fija p de ocurrencia de éxito
  entre los ensayos.

    -> Notación: X ~ Bin(n, p)

    -> Función de probabilidad: P[X=x] = C(n,x)*p^x*(1-p)^(n-x), donde C(n,x)
       son las combinaciones de n en x (x!/x!(n-x)!)

    -> Función de distribucion: Fx(x) = P[X<=x]
                                      = sum(k=0, k=x, C(n,k)*p^k*(1-p)^(n-k)

    -> Media: n*p

    -> Mediana: Uno de {techo(n*p), piso(n*p)}

    -> Varianza: n*p*(1-p)

  Generación de distribución:
    Si sumamos las variables independientes de Bernoulli tenemos una variable
    Binomial de parámetros n y p.

      Y = X1 + X2 + ... + Xn donde Y ~ Bin(n, p)

    Valor esperado = n*p
#}
# Generar datos binomiales.
Bin = sum(Ber)
m = 10;
BinVector = sum(unifrnd(a, b, n ,m) < p)

# En octave se puede generar como:
# BinVector = binornd(n, p);

# VARIABLES EXPONENCIALES:
#{
  Modela tiempos de espera para la ocurrencia de un cierto evento.

  -> Notación: X ~ Exp(lambda)

  -> Función de densidad: fx(x) = lambda*e^(-lambda*x), para x >= 0

  -> Función de distribución: Fx(x) = 1-e^(-lambda*x)

  -> Media: 1/lambda

  -> Mediana: In(2)/lambda

  -> Varianza: 1/lambda^2

  Generación de distribución:

    Sea Lv = P{V<=x} = integral(-infinito, x, fv(t)dt) = 1-e^(-lambda*x)

    Como 1-e^(-lambda*x) es 0 cuando x<0, entonces consideramos únicamente la
    siguiente transformación Fv: [0,+infinito] -> [0,1]. O sea, restringida
    a la zona no trivial. Esta función tiene una inversa creciente definida.

    u = Fv(x) = 1-e^(-lambda*x), despejando tenemos:

    x = (log(1-u))/(-lambda)

    Entoncs la fórmula de la inversa de la exponencial es:

      F(^-1)v(u) = (log(1-u))/(-lambda)

    Valor esperado = 1/lambda
#}
# Generar datos exponenciales.
lambda = 2
Exp = log(1-U)/-lambda

# En octave se puede generar como:
#   Se utiliza la media de lambda como parámetro, o sea, 1/lambda.
#   O sea, si lambda es 2, se utiliza 0.5 como parámetro.
# Exp = exprnd(1/lambda, r)

# VARIABLES GEOMÉTRICAS:
#{
  La distribución geométrica es cualquiera de las dos distribuciones de
  probabilidad discretas donde:
    - Si X = {1, 2, ...} es el número necesraio para obtener un éxito.
    - Si X = {0, 1, 2, ...} es el número de fracasos antes del primer éxito.

  -> Notación: X ~ Geo(p)

  -> Función de probabilidad: P{X=x} = p(p-1)^(x-1) para X = 1, 2, 3,...

  -> Función de distribución: P{X<=x} = sum(k=1, k=x, p(1-p)^(k-1))
                                      = 1-(1-p)^x

  -> Media: 1/p

  -> Varianza = 1-p/p^2

  Generación de distribución:

    Consideramos la variable "parte entera" de X, donde:

    Y =[X], Y = k, si X pertenece [k, k+1], operando sobre la función
    exponencial en el intervalo [k, k+1] tenemos que:

    P{Y=k} = e^(-lambda*k)*1-e^-lambda

    Si llamamos q = e^-lambda y p = 1-q = 1-e^-lambda.

    Entonces P{Y=k} = q^(k)-p, o sea, k fracasos hasta un éxito.

    Pero como definimos como el número de intentos hasta el primer éxito,
    haciendo Z = [X] + 1, o sea, la parte entera más 1, si tenemos:

    P{Z=k} = P{Y=k-1} = q^(k-1)*p
#}
# Generar datos geométricos.
p = 1-exp(-lambda)
q = 1-p
Geo = ceil(Exp) # Ceil es la función techo, o sea, la parte entera + 1
                # lo mismo que floor(Exp)+1






