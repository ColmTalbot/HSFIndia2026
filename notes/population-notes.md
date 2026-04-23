## What do we want to measure and what have we measured? (slides)

## Individual events to populations (board)

References: arXiv:1809.02293, arXiv:2007.05579, arxiv:2304.06138, arxiv:2509.07221

We previously defined the likelihood for individual events.
Now we are interested in the likelihood of obtaining the catalog data given the population model $p(\{d\} | \Lambda)$.
How is this constructed?

What is the data?
- Assume the full data stream is a sum of detector noise and astrophysical signals, the distribution of the data can then be written $p(D | \Lambda) = \cal{N}(0; \mathrm{PSD}) + \mathrm{Poisson}(h; \Lambda)$

Various approaches:
- Thresholded poisson process
- Assume we have IID draws from the distribution of data passing the threshold

How does data enter the catalog?
- Search pipelines define a threshold for the strain data $\rho_{\mathrm{th}}(h)$ and then a given stretch of data $d$ enters the catalog if $\rho(D) > \rho_{\mathrm{th}}(D)$.
- The data that enters the catalog is then a more complex representation including the strain, search responses to the strain, posterior samples for the underlying source parameters.

## Practical issues (board)

How do we calculate the population likelihood in practice?
- Each observation is an IID draw from the distribution of catalog strain (e.g., a biased subset of the full strain) $$p(\{d\} | \Lambda) = \prod_{i} p(d_{i} | \Lambda).$$
- Since we have a closed form expression for $p(d | \theta)$, estimate $p(d | \Lambda)$ by integrating over all binary parameters and then renormalizing $$p(d | \Lambda) = \frac{1}{P_{\mathrm{det}}(\Lambda)} \int d\theta p(D|\theta) p(d|\theta).$$

**Note**: $p(d | \Lambda) \neq p(D | \Lambda)$!!!

$$
p(d | \Lambda) \propto p(D | \Lambda) \Theta(\rho(D) - \rho_{\mathrm{th}}(D))
$$

How do we estimate selection effects?
- Estimate the fraction of the full data stream given a population model that passes the threshold
$$P_{\mathrm{\det}}(\Lambda) = \int d D p(D | \Lambda) \Theta(\rho(D) - \rho_{\mathrm{th}}(D))$$

These are very large dimensional integrals!

Use Monte Carlo integrals to estimate the integrals instead.

$$
\begin{align}
p(h | \Lambda) \approx \hat{p}(h | \Lambda) = p(h|\varnothing) \sum_{\theta_{j} \sim p(\theta | h, \varnothing)} \frac{p(\theta | \Lambda)}{p(\theta|\varnothing)} \\
P_{\mathrm{\det}}(\Lambda) \approx \hat{P}_{\mathrm{\det}}(\Lambda) = P_{\mathrm{\det}}(\varnothing) \sum_{\theta_{j} \sim p(\theta | \mathrm{inj})} \frac{p(\theta | \Lambda)}{p(\theta|\mathrm{inj})}
\end{align}
$$

$$p(\{d\} | \Lambda) \approx \hat{p}(\{d\} | \Lambda) = \frac{1}{\hat{P}^{N}_{\mathrm{\det}}(\Lambda)} \prod_{i} \hat{p}(D_{i} | \Lambda)
$$

Is this a good approximation?

Monte Carlo integrals have an associated error

$$\mathrm{Var}[\hat{I}] = \frac{1}{M} \mathrm{Var}[w_{i}]$$

The total variance in our likelihood estimate is

$$
\mathrm{Var}[\ln \hat{p}(\{d\} | \Lambda)] = \sum_{i} \mathrm{Var}[\ln \hat{p}(d_{i} | \Lambda)] + N^2 \mathrm{Var}[\ln \hat{P}_{\mathrm{\det}}(\Lambda)].
$$

This scales quadratically in the population size and will be largest for narrow population models.

Actually we should calculate the average covariance across the posterior

$$
\int d \Lambda_{1} d\Lambda_{2} \mathrm{Covar}[\ln \hat{p}(\{d\} | \Lambda_{1}), \ln \hat{p}(\{d\} | \Lambda_{2})] p(\Lambda_{1} | \{d\}) p(\Lambda_{2} | \{d\})
$$

Also, this is a biased estimator of the likelihood!

## GWPopulation/wcosmo (colab)
