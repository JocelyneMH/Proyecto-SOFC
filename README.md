## Contexto de la Tecnología

Las celdas de combustible de óxido sólido (SOFC), por sus siglas en inglés, representan una tecnología avanzada para la generación de electricidad mediante la reacción electroquímica del hidrógeno con el oxígeno. Destacan por su alta eficiencia energética, especialmente en sistemas de cogeneración o ciclos combinados, donde pueden alcanzar valores de hasta el 85%. Esta elevada eficiencia se atribuye en parte a su operación a altas temperaturas (generalmente entre $800 \text{ °C}$ y $1000 \text{ °C}$), que favorecen la cinética electroquímica y permiten el aprovechamiento del calor residual. Además, al utilizar hidrógeno como combustible, las SOFC son consideradas una tecnología limpia, con un impacto ambiental mínimo [1].

El principio de operación se basa en aplicar una densidad de corriente sobre la celda, que en este caso es de diseño tubular (Figura 1 [2]) , lo que desencadena las siguientes reacciones electroquímicas:

* Cátodo: El oxígeno del aire se reduce, incorporando electrones para formar iones óxido ($O^{2-}$):
  
    $$\frac{1}{2} O_2 + 2e^- \rightarrow O^{2-} \quad \text{(en el cátodo)}$$
  
* Ánodo: Estos iones $O^{2-}$ migran a través del electrolito sólido hasta el ánodo, donde reaccionan con el hidrógeno del combustible, liberando electrones y produciendo vapor de agua:
  
    $$H_2 + O^{2-} \rightarrow H_2O + 2e^- \quad \text{(en el ánodo)}$$

El flujo neto de electrones a través de un circuito externo genera una diferencia de potencial (voltaje) utilizable (proceso en figura 2 [3]). Sin embargo, este voltaje operativo es inferior al potencial ideal de la reacción ($1.229 \text{ V}$ en condiciones estándar) debido a diversas pérdidas irreversibles, conocidas como sobrepotenciales o polarizaciones.

El objetivo de este proyecto es desarrollar y validar un modelo matemático que permita predecir el voltaje real de operación de una SOFC tubular en función de variables operativas como la temperatura, la concentración de reactivos, la presión y las dimensiones geométricas. Este modelo busca ser una herramienta útil para investigadores, permitiendo explorar el desempeño de la celda bajo distintas condiciones sin recurrir a costosos y extensos ensayos experimentales para cada escenario.

---

## Datos

El modelo desarrollado se basa y valida con datos experimentales y parámetros reportados en la literatura científica para celdas SOFC tubulares con configuraciones Siemens-Westinghouse.

* **Dimensiones Características [4]:**
    * Ánodo: $\delta_{a} = 125 \text{ µm}$
    * Cátodo: $\delta_{c} = 2 \text{ mm}$
    * Electrolito: $\delta_{e} = 40 \text{ µm}$
    * Diámetro externo del tubo: $2.2 \text{ mm}$
* **Resistividades [5]:**
    * Ánodo (Ni–YSZ): $\rho_a = 1 / (1.117e7 \cdot \exp(1392/T))$
    * Cátodo (LSM): $\rho_c = 1 / (1.232e4 \cdot \exp(-600/T))$
    * Electrolito (YSZ): $\rho_e = 1 / (3.401e4 \cdot \exp(-10350/T))$
* **Condiciones de operación [2]:**
    * Temperatura de combustible: $1123 \text{ K}$
    * Temperatura de aire: $873 \text{ K}$
    * Composiciones másicas de entrada:
        * Combustible: $0.89 \text{ H}_2$ y $0.11 \text{ H}_2\text{O}$
        * Aire: $0.23 \text{ O}_2$ y $0.77 \text{ N}_2$
    * Presión de operación: Atmosférica ($101325 \text{ Pa}$)

---

## Modelo matemático

El modelo se fundamenta en la ecuación principal que relaciona el voltaje de la celda ($U_{cell}$) con el potencial teórico de Nernst ($E$) y la suma de las pérdidas por polarización:

$$U_{cell} = E - (\eta_{act} + \eta_{conc} + \eta_{ohm})$$

Donde el voltaje reversible se ajusta a la temperatura de operación y por medio de Nernst:

$$U = U^{\circ} \cdot \frac{T}{T^{\circ}} + \frac{H^{\circ}}{2 \cdot F} \cdot \left(\frac{T}{T^{\circ}}-1\right)$$

$$E = U - \frac{R \cdot T}{2 \cdot F} \cdot \log\left(\frac{X_{H_2} \cdot X_{O_2}^{0.5}}{X_{H_2O}}\right)$$

Donde:
* $H^{\circ} = -241572 \text{ J/mol}$
* $T^{\circ} = 298.15 \text{ K}$
* $U^{\circ} = 1.229 \text{ V}$

### Polarización por Activación ($\eta_{act}$)

Esta pérdida está asociada a la energía de activación necesaria para que ocurran las reacciones electroquímicas en los electrodos. Se modela a partir de la ecuación de Butler-Volmer. El *paper* utiliza una aproximación hiperbólica, la cual es posible debido a que ambos $\alpha$ son iguales a $0.5$, resultando en:

$$\eta_{act} = \frac{RT}{F} \sinh^{-1} \left( \frac{i}{2 i_0} \right)$$

Aquí, $i$ es la densidad de corriente e $i_0$ es la densidad de corriente de intercambio, $i_0$ se considera constante para el ánodo y el cátodo con valores de $5300 \text{ A/m}^2$ y $2000 \text{ A/m}^2$, respectivamente.

### Polarización por Concentración ($\eta_{conc}$)

Esta pérdida surge de la limitación en el transporte de masa de los reactivos hacia los sitios activos. Se modela calculando primero la difusión efectiva ($D_{eff}$) en la función correspondiente, para ello se combinan los mecanismos de difusión molecular y de Knudsen, considerando la porosidad $\epsilon = 0.5$, tortuosidad $\tau = 3$, y radio promedio de poro $\overline{r} = 1 \text{ µm}$ [2].

* **Difusividad de Knudsen** para una especie $k$:
  
    $$D_k^K = \frac{2}{3} \overline{r} \sqrt{\frac{8RT}{\pi M_k}}$$
  
* **Difusividad molecular efectiva** en una mezcla multicomponente para la especie $k$:
  
    $$D_k^m = \frac{1 - X_k}{\sum_{l \neq k} \frac{X_l}{D_{kl}}}$$
  
* **Difusividades binarias** $D_{kl}$ (por ejemplo, entre $\text{H}_2$ - $\text{H}_2\text{O}$ en el ánodo y $\text{O}_2$-$\text{N}_2$ en el cátodo):
  
    $$D_{kl} = \frac{1e-7 T^{1.75} \left( \frac{1}{M_k} + \frac{1}{M_l} \right)^{1/2}}{p \left[ \left( \sum \nu \right)_k^{1/3} + \left( \sum \nu \right)_l^{1/3} \right]^2}$$

Con $\nu$ los volumenes atómicos [6]:
* $v_{H2}$ = 6.12
* $v_{H2O}$ = 13.1
* $v_{O2 }$ = 16.3
* $v_{N2 }$ = 18.5

Finalmente, las polarizaciones por concentración se calculan determinando las presiones parciales en el TPB (Triple Boundary Phase) y aplicando una reducción de la ecuación de sobrepotencial:

$$\eta_{conc}^a = \frac{RT}{2F} \ln \left( \frac{p_{H_2} \cdot p_{H_2O, TPB}}{p_{H_2, TPB} \cdot p_{H_2O}} \right)$$
$$\eta_{conc}^c = \frac{RT}{4F} \ln \left( \frac{p_{O_2}}{p_{O_2, TPB}} \right)$$

### Polarización Óhmica ($\eta_{ohm}$)

Esta pérdida es consecuencia de la resistencia al flujo de iones en el electrolito y de electrones en los electrodos:

$$\eta_{ohm} = i \cdot \sum_q (\rho_q \delta_q)$$

Donde $q$ representa cada componente (ánodo, cátodo, electrolito). La resistividad ($\rho_q$) de cada material es dependiente de la temperatura. Mientras que ($\delta_q$) se calcula en función de la geometría tubular específica, utilizando los parámetros adimensionales $A\pi = 0.804$ y $B\pi = 0.130$ y los espesores específicos.

---

## Implementación

Con todo lo planteado, el modelo se implementa en un main que realiza un cálculo iterativo sobre un conjunto de densidades de corriente experimentales, obteniendo la curva de polarización (voltaje vs. densidad de corriente) característica de la celda.
La Figura 3 del proyecto compara los resultados simulados con los valores experimentales, observándose pequeñas diferencias atribuibles a las aproximaciones realizadas.
Una posible mejora futura consiste en incorporar las temperaturas y presiones en el punto triple (TPB) dentro de las funciones que actualmente consideran solo valores promedio, lo que permitiría refinar el ajuste del modelo.

---

## Aplicación en Chile

Chile presenta un alto potencial para la aplicación de celdas SOFC, especialmente bajo el contexto del Plan Nacional de Hidrógeno Verde.
Estas celdas podrían integrarse en centrales solares o eólicas, como las de la región de Magallanes, aprovechando su enorme capacidad de generación eólica y los proyectos ya existentes de producción de hidrógeno.
El modelo desarrollado permitiría evaluar el voltaje de la celda ante distintas condiciones operacionales, optimizando el desempeño antes de realizar ensayos experimentales costosos y apoyando el diseño de sistemas basados en hidrógeno a nivel nacional.

## Impactos ambientales, sociales y económicos
Como se mencionó previamente, estas celdas cuentan con un impacto ambiental mínimo, ante solo podrucir como "residuo" agua. Esto se traduce en una contribución directa a la descarbonización del aire y, a largo plazo, en mejoras en la salud pública de las comunidades cercanas a los centros energéticos, teniendo así un beneficio social claro.
Desde el punto de vista económico, si bien actualmente los costos de implementación son elevados, entre 1695-2825 USD/kW, , se proyecta una reducción a 1356–1977 USD/kW en los próximos años [7]. Esta tendencia sugiere un escenario favorable para su incorporación progresiva, pero actualmente aún se presenta como una limitante en el ámbito de costos. 


## Proyección

Considerando la disminución esperada en los costos y el impulso que entrega el plan nacional de hidrógeno, Chile se encuentra en una posición privilegiada para expandir el uso de tecnologías SOFC en las próximas décadas.
Con una estrategia adecuada de inversión y desarrollo, el país podría incrementar la utilización de estas celdas tanto en generación eléctrica como en aplicaciones industriales, fortaleciendo la transición hacia una matriz energética más limpia, eficiente y sustentable.

---

## Referencias
* [1] What are Solid Oxide Fuel Cells?. Linde AMT. https://www.linde-amt.com/resource-library/articles/solid-oxide-fuel-cells#:~:text=Alta%20eficiencia%20y%20emisiones%20m%C3%ADnimas,tradicionales%20de%20generaci%C3%B3n%20de%20energ%C3%ADa.
* [2] Karcz, M. From 0D to 1D modeling of tubular solid oxide fuel cell. Energy Conversion And Management 2009, 50 (9), 2307-2315. https://doi.org/10.1016/j.enconman.2009.05.007.
* [3] A, H.; Santos, J. A. F.; Z, R.; Matencio, T. Ceramic Materials for Solid Oxide Fuel Cells. En InTech eBooks; 2011. https://doi.org/10.5772/18297.
* [4]Song, T. W.; Sohn, J. L.; Kim, J. H.; Kim, T. S.; Ro, S. T.; Suzuki, K. Performance analysis of a tubular solid oxide fuel cell/micro gas turbine hybrid power system based on a quasi-two dimensional model. Journal Of Power Sources 2004, 142 (1-2), 30-42. https://doi.org/10.1016/j.jpowsour.2004.10.011.
* [5] Zhang, X.; Li, G.; Li, J.; Feng, Z. Numerical study on electric characteristics of solid oxide fuel cells. Energy Conversion And Management 2006, 48 (3), 977-989. https://doi.org/10.1016/j.enconman.2006.08.011.
* [6] Ratnakar, R. R.; Dindoruk, B. The Role of Diffusivity in Oil and Gas Industries: Fundamentals, Measurement, and Correlative Techniques. Processes 2022, 10 (6), 1194. https://doi.org/10.3390/pr10061194.
* [7] Schubert, M. High-Temperature Fuel Cell - Solid Oxide Fuel Cell (SOFC) | IEA Advanced Fuel Cells. IEA Advanced Fuel Cells. https://ieafuelcell.com/output/technology-reports/high-temperature-fuel-cell-solid-oxide-fuel-cell-sofc/.


