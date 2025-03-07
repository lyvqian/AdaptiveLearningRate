library(Rcpp)
library(RcppArmadillo)
library(microbenchmark)
library(pROC)

set.seed(123)

n_replicates <- 20
n <- 1000    
p <- 500    

mse <- function(beta_est, beta_true) {
  mean((beta_est - beta_true)^2)
}

run_simulation <- function() {
  X <- cbind(1, matrix(rnorm(n * p), n, p))
  true_beta <- c(1, rnorm(p))  
  prob <- 1 / (1 + exp(-X %*% true_beta))
  y <- rbinom(n, 1, prob)

  beta_adagrad <- adagrad_logistic(X, y)
  beta_adam <- adam_logistic(X, y)
  beta_adasmooth <- adasmooth_logistic(X, y)
  beta_adadelta <- adadelta_logistic(X, y)
  # fit_glm <- glm(y ~ X[, -1], family = binomial)
  # beta_glm <- coef(fit_glm)
  beta_irwls <- irwls_logistic(X, y)

  mse_adagrad <- mse(beta_adagrad, true_beta)
  mse_adam <- mse(beta_adam, true_beta)
  mse_adasmooth <- mse(beta_adasmooth, true_beta)
  mse_adadelta <- mse(beta_adadelta, true_beta)
  #mse_glm <- mse(beta_glm, true_beta)
  mse_irwls <- mse(beta_irwls, true_beta)
  
  preds_adagrad <- 1 / (1 + exp(-X %*% beta_adagrad))
  preds_adam <- 1 / (1 + exp(-X %*% beta_adam))
  preds_adasmooth <- 1 / (1 + exp(-X %*% beta_adasmooth))
  preds_adadelta <- 1 / (1 + exp(-X %*% beta_adadelta))
  #preds_glm <- predict(fit_glm, type = "response")
  preds_irwls <- 1 / (1 + exp(-X %*% beta_irwls))
  
  acc_adagrad <- mean(ifelse(preds_adagrad > 0.5, 1, 0) == y)
  acc_adam <- mean(ifelse(preds_adam > 0.5, 1, 0) == y)
  acc_adasmooth <- mean(ifelse(preds_adasmooth > 0.5, 1, 0) == y)
  acc_adadelta <- mean(ifelse(preds_adadelta > 0.5, 1, 0) == y)
  # acc_glm <- mean(ifelse(preds_glm > 0.5, 1, 0) == y)
  acc_irwls <- mean(ifelse(preds_irwls > 0.5, 1, 0) == y)
  
  # auc_adagrad <- auc(y, as.numeric(preds_adagrad))
  # auc_adam <- auc(y, as.numeric(preds_adam))
  # auc_glm <- auc(y, as.numeric(preds_glm))

  bench <- suppressWarnings(microbenchmark(
    #glm = glm(y ~ X[, -1], family = binomial),
    irwls = irwls_logistic(X, y),
    adagrad = adagrad_logistic(X, y),
    adam = adam_logistic(X, y),
    adasmooth = adasmooth_logistic(X, y),
    adadelta = adadelta_logistic(X, y),
    times = 1L
  ))
  
  exec_time_irwls <- summary(bench)$median[1]
  #exec_time_glm <- summary(bench)$median[1]
  exec_time_adagrad <- summary(bench)$median[2]
  exec_time_adam <- summary(bench)$median[3]
  exec_time_adasmooth <- summary(bench)$median[4]
  exec_time_adadelta <- summary(bench)$median[5]
  
  return(data.frame(mse_adagrad, mse_adam, mse_irwls, mse_adadelta, mse_adasmooth,
                    acc_adagrad, acc_adam, acc_irwls, acc_adadelta, acc_adasmooth,
                    #auc_adagrad, auc_adam, auc_glm, 
                    exec_time_adagrad, exec_time_adam, exec_time_irwls, exec_time_adadelta, exec_time_adasmooth))
}

results <- do.call(rbind, lapply(1:n_replicates, function(i) run_simulation()))

summary(results)

boxplot(results$mse_adagrad, results$mse_adam, results$mse_adasmooth, results$mse_adadelta, results$mse_irwls, 
        names = c("AdaGrad", "Adam", "AdaSmooth", "AdaDelta", "IRWLS"),
        main = "MSE (beta)",
        ylab = "Mean Squared Error")

boxplot(results$acc_adagrad, results$acc_adam, results$acc_adasmooth, results$acc_adadelta, results$acc_irwls, 
        names = c("AdaGrad", "Adam", "AdaSmooth", "AdaDelta", "IRWLS"),
        main = "Prediction Accuracy",
        ylab = "Classification Accuracy")

boxplot(results$exec_time_adagrad, results$exec_time_adam, results$exec_time_adasmooth, results$exec_time_adadelta, results$exec_time_irwls, 
        names = c("AdaGrad", "Adam", "AdaSmooth", "AdaDelta", "IRWLS"),
        main = "Execution Time",
        ylab = "Time (ms)")

