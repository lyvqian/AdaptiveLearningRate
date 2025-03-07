# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

adadelta_logistic <- function(X, y, max_iter = 1000L, epsilon = 1e-6, rho = 0.95) {
    .Call(`_AdaptiveLearningRate_adadelta_logistic`, X, y, max_iter, epsilon, rho)
}

adagrad_logistic <- function(X, y, eta = 0.1, max_iter = 1000L, epsilon = 1e-6) {
    .Call(`_AdaptiveLearningRate_adagrad_logistic`, X, y, eta, max_iter, epsilon)
}

adasmooth_logistic <- function(X, y, eta = 0.1, max_iter = 1000L, epsilon = 1e-6, rho1 = 0.5, rho2 = 0.99, M = 10L) {
    .Call(`_AdaptiveLearningRate_adasmooth_logistic`, X, y, eta, max_iter, epsilon, rho1, rho2, M)
}

adam_logistic <- function(X, y, alpha = 0.01, max_iter = 1000L, beta1 = 0.9, beta2 = 0.999, epsilon = 1e-8) {
    .Call(`_AdaptiveLearningRate_adam_logistic`, X, y, alpha, max_iter, beta1, beta2, epsilon)
}

irwls_logistic <- function(X, y, max_iter = 100L, tol = 1e-6) {
    .Call(`_AdaptiveLearningRate_irwls_logistic`, X, y, max_iter, tol)
}

