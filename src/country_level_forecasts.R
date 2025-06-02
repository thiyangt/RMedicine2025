
```{r, warning=FALSE, message=FALSE, out.width="100%"}
library(fable)
library(fabletools)
library(tsibble)
library(dplyr)
# Ensure yearweek is a tsibble index
country_weekly_tsibble_train <- country_weekly_tsibble |>
  filter(yearweek < yearweek("2025 W01")) |>
  filter(yearweek > yearweek("2018 W01"))
# Fit ARIMA model
arima_fit <- country_weekly_tsibble_train |>
  model(ARIMA = ARIMA(total_cases))
# Forecast for 52 weeks of 2025
arima_forecast <- arima_fit |>
  forecast(h = "9 weeks")
actual_2025 <- country_weekly_tsibble |>
  filter(yearweek >= yearweek("2025 W01"))

# Step 4: Plot forecast + actual
autoplot(arima_forecast) +
  geom_line(data = actual_2025, aes(x = yearweek, y = total_cases), color = "red", linewidth = 1) +
  labs(
    title = "Forecast vs Actual Weekly Dengue Cases in 2025",
    subtitle = "ARIMA Model Forecast (Blue) and Actual Cases (Red)",
    x = "Week",
    y = "Dengue Cases"
  ) +
  theme_minimal()

```

##

```{r}
fabletools::accuracy(arima_forecast,actual_2025 )
```