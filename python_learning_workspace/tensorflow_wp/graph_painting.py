#region example1:
# from matplotlib import pyplot
# from numpy.random import normal

# sample = normal(size=100)

# pyplot.hist(sample, bins=10)
# pyplot.show()

# print("pause for showing.")

# pyplot.hist(sample, bins=3)
# pyplot.show()

# print("pause for showing.")
#endregion

#region example2:

# example of parametric probability density estimation
from matplotlib import pyplot
from numpy.random import normal
from numpy import mean
from numpy import std
from scipy.stats import norm
# generate a sample
sample = normal(loc=50, scale=5, size=1000)
# calculate parameters
sample_mean = mean(sample)
sample_std = std(sample)
print('Mean=%.3f, Standard Deviation=%.3f' % (sample_mean, sample_std))
# define the distribution
dist = norm(sample_mean, sample_std)
# sample probabilities for a range of outcomes
values = [value for value in range(30, 70)]
probabilities = [dist.pdf(value) for value in values]
# plot the histogram and pdf
pyplot.hist(sample, bins=10, density=True)
pyplot.plot(values, probabilities)
pyplot.show()

print("for showing pic.")
#endregion