References: arXiv:1809.02293
## Bayesian inference

Bayes theorem

$$
p(\mathrm{Physics} | \mathrm{Data}) \propto p(\mathrm{Data} | \mathrm{Physics}) p(\mathrm{Physics}).
$$

Combine what we already know about the Universe with new data to learn something new about physics.

What is a prior?
- Encode our current knowledge about the phenomenon.
- What do we do if we don't have any specific knowledge?
- In practice we will often write $\pi$.

What is a likelihood?
- A model for the data given the phenomenon of interest.
- Requires modeling both the things we care about ("signals") and things we don't ("noise").
- In practice we will often write ${\cal L}$.

## Gravitational wave transients

What is the data model?
- Detector noise described by some power spectrum that we assume is known.
- Astrophysical signal described by intrinsic binary parameters.
- Detector response determined extrinsic parameters and detector calibration model.
- Most obvious way to write the likelihood is in the time domain

  $$\ln p(d | \theta) = -\sum_{t_{i}, t_{j}} \frac{1}{2} (d(t_{i}, \theta) - h_{i}(\theta)) C^{-1}(t_{i},t_{j}) (d(t_{j}) - h(t_{j}, \theta)) - \frac{1}{2} \ln\det C.$$

- $h$ is the response to the detector to the passing wave. $C$ is the noise covariance matrix and $d$ the interferometer strain.
- Define an inner product

  $$\langle x, y\rangle_{C} = \sum_{t_{i}, t_{j}} \frac{1}{2} (d(t_{i}, \theta) - h_{i}(\theta)) C^{-1}(t_{i},t_{j}) (d(t_{j}) - h(t_{j}, \theta))$$

- Remove terms that don't depend on $\theta$

  $$\ln p(d | \theta) = -\frac{1}{2} \langle h(\theta), h(\theta) \rangle_{C} + \langle d, h(\theta) \rangle_{C} + k.$$

- Matrix operations: gross, how can we simplify this?
- Assume the noise is stationary

  $$C(t_{i},t_{j}) = R(\tau = t_{i} - t_{j}),$$

  the covariance matrix is circulant, enables some optimizations of whitening process.
- The Fourier basis diagonalizes the noise power spectral density "Whittle approximation".
- We need to define a discrete Fourier transform

```math
\tilde{x}_{k} = \mathcal{F}(x_{n}) = \Delta t\sum _{n=0}^{N-1}x_{n}\cdot e^{-i2\pi {\tfrac {k n}{N}}}.
```

- Specifically we will want to define

```math
\begin{align}
S_{k} &= \mathcal{F}(R_{i}) \\
\tilde{d}_{k} &= \mathcal{F}(d_{i}) \\
\tilde{h}_{k} &= \mathcal{F}(d_{i}) 
\end{align}.
```

- We can now write down the frequency domain "Whittle" likelihood

```math
\ln {\cal L}(d | \theta) = - \frac{2}{T} \sum_{k} \frac{|h_{k}|^2}{S_{k}} + \frac{4}{T} {\cal \mathrm{Re}} \sum_{k} \frac{h_{k} d^{*}_{k}}{S_{k}} + k .
```

- **Note**: assumes periodicity over the observed segment.

How do the parameters impact the observed signal?
- Mass: a total scaling of the signal ($f \propto M$, $A \propto M^{5/6}$)
- Mass ratio: complicated
- Aligned spins: lengthens/shortens the signal "orbital hang up"
- Misaligned spins: spin-induced orbital precession leads to frequency-dependent amplitude modulation
- Distance: an amplitude scaling of the signal ($A \propto 1 / d_{L}$)
- Inclination/phase changes the relative important of different emission harmonics
- Sky location: the antenna response of the instruments to the different gravitational-wave polarizations depends on the position on the sky. Next generation instruments the response is time and frequency-dependent.
- Detector calibration: the detectors are imperfectly calibrated and so the expected template must be corrected based to account for this

This is great, but can we make the problem simpler?

Choice of parameters
- Chirp mass/mass ratio vs component masses
- Detector-based coordinates

Some of the parameters that have a simple effect on the waveform can be marginalized over.
**Note: marginalization not maximization.**
- Define the marginalized likelihood over some parameter $\varphi$

```math
{\cal L}_{{\varphi}}(d | \theta / \varphi) = \int d \varphi {\cal L}(d | \theta) \pi(\varphi)
```

- We can marginalize efficiently over distance, time, and sometimes phase, as an example distance

```math
\begin{align}
\tilde{h}_{k}(d_{L}) &= \frac{d_{0}}{d_{L}} \tilde{h}_{k}(d_{0}) \\
{\cal L}(d | \theta) &\propto \exp\left( - \frac{2}{T} \left(\frac{d_{0}}{d_{L}}\right)^2 \sum_{k} \frac{|h_{k}(d_{0})|^2}{S_{k}} + \frac{4}{T} \left(\frac{d_{0}}{d_{L}}\right) {\cal \mathrm{Re}} \sum_{k} \frac{h_{k}(d_{0}) d^{*}_{k}}{S_{k}} \right) \\
{\cal L}_{d_{L}}(d | \theta / d_{L}) &\propto \int d d_{L} \exp\left( - A \left(\frac{d_{0}}{d_{L}}\right)^2 + B \left(\frac{d_{0}}{d_{L}}\right) \right) \pi(d_{L}) \\
\end{align}.
```

  We construct a lookup table in $L_{d_{L}}(A, B)$ which can then be queried quickly to enable faster inference.
  Since distance is strongly correlated with the inclination angle, this marginalization can dramatically improve sampler performance.
  (Ask me about other parameters).
  - The marginalized parameters can be reconstructed in post-processing by resampling using the known likelihood surface.

Other formulations of the likelihood.
- The frequency domain version of the likelihood reduces the cost from $O(N^3) \to O(N)$ ($O(N \ln N)$ for time domain waveform).
- Can we do better? Yes, by reducing the number of data points we need.
- Multibanding: use lower sampling rate at earlier times. Valid for all waveform models and can get large speedups for long durations.
- ROQ: construct an optimal base for describing $\langle d, h \rangle$ and $\langle h, h \rangle$, evaluate the full likelihood by evaluating the waveform only at a small number of frequency nodes. Speedups are extremely large for simple waveform models and long durations. Enabled online PE for BNS in < 5 minutes during O4 (if there were any...). Requires an expensive offline step to build the basis.
- Heterodyning: First order Taylor of the $\langle d, h \rangle$ and $\langle h, h \rangle$ around some fiducial values $\langle d, h(\theta_{0}) \rangle$ and $\langle h(\theta_{0}), h(\theta_{0}) \rangle$ that can be evaluated at a small number of nodes. Comparable speedup to ROQ but set up cost is done on the fly per signal and requires having a good starting point, e.g., by running an optimizer.

Can't introducing these approximations lead to a bias?
- Yes, each has some (tunable for ROQ and relbin) approximation bias.
- Posteriors are generally biased when the bias in the likelihood approximation varies by more than O(1) across the parameter space (more this afternoon).
- We can correct for this bias with importance sampling using weights

  $$w(\theta) = \frac{{\cal L}(d | \theta)}{{\cal L}_{\mathrm{approx}}(d | \theta)}.$$

## Stochastic sampling

How can we understand the posterior distribution in high-dimensional spaces?
- Evaluating on a grid becomes prohibitively expensive.
- We need some kind of method of drawing samples from the posterior distribution.

Rejection sampling
- The simples stochastic sampling algorithm
- Draw many samples from the prior distribution
- Calculate weights using the likelihood for each sample

  $$w_{i} = \frac{p(d | \theta_{i})}{\max_{i}p(d | \theta_{i})}.$$
- Keep points according to the weight

  $$w_{i} > x_{i}; \quad x_{i} \sim U(0, 1).$$
- Embarassingly parallel.
- This is typically much too inefficient in more than a few dimensions or for very narrow posterior distributions.
- Improvements: use some conditioning step to sample from a better proposal distribution, e.g., simple PE, DINGO, adaptive importance sampling/surrogate building, e.g., RiFT.

MCMC (Markov chain Monte Carlo)
- Perform a directed random walk through the parameter space that is guaranteed to asymptotically produce unbiased samples from the posterior.
- The proposal distribution for each step should be tuned to the problem being considered but must satisfy "detailed balance".
- Also embarassingly parallel.
- In practice, we don't use this much for CBCs as the space is difficult to explore and sampling is extremely inefficient.
- Improvements: ensemble MCMC (e.g., emcee), Hamiltonian Monte Carlo (e.g., NUTS) using derivative based information

Nested sampling
- The current workhorse of LVK inference.
- Begin with a pool of "live" points drawn from the prior.
- Iteratively replace the lowest likelihood point with a higher likelihood point from the constrained prior.
- Each "dead" point (a.k.a., nested sample) gets an associated weight that can be importance sampled to produce posterior samples.

## Bilby (slides plus documentation)

- [Basics of parameter estimation](https://bilby-dev.github.io/bilby/basics-of-parameter-estimation.html)
- [Priors](https://bilby-dev.github.io/bilby/making_priors.html)
- [Likelihoods](https://bilby-dev.github.io/bilby/fitting_with_x_and_y_errors.html)
- [Sampler comparison](https://bilby-dev.github.io/bilby/compare_samplers.html)
- [Gravitational-wave example](https://bilby-dev.github.io/bilby/visualising_the_results.html)
