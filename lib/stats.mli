(* gsl-ocaml - OCaml interface to GSL                       *)
(* Copyright (©) 2002-2012 - Olivier Andrieu                *)
(* Distributed under the terms of the GPL version 3         *)


(** Statistics *)

external mean : ?w:float array -> float array -> float = "ml_gsl_stats_mean"
external variance : ?w:float array -> ?mean:float -> float array -> float
  = "ml_gsl_stats_variance"
external sd : ?w:float array -> ?mean:float -> float array -> float
  = "ml_gsl_stats_sd"
external variance_with_fixed_mean :
  ?w:float array -> mean:float -> float array -> float
  = "ml_gsl_stats_variance_with_fixed_mean"
external sd_with_fixed_mean :
  ?w:float array -> mean:float -> float array -> float
  = "ml_gsl_stats_sd_with_fixed_mean"
external absdev : ?w:float array -> ?mean:float -> float array -> float
  = "ml_gsl_stats_absdev"

external skew : ?w:float array -> float array -> float = "ml_gsl_stats_skew"
external skew_m_sd :
  ?w:float array -> mean:float -> sd:float -> float array -> float
  = "ml_gsl_stats_skew_m_sd"
external kurtosis : ?w:float array -> float array -> float
  = "ml_gsl_stats_kurtosis"
external kurtosis_m_sd :
  ?w:float array -> mean:float -> sd:float -> float array -> float
  = "ml_gsl_stats_kurtosis_m_sd"

external lag1_autocorrelation : mean:float -> float array -> float
  = "ml_gsl_stats_lag1_autocorrelation"
external covariance : float array -> float array -> float
  = "ml_gsl_stats_covariance"
external covariance_m :
  mean1:float -> float array -> mean2:float -> float array -> float
  = "ml_gsl_stats_covariance_m"

external max : float array -> float = "ml_gsl_stats_max"
external min : float array -> float = "ml_gsl_stats_min"
external minmax : float array -> float * float = "ml_gsl_stats_minmax"
external max_index : float array -> int = "ml_gsl_stats_max_index"
external min_index : float array -> int = "ml_gsl_stats_min_index"
external minmax_index : float array -> int * int
  = "ml_gsl_stats_minmax_index"
external quantile_from_sorted_data : float array -> float -> float
  = "ml_gsl_stats_quantile_from_sorted_data"
external correlation : float array -> float array -> float
  = "ml_gsl_stats_correlation"
