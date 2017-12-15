counts = histcounts(error);
CDF = cumsum(counts)/sum(counts);
plot(CDF);