library(quantmod)
library(writexl)

tickers = c("VTI", "VXUS", "VNQ", "BND", "BNDX", "SHV", "VT")

# Download each fund and keep the month-end adjusted close
get_monthly = function(t) {
  x = getSymbols(t, src = "yahoo",
                  from = "2021-09-01", to = "2026-09-30",
                  auto.assign = FALSE)
  to.monthly(Ad(x), OHLC = FALSE)
}

prices = do.call(merge, lapply(tickers, get_monthly))
colnames(prices) = tickers
prices = na.omit(prices)   # drops months where any fund has no data

df = data.frame(Date = as.Date(index(prices)), coredata(prices))

write_xlsx(df, "prices.xlsx")
print(head(df)); print(nrow(df))

