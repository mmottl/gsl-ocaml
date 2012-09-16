(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


(* GAUSSIAN *)
external gaussian : Rng.t -> sigma:float -> float
    = "ml_gsl_ran_gaussian"

external gaussian_ratio_method : Rng.t -> sigma:float -> float
    = "ml_gsl_ran_gaussian_ratio_method"

external gaussian_ziggurat : Rng.t -> sigma:float -> float 
    = "ml_gsl_ran_gaussian_ziggurat"

external gaussian_pdf : float -> sigma:float -> float
    = "ml_gsl_ran_gaussian_pdf" "gsl_ran_gaussian_pdf" "float"


external ugaussian : Rng.t -> float
    = "ml_gsl_ran_ugaussian"

external ugaussian_ratio_method : Rng.t -> float
    = "ml_gsl_ran_ugaussian_ratio_method"

external ugaussian_pdf : float -> float
    = "ml_gsl_ran_ugaussian_pdf" "gsl_ran_ugaussian_pdf" "float"


(* GAUSSIAN TAIL *)
external gaussian_tail : Rng.t -> a:float -> sigma:float -> float
    = "ml_gsl_ran_gaussian_tail"

external gaussian_tail_pdf : float -> a:float -> sigma:float -> float
    = "ml_gsl_ran_gaussian_tail_pdf" "gsl_ran_gaussian_tail_pdf" "float"

external ugaussian_tail : Rng.t -> a:float -> float
    = "ml_gsl_ran_ugaussian_tail"

external ugaussian_tail_pdf : float -> a:float -> float
    = "ml_gsl_ran_ugaussian_tail_pdf" "gsl_ran_ugaussian_tail_pdf" "float"


(* BIVARIATE *)
external bivariate_gaussian : 
    Rng.t -> sigma_x:float -> sigma_y:float -> rho:float -> float * float
    = "ml_gsl_ran_bivariate_gaussian"

external bivariate_gaussian_pdf : 
    x:float -> y:float -> sigma_x:float -> sigma_y:float -> rho:float -> float
    = "ml_gsl_ran_bivariate_gaussian_pdf" "gsl_ran_bivariate_gaussian_pdf" "float"


(* EXPONENTIAL *)
external exponential : Rng.t -> mu:float -> float 
    = "ml_gsl_ran_exponential"

external exponential_pdf : float -> mu:float -> float 
    = "ml_gsl_ran_exponential_pdf" "gsl_ran_exponential_pdf" "float"

(* LAPLACE *)
external laplace : Rng.t -> a:float -> float 
    = "ml_gsl_ran_laplace"

external laplace_pdf : float -> a:float -> float 
    = "ml_gsl_ran_laplace_pdf" "gsl_ran_laplace_pdf" "float"

(* EXPPOW *)
external exppow : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_exppow"

external exppow_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_exppow_pdf" "gsl_ran_exppow_pdf" "float"

(* CAUCHY *)
external cauchy : Rng.t -> a:float -> float 
    = "ml_gsl_ran_cauchy"

external cauchy_pdf : float -> a:float -> float 
    = "ml_gsl_ran_cauchy_pdf" "gsl_ran_cauchy_pdf" "float"

(* RAYLEIGH *)
external rayleigh : Rng.t -> sigma:float -> float 
    = "ml_gsl_ran_rayleigh"

external rayleigh_pdf : float -> sigma:float -> float 
    = "ml_gsl_ran_rayleigh_pdf" "gsl_ran_rayleigh_pdf" "float"

(* RAYLEIGH TAIL *)
external rayleigh_tail : Rng.t -> a:float -> sigma:float -> float 
    = "ml_gsl_ran_rayleigh_tail"

external rayleigh_tail_pdf : float -> a:float -> sigma:float -> float 
    = "ml_gsl_ran_rayleigh_tail_pdf" "gsl_ran_rayleigh_tail_pdf" "float"

(* LANDAU *)
external landau : Rng.t -> float
    = "ml_gsl_ran_landau"

external landau_pdf : float -> float
    = "ml_gsl_ran_landau_pdf" "gsl_ran_landau_pdf" "float"

(* LEVY ALPHA-STABLE *)
external levy : Rng.t -> c:float -> alpha:float -> float 
    = "ml_gsl_ran_levy"

(* LEVY SKEW ALPHA-STABLE *)
external levy_skew : Rng.t -> c:float -> alpha:float -> beta:float -> float 
    = "ml_gsl_ran_levy_skew"

(* GAMMA *)
external gamma : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_gamma"

external gamma_int : Rng.t -> a:int -> float 
    = "ml_gsl_ran_gamma_int"

external gamma_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_gamma_pdf" "gsl_ran_gamma_pdf" "float"

external gamma_mt : Rng.t -> a:int ->  b:float -> float
    = "ml_gsl_ran_gamma_mt"

external gamma_knuth : Rng.t -> a:int ->  b:float -> float
    = "ml_gsl_ran_gamma_knuth"

(* FLAT *)
external flat : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_flat"

external flat_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_flat_pdf" "gsl_ran_flat_pdf" "float"

(* LOGNORMAL *)
external lognormal : Rng.t -> zeta:float -> sigma:float -> float 
    = "ml_gsl_ran_lognormal"

external lognormal_pdf : float -> zeta:float -> sigma:float -> float
    = "ml_gsl_ran_lognormal_pdf" "gsl_ran_lognormal_pdf" "float"

(* CHI-SQUARED *)
external chisq : Rng.t -> nu:float -> float 
    = "ml_gsl_ran_chisq"

external chisq_pdf : float -> nu:float -> float 
    = "ml_gsl_ran_chisq_pdf" "gsl_ran_chisq_pdf" "float"

(* DIRICHLET *)
external dirichlet : Rng.t -> alpha:float array -> theta:float array -> unit
    = "ml_gsl_ran_dirichlet"

external dirichlet_pdf : alpha:float array -> theta:float array -> float
    = "ml_gsl_ran_dirichlet_pdf"

external dirichlet_lnpdf : alpha:float array -> theta:float array -> float
    = "ml_gsl_ran_dirichlet_lnpdf"

(* F DISTRIBUTION *)
external fdist : Rng.t -> nu1:float -> nu2:float -> float 
    = "ml_gsl_ran_fdist"

external fdist_pdf : float -> nu1:float -> nu2:float -> float
    = "ml_gsl_ran_fdist_pdf" "gsl_ran_fdist_pdf" "float"

(* T DISTRIBUTION *)
external tdist : Rng.t -> nu:float -> float 
    = "ml_gsl_ran_tdist"

external tdist_pdf : float -> nu:float -> float 
    = "ml_gsl_ran_tdist_pdf" "gsl_ran_tdist_pdf" "float"

(* BETA *)
external beta : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_beta"

external beta_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_beta_pdf" "gsl_ran_beta_pdf" "float"

(* LOGISTIC *)
external logistic : Rng.t -> a:float -> float 
    = "ml_gsl_ran_logistic"

external logistic_pdf : float -> a:float -> float 
    = "ml_gsl_ran_logistic_pdf" "gsl_ran_logistic_pdf" "float"

(* PARETO *)
external pareto : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_pareto"

external pareto_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_pareto_pdf" "gsl_ran_pareto_pdf" "float"


(* SPHERICAL *)
external dir_2d : Rng.t -> float * float
    = "ml_gsl_ran_dir_2d"

external dir_2d_trig_method : Rng.t -> float * float
    = "ml_gsl_ran_dir_2d_trig_method"

external dir_3d : Rng.t -> float * float * float
    = "ml_gsl_ran_dir_3d"

external dir_nd : Rng.t -> float array -> unit
    = "ml_gsl_ran_dir_nd"

(* WEIBULL *)
external weibull : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_weibull"

external weibull_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_weibull_pdf" "gsl_ran_weibull_pdf" "float"

(* TYPE 1 GUMBEL *)
external gumbel1 : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_gumbel1"

external gumbel1_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_gumbel1_pdf" "gsl_ran_gumbel1_pdf" "float"

(* TYPE 2 GUMBEL *)
external gumbel2 : Rng.t -> a:float -> b:float -> float 
    = "ml_gsl_ran_gumbel2"

external gumbel2_pdf : float -> a:float -> b:float -> float
    = "ml_gsl_ran_gumbel2_pdf" "gsl_ran_gumbel2_pdf" "float"


(* DISCRETE *)
type discrete
external _discrete_preproc : float array -> discrete
    = "ml_gsl_ran_discrete_preproc"

external discrete : Rng.t -> discrete -> int
    = "ml_gsl_ran_discrete" "noalloc"

external discrete_pdf : int -> discrete -> float
    = "ml_gsl_ran_discrete_pdf"

external discrete_free : discrete -> unit
    = "ml_gsl_ran_discrete_free"

let discrete_preproc arr = 
  let d = _discrete_preproc arr in
  Gc.finalise discrete_free d ;
  d


(* POISSON *)
external poisson : Rng.t -> mu:float -> int
    = "ml_gsl_ran_poisson"

external poisson_pdf : int -> mu:float -> float
    = "ml_gsl_ran_poisson_pdf"

(* BERNOULLI *)
external bernoulli : Rng.t -> p:float -> int
    = "ml_gsl_ran_bernoulli"

external bernoulli_pdf : int -> p:float -> float
    = "ml_gsl_ran_bernoulli_pdf"

(* BINOMIAL *)
external binomial : Rng.t -> p:float -> n:int -> int
    = "ml_gsl_ran_binomial"

external binomial_knuth : Rng.t -> p:float -> n:int -> int
    = "ml_gsl_ran_binomial_knuth"

external binomial_tpe : Rng.t -> p:float -> n:int -> int
    = "ml_gsl_ran_binomial_tpe"

external binomial_pdf : int -> p:float -> n:int -> float
    = "ml_gsl_ran_binomial_pdf"

(* MULTINOMIAL *)
external multinomial : Rng.t -> n:int -> p:float array -> int array
    = "ml_gsl_ran_multinomial"

external multinomial_pdf : p:float array -> n:int array -> float
    = "ml_gsl_ran_multinomial_pdf"

external multinomial_lnpdf : p:float array -> n:int array -> float
    = "ml_gsl_ran_multinomial_lnpdf"


(* NEGATIVE BINOMIAL *)
external negative_binomial : Rng.t -> p:float -> n:int -> int
    = "ml_gsl_ran_negative_binomial"

external negative_binomial_pdf : int -> p:float -> n:int -> float
    = "ml_gsl_ran_negative_binomial_pdf"

(* PASCAL *)
external pascal : Rng.t -> p:float -> k:int -> int
    = "ml_gsl_ran_pascal"

external pascal_pdf : int -> p:float -> n:int -> float
    = "ml_gsl_ran_pascal_pdf"

(* GEOMETRIC *)
external geometric : Rng.t -> p:float -> int
    = "ml_gsl_ran_geometric"

external geometric_pdf : int -> p:float -> float
    = "ml_gsl_ran_geometric_pdf"

(* HYPER GEOMETRIC *)
external hypergeometric : Rng.t -> n1:int -> n2:int -> t:int -> int
    = "ml_gsl_ran_hypergeometric"

external hypergeometric_pdf : int -> n1:int -> n2:int -> t:int -> float
    = "ml_gsl_ran_hypergeometric_pdf"

(* LOGARITHMIC *)
external logarithmic : Rng.t -> p:float -> int
    = "ml_gsl_ran_logarithmic"

external logarithmic_pdf : int -> p:float -> float
    = "ml_gsl_ran_logarithmic_pdf"

(* SHUFFLING *)
external shuffle : Rng.t -> 'a array -> unit
    = "ml_gsl_ran_shuffle"

external choose : Rng.t -> src:'a array -> dst:'a array -> unit
    = "ml_gsl_ran_choose"

external sample : Rng.t -> src:'a array -> dst:'a array -> unit
    = "ml_gsl_ran_sample"
