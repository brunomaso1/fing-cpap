1;

printf("Se ha llevado a cabo un experimento para determinar la vida  ́util de un cierto tipo de mecha (en condiciones extremas). Para esto se tomaron 50 mechas al azar de un stock mayor de mechas, y se les midi ́o el tiempo de vida (en cientos de horas) obteni ́endose un promedio muestral Xn = 2,266. Por estudios previos se sabe que el tiempo de vida de las mechas de ese tipo tiene una distribuci ́on N (μ, σ2) con σ = 1,935. Determinar un intervalo de confianza para la vida  ́util promedio μ de las mechas de ese tipo, con una confianza igual a 0,95.");
printf("\n\n");

printf("Intervalo de confianza: [(mean(X)-mu_0)-Z_(alpha/2)*sigma/sqrt(n), (mean(X)-mu_0)+Z_(alpha/2)*sigma/sqrt(n) ==> \n");

meanX = 2.266;
mu_0 = 0;
sigma = 1.935;
alpha = 0.05;
n = 50;
printf("(%d-%d[+-]%d*%d/%d) \n", meanX, mu_0, stdnormal_inv(alpha/2), sigma, sqrt(n));
printf("Ic = [%d, %d] \n", meanX-mu_0-abs(stdnormal_inv(alpha/2))*sigma/sqrt(n), meanX-mu_0+abs(stdnormal_inv(alpha/2))*sigma/sqrt(n));
printf("\n\n");

printf("---------------------------------------------------------------");

printf("Se dispone de la siguiente muestra 7.24 1.91 1.58 3.81 5.36 2.37 1.86 1.63 3.26 1.91 3.96 1.54 \n");
printf("Asumiendo que los datos tienen distribuci ́on normal con media μ y desv ́ıo σ = 2, implemente la siguiente prueba de hip ́otesis: { H0 : μ = 4 {H1 : μ < 4 \n");
printf("\n\n");
X = [101.99, 106.64, 103.36, 109.54, 103.99, 107.32, 106.55, 103.7, 100.57, 105.85];

mu_0 = 104;
sigma_0 = 2.5;
alpha = 0.05;
n = length(X);

# Region de aceptacion.
printf("TEST MANUAL\n")
printf("Región de aceptación: |mean(X)-mu_0|<= Z_(alpha/2)*sigma_0/srqt(n), donde Z_(alpha/2) tal que P(d pertenece a [-Z_(alpha/2, Z_(alpha/2)] = 1 - alpha. \n");
printf("Donde:\n")
printf("|mean(X)-mu_0| = %d\n", abs(mean(X)-mu_0));
printf("Z_(alpha/2) = %d\n", stdnormal_inv(alpha/2));
printf("sigma_0/sqrt(n) = %d\n", sigma_0/sqrt(n));
printf("Por lo tanto: |mean(X)-mu_0|<= Z_(alpha/2)*sigma_0/srqt(n) es \n");
if (abs(mean(X)-mu_0) <= stdnormal_inv(alpha/2)*sigma_0/sqrt(n))
  printf("%d <= %d y no se rechaza H0. \n", abs(mean(X)-mu_0), stdnormal_inv(alpha/2)*sigma_0/sqrt(n));
else
  printf("%d > %d y se rechaza H0. \n", abs(mean(X)-mu_0), stdnormal_inv(alpha/2)*sigma_0/sqrt(n));
endif;
printf("\n");

printf("Estadistico (varianza desconocida): d = sqrt(n)*(mean(X)-mu_0)/S_n,  con distribucion normal estandar. \n");
d = sqrt(n)*(mean(X)-mu_0)/sigma_0;
printf("d = %d\n", d);
printf("\n");

printf("P-Value\n")
printf("pval = P(d ≥ ˆd|H0), para el caso de test lateral, es pval = cdf(d).\n ");
printf("pval = %d \n\n", 1-stdnormal_cdf(abs(d)));

printf("Intervalo de confianza")
printf("(%d-%d[+-]%d*%d/%d) \n", mean(X), mu_0, stdnormal_inv(alpha/2), sigma, sqrt(n));
printf("Ic = [%d, %d] \n", mean(X)-mu_0-abs(stdnormal_inv(alpha/2))*sigma/sqrt(n), mean(X)-mu_0+abs(stdnormal_inv(alpha/2))*sigma/sqrt(n));




