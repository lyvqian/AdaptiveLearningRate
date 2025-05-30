# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

LogLik <- function(X, y, fam_link, beta, eps = 1e-15) {
    .Call(`_AdaGLM_LogLik`, X, y, fam_link, beta, eps)
}

Deviance <- function(X, y, beta, fam_link) {
    .Call(`_AdaGLM_Deviance`, X, y, beta, fam_link)
}

#' Fit generalized linear models with adaptive learning rate algorithm
#'
#' @name adaglm
#'
#' @description adaglm( ) fits generalized linear models with a self-defined adaptive learning rate algorithm and stepsize. Default is ADAM with alpha=0.01.   
#'
#' @usage adaglm(X, y, fam_link = "binomial_logit", optimizer = "ADAM", 
#' alpha = 0.01, rho = 0.99, max_iter = 1000, tol = 1e-6)
#'
#' @param X  a matrix of predictors
#' @param y  a vector of responses
#' @param fam_link can be one of "binomial_logit", "gaussian_identity", "Gamma_log", "poisson_log", meaning a distribution family and its corresponding link function
#' @param optimizer can be one of "ADAM", "AdaGrad", "AdaSmooth", "AdaDelta"
#' @param alpha stepsize used in ADAM, AdaGrad, AdaSmooth
#' @param rho decay rate used in AdaDelta
#' @param max_iter maximum number of iterations
#' @param tol tolerence
#'
#' @section Note:
#' The number of rows of X must match the length of y.
#' If intercept is needed, a column of 1's has to be manually added to X.
#'
#' @return A list with the following components:
#' \describe{
#'   \item{coef}{A numeric vector of estimated regression coefficients.}
#'   \item{iter}{An interger indicating the number of iterations.}
#' }
#'
#' @examples
#' 
#' ## An example for Binomial-logit: Use the R built-in "mtcars" dataset
#' if (requireNamespace("dplyr", quietly = TRUE) && requireNamespace("microbenchmark", quietly = TRUE)) {
#' library(dplyr)
#' library(microbenchmark)
#' 
#' data(mtcars)
#' X = mtcars %>% mutate(intercept = rep(1,nrow(mtcars))) %>% 
#'   dplyr::select(intercept, mpg, wt, hp) %>%
#'   as.matrix
#' y = mtcars$am
#' 
#' beta_glm = summary(glm(y~X[,2:4], family = binomial()))$coef[,1]
#' 
#' family = "binomial_logit"
#' 
#' bench <- suppressWarnings(microbenchmark(
#'   beta_adam <- adaglm(X,y,fam_link = family, optimizer = "ADAM", alpha=0.001),
#'   beta_adagrad <- adaglm(X,y,fam_link = family, optimizer = "AdaGrad", alpha=0.1),
#'   beta_adadelta <- adaglm(X,y,fam_link = family, optimizer = "AdaDelta"),
#'   beta_adasmooth <- adaglm(X,y,fam_link = family, optimizer = "AdaSmooth", alpha=0.001),
#'   beta_glm = summary(glm(y~X[,2:4], family = binomial))$coef[,1], times = 1L))
#' }
#' exec_time_mtcars = summary(bench)$median
#' names(exec_time_mtcars) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' exec_time_mtcars
#'   
#' beta_mat <- cbind(beta_adam$coef, beta_adagrad$coef, beta_adadelta$coef, beta_adasmooth$coef, as.numeric(beta_glm))
#' colnames(beta_mat) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' beta_mat
#'   
#' loglik_mtcars = c(LogLik(X,y,fam_link = family, beta = beta_adam$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_adagrad$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_adadelta$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_glm))
#'       
#' names(loglik_mtcars) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' loglik_mtcars
#' 
#' Deviance_mtcars = c(Deviance(X,y,fam_link = family, beta = beta_adam$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_adagrad$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_adadelta$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_glm))
#' names(Deviance_mtcars) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' Deviance_mtcars
#' 
#' 
#' ## An example for Poisson-log: Use the R built-in "quine" dataset
#' if (requireNamespace("dplyr", quietly = TRUE) && requireNamespace("microbenchmark", quietly = TRUE)) {
#'   data(quine, package = "MASS")
#'   X <- dplyr::mutate(quine,
#'     Ethnic = dplyr::case_when(Eth == "A" ~ 1, Eth == "N" ~ 0),
#'     Sex = dplyr::case_when(Sex == "F" ~ 1, Sex == "M" ~ 0),
#'     Age_F1 = dplyr::case_when(Age == "F1" ~ 1, TRUE ~ 0),
#'     Age_F2 = dplyr::case_when(Age == "F2" ~ 1, TRUE ~ 0),
#'     Age_F3 = dplyr::case_when(Age == "F3" ~ 1, TRUE ~ 0),
#'     Learner = dplyr::case_when(Lrn == "SL" ~ 1, Lrn == "AL" ~ 0),
#'     intercept = 1
#'   ) |> dplyr::select(intercept, Ethnic, Sex, Age_F1, Age_F2, Age_F3, Learner) |> as.matrix()
#'   y <- quine$Days
#'   family <- "poisson_log"
#'   bench <- suppressWarnings(microbenchmark::microbenchmark(
#'     beta_adam <- adaglm(X, y, fam_link = family, optimizer = "ADAM"),
#'     beta_adagrad <- adaglm(X, y, fam_link = family, optimizer = "AdaGrad"),
#'     beta_adadelta <- adaglm(X, y, fam_link = family, optimizer = "AdaDelta"),
#'     beta_adasmooth <- adaglm(X, y, fam_link = family, optimizer = "AdaSmooth"),
#'     beta_glm <- summary(glm(y ~ X[, 2:7], family = poisson()))$coef[, 1],
#'     times = 1L
#'   ))
#' }
#' 
#' exec_time_quine = summary(bench)$median
#' names(exec_time_quine) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' exec_time_quine
#' 
#' beta_mat <- cbind(beta_adam$coef, 
#' beta_adagrad$coef, beta_adadelta$coef, 
#' beta_adasmooth$coef, as.numeric(beta_glm))
#' colnames(beta_mat) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' beta_mat
#' 
#' loglik_quine = c(LogLik(X,y,fam_link = family, beta = beta_adam$coef),
#'                 LogLik(X,y,fam_link = family, beta = beta_adagrad$coef),
#'                 LogLik(X,y,fam_link = family, beta = beta_adadelta$coef),
#'                 LogLik(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'                 LogLik(X,y,fam_link = family, beta = beta_glm))
#'                 names(loglik_quine) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' loglik_quine
#' 
#' Deviance_quine = c(Deviance(X,y,fam_link = family, beta = beta_adam$coef),
#'                  Deviance(X,y,fam_link = family, beta = beta_adagrad$coef),
#'                  Deviance(X,y,fam_link = family, beta = beta_adadelta$coef),
#'                  Deviance(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'                  Deviance(X,y,fam_link = family, beta = beta_glm))
#'                  names(Deviance_quine) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' Deviance_quine
#' 
#' ## An example for Gaussian-identity: Use the R built-in "mtcars" dataset
#' 
#' data(mtcars)
#' X = mtcars %>% mutate(intercept = rep(1,nrow(mtcars))) %>% 
#'   dplyr::select(intercept, wt, hp) %>%
#'   as.matrix
#' y = mtcars$mpg
#' 
#' beta_glm = summary(glm(y~X[,2:3], family = gaussian()))$coef[,1]
#' 
#' family = "gaussian_identity"
#' 
#' bench <- suppressWarnings(microbenchmark(
#'   beta_adam <- adaglm(X,y,fam_link = family, optimizer = "ADAM"),
#'   beta_adagrad <- adaglm(X,y,fam_link = family, optimizer = "AdaGrad"),
#'   beta_adadelta <- adaglm(X,y,fam_link = family, optimizer = "AdaDelta"),
#'   beta_adasmooth <- adaglm(X,y,fam_link = family, optimizer = "AdaSmooth"),
#'   beta_glm = summary(glm(y~X[,2:3], family = gaussian()))$coef[,1], times = 1L))
#' exec_time_mtcars = summary(bench)$median
#' names(exec_time_mtcars) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' exec_time_mtcars
#'   
#' beta_mat <- cbind(beta_adam$coef, beta_adagrad$coef, beta_adadelta$coef, beta_adasmooth$coef, as.numeric(beta_glm))
#' colnames(beta_mat) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' beta_mat
#'   
#' loglik_mtcars = c(LogLik(X,y,fam_link = family, beta = beta_adam$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_adagrad$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_adadelta$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'       LogLik(X,y,fam_link = family, beta = beta_glm))
#'       
#' names(loglik_mtcars) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' loglik_mtcars
#' 
#' Deviance_mtcars = c(Deviance(X,y,fam_link = family, beta = beta_adam$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_adagrad$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_adadelta$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'                     Deviance(X,y,fam_link = family, beta = beta_glm))
#' names(Deviance_mtcars) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' Deviance_mtcars
#' 
#' ## An example for Gamma-log: Use the R built-in "airquality" dataset
#' 
#' data(airquality)
#' air <- na.omit(airquality)
#' X = air %>% mutate(intercept = rep(1,nrow(air))) %>% 
#'   dplyr::select(intercept, Solar.R, Temp, Wind) %>%
#'   as.matrix
#' 
#' y = air$Ozone
#' 
#' beta_glm = summary(glm(y~X[,2:4], family = Gamma(link = "log")))$coef[,1]
#' 
#' family = "Gamma_log"
#' bench <- suppressWarnings(microbenchmark(
#'   beta_adam <- adaglm(X,y,fam_link = family, optimizer = "ADAM", alpha=0.0001),
#'   beta_adagrad <- adaglm(X,y,fam_link = family, optimizer = "AdaGrad", alpha=0.0001),
#'   beta_adadelta <- adaglm(X,y,fam_link = family, optimizer = "AdaDelta"),
#'   beta_adasmooth <- adaglm(X,y,fam_link = family, optimizer = "AdaSmooth", alpha=0.0001),
#'   beta_glm = summary(glm(y~X[,2:4], family = Gamma(link = "log")))$coef[,1], times = 1L))
#' exec_time_insurance = summary(bench)$median
#' names(exec_time_insurance) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' exec_time_insurance
#'   
#' beta_mat <- cbind(beta_adam$coef, beta_adagrad$coef, beta_adadelta$coef, beta_adasmooth$coef, as.numeric(beta_glm))
#' colnames(beta_mat) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' beta_mat
#' loglik_insurance = c(LogLik(X,y,fam_link = family, beta = beta_adam$coef),
#'                       LogLik(X,y,fam_link = family, beta = beta_adagrad$coef),
#'                       LogLik(X,y,fam_link = family, beta = beta_adadelta$coef),
#'                       LogLik(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'                       LogLik(X,y,fam_link = family, beta = beta_glm))
#' names(loglik_insurance) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' loglik_insurance
#'   
#' Deviance_insurance = c(Deviance(X,y,fam_link = family, beta = beta_adam$coef),
#'                         Deviance(X,y,fam_link = family, beta = beta_adagrad$coef),
#'                         Deviance(X,y,fam_link = family, beta = beta_adadelta$coef),
#'                         Deviance(X,y,fam_link = family, beta = beta_adasmooth$coef),
#'                         Deviance(X,y,fam_link = family, beta = beta_glm))
#' names(Deviance_insurance) = c("ADAM", "AdaGrad", "AdaDelta", "AdaSmooth", "glm_fn")
#' Deviance_insurance
#' 
#' 
#' 
#' @export
#'
NULL

adaglm <- function(X, y, fam_link = "binomial_logit", optimizer = "ADAM", alpha = 0.01, rho = 0.99, max_iter = 1000L, tol = 1e-6) {
    .Call(`_AdaGLM_adaglm`, X, y, fam_link, optimizer, alpha, rho, max_iter, tol)
}

