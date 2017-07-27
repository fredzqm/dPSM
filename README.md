# dPSM
A mathematical research project using PSM (Power Series Method) to solve delayed differential equation

Many mathematical models make real-time assumptions about rates.  

#

In fact, many problems are delay problems in real life, but modelers may avoid these terms because delay problems can be difficult to approximate, and approaches may be ad hoc, in that they may only work for a particular class of problems. I propose a research project using the PSM (Power Series Method) method, as recently adapted for delay problems and dubbed dPSM, and dynamic programming approach to approximate a large class of DDEs.  

# Example Use Case
Population models like exponential growth and the logistic model have vector fields that depend on the current time, for example, `p'(t)=k p(t)`.  Translated to real terms, this assumes that newly born babies are contributing to the population growth. In reality, babies have to grow before they get married and have kids, which can be better modeled by `p'(t)=k*p(t-20)`. Including death by old age and immigration, there is `p'(t)= k_1*p(t-T_1)-k_2*p(t-T_{2})+m(t)`, where `T_1` is the average marriage age, `T_2` is the average lifespan and `m(t)` represents immigration. Now we have a delay differential equation 
(DDE) with a pulse.  

# Detailed Description
The goal of this research is implementing an efficient algorithm based on a PSM approach to approximate delayed differential equation systems. 
Numerically, the definition of derivative $f'(t) = \lim_{u\rightarrow0}{\frac{f(t+u)-f(t)}{u}}$ would have to be involved. Through this method, the program has to shrink the interval between calculation points to infinitesimal, a very expensive and inaccurate method. A high-order derivative is almost unsolvable efficiently.  Instead, PSM represents the solutions of the system as Taylor polynomials. Rather than taking arbitrary derivatives of a vector field, Picard's iteration are used to generate the Taylor polynomial, which can be executed in a symbolic fashion.
It is easy to calculate integrals on a polynomial accurately and efficiently.  High-order derivatives for PSM is just a few more steps. Those advantages help us choose PSM as the primary approach to tackling delayed differential system problem.

The student has already developed a MATLAB program capable of solving tough ordinary differential equation systems with PSM. The program has managed to find high order derivatives efficiently. This MATLAB program establishes a sound basis for this research. The focus of the research is to keep track of the moving parts in the delayed problem and apply dPSM to delay problem.

Delaying a polynomial is expensive. Given $f(x)= a_{0}+a_{1}x+a_{2}x^{2}+...$ , convert $f(x-\tau)$ for constant delay $\tau$ to the same polynomial form involves high-order binomial expansion. However, this version is easier to code and accurate, though it is expected to be quite inefficient. I plan to implement this version at the beginning as a control group that provides verification data.  Then I will devote my time to research and apply the advanced method dPSM given in \cite{I}.

PSM represents calculation points as a Taylor polynomials, while dPSM represents them as a 2-D array of Taylor polynomials --

$$
f(t)= \left\{
\begin{tabular}{l l l l l}
$a_{0,0}$ & + $a_{0,1}t^1$ & + $a_{0,2}t^2$ & ... & + $a_{0,n}t^n$ \\
  & + $a_{1,1}(t-\tau)^{1}$ & + $a_{1,2}(t-\tau)^{2}$ & ... & + $a_{1,n}(t-\tau)^{n}$ \\
  & & + $a_{2,2}(t-2\tau)^{2}$ & ... & + $a_{2,n}(t-2\tau)^{n}$ \\
  & & & ... \\  
  & & & ... & + $a_{n,n}(t-n\tau)^{n}$
\end{tabular} \right.
$$

\bigskip \noindent The software can just move coefficient to the right place to shift this form by $\tau$. As shown in \cite{I}, this representation has a crucial property -- as the iterations grow, lower order terms will no longer change. Therefore, in each Picard's Iteration, the program does not have to worry about previous terms but focuses on finding the next higher order term .

Furthermore, the delay time can even be a variable. The user can plot two graph of different delay time. This really makes this research more useful and meaningful. If one system is simulated, the user can experiment with different delay time. This helps particularly if the delay time is what the researcher needs to find.  However, more work have to be done for variable delay time, the coefficient $a_{i,j}$ above needs to be represented as a polynomial of $\tau$. The whole system turns out to be a 3-D array. The trickiest part of this research project is to keep track of those moving parts and perform correct and efficient calculations.
